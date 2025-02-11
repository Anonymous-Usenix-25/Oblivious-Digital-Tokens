#!/bin/bash -e

SCRIPTS_DIR=$(pwd)
OPENSSL_SERVER_DIR="${SCRIPTS_DIR}/openssl_normal/"
ODT_SERVER_DIR="${SCRIPTS_DIR}/openssl/"
cd ../enclave_application
APPLICATION_DIR=$(pwd)
cd build
APPLICATION_BUILD_DIR=$(pwd)
cd "${SCRIPTS_DIR}/intel-sgx-ssl"
INTEL_SGX_SSL_DIR=$(pwd)

echo "This script will configure the ODT implementation for timing measurement"
echo "For representative testing, we first setup an unmodified OpenSSL installation using the same version we use for the ODT server"

cd "${SCRIPTS_DIR}"
./setup_openssl.sh

cd "${OPENSSL_SERVER_DIR}"
if [[ ! -e "server.key" ]]; then
    echo "No existing server key and certificate found"
    echo "Generating new server key and certificate"
    ./apps/openssl genrsa -out server.key 4096
    ./apps/openssl req -new -x509 -key server.key -out server-cert.pem -days 365 <<EOF








EOF
else
    echo "Found existing server key and certificate"
fi

echo "Modifying Intel SGX SSL library to perform heap measurements"
cd "${INTEL_SGX_SSL_DIR}/openssl_source/openssl-3.0.12"
sed -i "s/ODT_VERIFY_HEAP=[[:digit:]]*/ODT_VERIFY_HEAP=1/" Configure
sed -i "s/ODT_VERIFY_STACK=[[:digit:]]*/ODT_VERIFY_STACK=0/" Configure

if [[ ! (-e "/opt/intel/sgxsdk" && -e "/opt/intel/sgxpsw") ]]; then
    echo "Error: Intel SGX SDK or SGX PSW not found. Ensure that they are installed before proceeding."
    exit
else
    echo "Sourced SGX SDK environment"
    source /opt/intel/sgxsdk/environment
fi

echo "Re-compiling the OpenSSL client library"
make all -j7 -l6 || true
make all -j7 -l6 || true

echo "Compiling the Intel SGX SSL library"
cd "${INTEL_SGX_SSL_DIR}/Linux"
make all -j7 -l6

echo "Re-installing Intel SGX SSL library"
sudo make install

echo "Modifying agent application configuration for stack measurements"
cd "${APPLICATION_DIR}"
sed -i "s/ODT_DUMP_HEAP=[[:digit:]]*/ODT_DUMP_HEAP=0/" CMakeLists.txt
sed -i "s/ODT_DUMP_STACK=[[:digit:]]*/ODT_DUMP_STACK=0/" CMakeLists.txt
sed -i "s/ODT_PREPARE_HEAP=[[:digit:]]*/ODT_PREPARE_HEAP=1/" CMakeLists.txt
sed -i "s/ODT_PREPARE_STACK=[[:digit:]]*/ODT_PREPARE_STACK=0/" CMakeLists.txt
sed -i "s/ODT_DEBUG=[[:digit:]]*/ODT_DEBUG=0/" CMakeLists.txt

echo "Compiling agent application"
cd "${SCRIPTS_DIR}"
./setup_agent_application.sh

# Run application once to obtain heap
echo "Running application to obtain heap"
cd "${APPLICATION_BUILD_DIR}"
env -i ./application aaa -server:127.0.0.1 -port:4433 > app_output_heap 2>&1

# Store the heap size in a variable
APPLICATION_HEAP_SIZE=$(grep "Heap length" app_output_heap | sed 's/Heap length: \(\d*\)/\1/')

# Copy heap to modified OpenSSL directory
echo "Copying heap to OpenSSL server"
cp app_heap_dump $ODT_SERVER_DIR

cd $ODT_SERVER_DIR

if [[ ! -e "server.key" ]]; then
    echo "No existing server key and certificate found"
    echo "Generating new server key and certificate"
    ./apps/openssl genrsa -out server.key 4096
    ./apps/openssl req -new -x509 -key server.key -out server-cert.pem -days 365 <<EOF








EOF
else
    echo "Found existing server key and certificate"
fi

echo "Modifying ODT server configuration"
sed -i "s/ODT_VERIFY_HEAP=[[:digit:]]*/ODT_VERIFY_HEAP=1/" Configure
sed -i "s/ODT_PERFORM_TIMING_MEASUREMENT=[[:digit:]]*/ODT_PERFORM_TIMING_MEASUREMENT=1/" Configure
sed -i "s/ODT_VERIFY_STACK=[[:digit:]]*/ODT_VERIFY_STACK=0/" Configure
sed -i "s/ODT_PRINT_DEBUG=[[:digit:]]*/ODT_PRINT_DEBUG=0/" Configure


echo "Compiling ODT server"
./Configure
make all -j7 -l6
