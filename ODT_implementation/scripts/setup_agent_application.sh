#!/bin/bash -e

echo "This script will setup the agent application."

if [[ ! -z "${DEPLOY_ENV}" ]]; then
    source /etc/profile
fi

if [[ ! (-e "/opt/intel/sgxsdk" && -e "/opt/intel/sgxpsw") ]]; then
    echo "Error: Intel SGX SDK or SGX PSW not found. Ensure that they are installed before proceeding."
    exit 1
else
    source /opt/intel/sgxsdk/environment
fi

cd ../enclave_application
rm -rf build
mkdir -p build
cd build

echo "Starting agent application compilation"
cmake ..
cmake --build .
