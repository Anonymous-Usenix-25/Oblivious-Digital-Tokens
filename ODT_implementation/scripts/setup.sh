#!/bin/bash -e

echo "This script will go through all of the setup scripts in order. It will also configure the code for heap verification testing."

./setup_intel_sgx.sh
./setup_intel_ssl_with_ODT_client.sh
./setup_openssl_with_ODT_server.sh
./setup_agent_application.sh
./setup_openssl.sh
