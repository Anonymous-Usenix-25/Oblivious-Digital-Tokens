#!/bin/bash -e

echo "This script will setup the agent application."

if [[ ! (-e "/opt/intel/sgxsdk" && -e "/opt/intel/sgxpsw") ]]; then
    echo "Error: Intel SGX SDK or SGX PSW not found. Ensure that they are installed before proceeding."
    exit
else
    source /opt/intel/sgxsdk/environment
fi

cd ../enclave_application
mkdir -p build
cd build

echo "Starting agent application compilation"
cmake ..
cmake --build .
