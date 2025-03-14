#!/bin/bash -e

SCRIPTS_DIR=$(pwd)
OPENSSL_SERVER_DIR="${SCRIPTS_DIR}/openssl/"
cd ../enclave_application
APPLICATION_DIR=$(pwd)
cd build
APPLICATION_BUILD_DIR=$(pwd)
cd "${SCRIPTS_DIR}/intel-sgx-ssl"
INTEL_SGX_SSL_DIR=$(pwd)

echo "This script will test the ODT implementation based on stack measurements"

echo "Modifying Intel SGX SSL library to perform stack measurements"
cd "${INTEL_SGX_SSL_DIR}/openssl_source/openssl-3.0.12"
sed -i "s/ODT_VERIFY_HEAP=[[:digit:]]*/ODT_VERIFY_HEAP=0/" Configure
sed -i "s/ODT_VERIFY_STACK=[[:digit:]]*/ODT_VERIFY_STACK=1/" Configure

if [[ ! (-e "/opt/intel/sgxsdk" && -e "/opt/intel/sgxpsw") ]]; then
    echo "Error: Intel SGX SDK or SGX PSW not found. Ensure that they are installed before proceeding."
    exit 1
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
sed -i "s/ODT_PREPARE_HEAP=[[:digit:]]*/ODT_PREPARE_HEAP=0/" CMakeLists.txt
sed -i "s/ODT_PREPARE_STACK=[[:digit:]]*/ODT_PREPARE_STACK=1/" CMakeLists.txt

echo "Compiling agent application"
cd "${SCRIPTS_DIR}"
./setup_agent_application.sh

echo "Disabling ASLR"
echo "0" | sudo tee /proc/sys/kernel/randomize_va_space

# Run application once to obtain stack length and stack offset
echo "Running application to obtain stack length and stack offset"
cd "${APPLICATION_BUILD_DIR}"
env -i ./application aaa -server:127.0.0.1 -port:4433 > app_output_stack 2>&1

# Store the stack length and offset
APPLICATION_STACK_LENGTH=$(grep "Stack length" app_output_stack | sed 's/Stack length: \(\d*\)/\1/')
APPLICATION_STACK_OFFSET=$(grep "Offset of the" app_output_stack | sed 's/Offset of the stack large_array \(\d*\)/\1/')

cd $OPENSSL_SERVER_DIR

if [[ ! -e "server.key" ]]; then
    echo "No existing server key and certificate found"
    echo "Generating new server key and certificate"
    export LD_LIBRARY_PATH=$(pwd)
    ./apps/openssl genrsa -out server.key 4096
    ./apps/openssl req -new -x509 -key server.key -out server-cert.pem -days 365 -config $(pwd)/apps/openssl.cnf <<EOF








EOF
    unset LD_LIBRARY_PATH
else
    echo "Found existing server key and certificate"
fi

echo "Modifying OpenSSL server configuration"
sed -i "s/ODT_VERIFY_HEAP=[[:digit:]]*/ODT_VERIFY_HEAP=0/" Configure
sed -i "s/ODT_VERIFY_STACK=[[:digit:]]*/ODT_VERIFY_STACK=1/" Configure
sed -i "s/ODT_STACK_LENGTH=[[:digit:]]*/ODT_STACK_LENGTH=${APPLICATION_STACK_LENGTH}/" Configure
sed -i "s/ODT_STACK_OFFSET=[[:digit:]]*/ODT_STACK_OFFSET=${APPLICATION_STACK_OFFSET}/" Configure
sed -i "s/ODT_PERFORM_TIMING_MEASUREMENT=[[:digit:]]*/ODT_PERFORM_TIMING_MEASUREMENT=0/" Configure
sed -i "s/ODT_PRINT_DEBUG=[[:digit:]]*/ODT_PRINT_DEBUG=1/" Configure

echo "Compiling OpenSSL server"
./Configure
make all -j7 -l6

echo "Enabling ASLR"
echo "2" | sudo tee /proc/sys/kernel/randomize_va_space
