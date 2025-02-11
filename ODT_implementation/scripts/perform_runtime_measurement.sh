#!/bin/bash -e

SCRIPTS_DIR=$(pwd)
RESULTS_DIR=$(pwd)/results/
OPENSSL_SERVER_DIR="${SCRIPTS_DIR}/openssl_normal/"
ODT_SERVER_DIR="${SCRIPTS_DIR}/openssl/"
cd ../enclave_application
APPLICATION_DIR=$(pwd)
cd build
APPLICATION_BUILD_DIR=$(pwd)
cd "${SCRIPTS_DIR}/intel-sgx-ssl"
INTEL_SGX_SSL_DIR=$(pwd)
cd ../../timing_measurement
TIMING_MEASUREMENT_DIR=$(pwd)

echo "This script will perform all timing measurements from the paper and output the results of the measurements as seen in the paper"

# Prepare directory for results
cd "${SCRIPTS_DIR}"

if [[ -e "results/" ]]; then
    echo -n "Existing results directory detected. Delete? [y/n]:"
    read -r ans
    case "$ans" in
        y | Y)
            rm -rf results/
            mkdir -p results/
            ;;

        n | N)
            echo "Continuing"
            ;;

        *)
            echo "Error"
            exit
            ;;
    esac
else
    mkdir -p results
fi

echo "Starting OpenSSL server in background (we assume that OpenSSL is installed on the system)"
echo "First, we perform all measurements with a normal OpenSSL server"

cd "${OPENSSL_SERVER_DIR}"
export LD_LIBRARY_PATH="$(pwd)"
./apps/openssl s_server -key server.key -cert server-cert.pem -num_tickets 0 -www -quiet &
SERVER_PID=$!
echo "Server PID=${SERVER_PID}"

echo "Performing measurement for OpenSSL server"
"${TIMING_MEASUREMENT_DIR}"/script-for-server-testing.sh > "${RESULTS_DIR}"/OpenSSL_server_handshake.txt

echo "Performing measurement for ODT client with OpenSSL server"
"${TIMING_MEASUREMENT_DIR}"/ODT-client.sh "${APPLICATION_BUILD_DIR}" > "${RESULTS_DIR}"/ODT_client_OpenSSL_server.txt

echo "Performing measurement for OpenSSL client with OpenSSL server"
"${TIMING_MEASUREMENT_DIR}"/openssl-client.sh "${OPENSSL_SERVER_DIR}" > "${RESULTS_DIR}"/OpenSSL_client_OpenSSL_server.txt

echo "Stopping normal OpenSSL server"
kill "${SERVER_PID}"


echo "Next, we perform all measurements with an ODT server"
echo "Starting ODT server in background"

cd "${ODT_SERVER_DIR}"
export LD_LIBRARY_PATH="$(pwd)"
./apps/openssl s_server -key server.key -cert server-cert.pem -num_tickets 0 -www -quiet &> "${RESULTS_DIR}/ODT_server_ODT_generation.txt.tmp" &
SERVER_PID=$!
echo "Server PID=${SERVER_PID}"

echo "Performing measurement for ODT server"
"${TIMING_MEASUREMENT_DIR}"/script-for-server-testing.sh > "${RESULTS_DIR}"/ODT_server.txt

# Store the results of the ODT generation measurements
cp "${RESULTS_DIR}"/ODT_server_ODT_generation.txt.tmp "${RESULTS_DIR}"/ODT_server_ODT_generation.txt

echo "Performing measurement for ODT client with ODT server"
"${TIMING_MEASUREMENT_DIR}"/ODT-client.sh "${APPLICATION_BUILD_DIR}" > "${RESULTS_DIR}"/ODT_client_ODT_server.txt

echo "Performing measurement for OpenSSL client with ODT server"
"${TIMING_MEASUREMENT_DIR}"/openssl-client.sh "${OPENSSL_SERVER_DIR}" > "${RESULTS_DIR}"/OpenSSL_client_ODT_server.txt


echo "Stopping ODT server"
kill "${SERVER_PID}"

# Delete temporary file
rm "${RESULTS_DIR}"/ODT_server_ODT_generation.txt.tmp
