#!/bin/bash

SCRIPTS_DIR=$(pwd)
OPENSSL_SERVER_DIR="${SCRIPTS_DIR}/openssl/"
cd ../enclave_application
APPLICATION_DIR=$(pwd)
cd build
APPLICATION_BUILD_DIR=$(pwd)
cd "${SCRIPTS_DIR}/intel-sgx-ssl"
INTEL_SGX_SSL_DIR=$(pwd)

echo "This script will test the ODT implementation based on heap measurements"

echo "Starting OpenSSL server in background"
cd "${OPENSSL_SERVER_DIR}"
# Ensure that we are using the modified OpenSSL server and not the system OpenSSL
export LD_LIBRARY_PATH="$(pwd)"
./apps/openssl s_server -key server.key -cert server-cert.pem -num_tickets 0 -www -quiet &
SERVER_PID=$!
echo "Server PID=${SERVER_PID}"

echo "Running client application (supressing output to app_output_heap file)"
cd "${APPLICATION_BUILD_DIR}"
env -i ./application aaa -server:127.0.0.1 -port:4433 > app_output_heap 2>&1

kill "${SERVER_PID}"
