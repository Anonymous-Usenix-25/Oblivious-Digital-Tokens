#!/bin/bash -e

echo "This script will install build tools for Ubuntu. If you are not on Ubuntu, you might need to check what build tools you will need at https://github.com/intel/linux-sgx?tab=readme-ov-file#prerequisites"

# Setup build tools for Intel SGX SDK
#echo -n "Install build tools? [y/n]: "
#read -r ans
ans="n"
case "$ans" in
    y | Y)
        sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python-is-python3 libssl-dev git cmake perl
        sudo apt-get install libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip pkgconf libboost-dev libboost-system-dev libboost-thread-dev lsb-release libsystemd0
        ;;

    n | N)
        echo "Skipping build tools installation"
        ;;

    *)
        echo "Error"
        exit 1
        ;;
esac
