#!/bin/bash -e

echo "This script will guide you through the setup process for the Intel SGX SSL library that is modified to work with ODTs."


if [[ ! (-e "/opt/intel/sgxsdk" && -e "/opt/intel/sgxpsw") ]]; then
    echo "Error: Intel SGX SDK or SGX PSW not found. Ensure that they are installed before proceeding."
    exit
else
    source /opt/intel/sgxsdk/environment
fi

setup_sgx_ssl_repository() {
    if git clone https://github.com/intel/intel-sgx-ssl; then
        echo "Finished cloning repository"
    else
        echo "Error: failed to clone Intel SGX SSL repository"
        exit
    fi
    cd intel-sgx-ssl/
    git --no-advice checkout support_tls_openssl3
    cd openssl_source/
    wget "https://github.com/openssl/openssl/releases/download/openssl-3.0.12/openssl-3.0.12.tar.gz"
    cd ../..
}

if [[ -e "intel-sgx-ssl/" ]]; then
    echo -n "Intel SGX SSL git repository already exists. Overwrite? [y/n]: "
    read -r ans
    case "$ans" in
        y | Y)
            rm -rf intel-sgx-ssl/
            setup_sgx_ssl_repository
            ;;

        n | N)
            echo "Skipping SGX SSL git repository setup"
            ;;

        *)
            echo "Error"
            exit
            ;;
    esac
else
    setup_sgx_ssl_repository
fi

patch_and_install_sgx_ssl() {
    cd intel-sgx-ssl/Linux
    echo "Starting Intel SGX SSL patching and installation"
    make all -j7 -l6 > /dev/null 2>&1
    echo "Patching build_openssl.sh"
    sed -i 's/rm -rf $OPENSSL_VERSION/# rm -rf $OPENSSL_VERSION/' build_openssl.sh
    sed -i 's/tar xvf $OPENSSL_VERSION.tar.gz || exit 1/# tar xvf $OPENSSL_VERSION.tar.gz || exit 1/' build_openssl.sh
    cd ../openssl_source/openssl-3.0.12
    echo "Patching OpenSSL with ODT client functionality"
    patch -p1 < ../../../../patches/ODT-client.patch
#    echo "Compiling OpenSSL"
#    make all -j7 -l6 > /dev/null 2>&1
#    make all -j7 -l6 > /dev/null 2>&1
    cd ../../Linux
    echo "Compiling Intel SGX SSL"
    make all -j7 -l6 > /dev/null 2>&1
    echo "Installing Intel SGX SSL"
    sudo make install -j7 -l6 > /dev/null 2>&1
    echo "Finished Intel SGX SSL installation"
    cd ../../
}

if [[ -e "/opt/intel/sgxssl/" ]]; then
    echo -n "Intel SGX SSL already installed. Reinstall? [y/n]: "
    read -r ans
    case "$ans" in
        y | Y)
            sudo rm -rf /opt/intel/sgxssl
            patch_and_install_sgx_ssl
            ;;

        n | N)
            echo "Skipping SGX SSL installation"
            ;;

        *)
            echo "Error"
            exit
            ;;
    esac
else
    patch_and_install_sgx_ssl
fi
