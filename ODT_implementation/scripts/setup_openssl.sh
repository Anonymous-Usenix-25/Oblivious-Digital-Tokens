#!/bin/bash -e

echo "This script will guide you through the setup process for the OpenSSL library."

if [[ ! -z "${DEPLOY_ENV}" ]]; then
    source /etc/profile
fi

setup_openssl_repository() {
    if git clone https://github.com/openssl/openssl/ openssl_normal/; then
        echo "Finished cloning repository"
    else
        echo "Error: failed to clone OpenSSL repository"
        exit 1
    fi
    cd openssl_normal/
    git checkout 707b54bee2
    echo "Compiling OpenSSL"
    ./config
    make all -j7 -l6
}

if [[ -e "openssl_normal/" ]]; then
    if [[ ! -z "${DEPLOY_ENV}" ]]; then
        ans="y"
    else
        echo -n "OpenSSL git repository already exists. Overwrite and patch? [y/n]: "
        read -r ans
    fi
    case "$ans" in
        y | Y)
            rm -rf openssl_normal/
            setup_openssl_repository
            ;;

        n | N)
            echo "Skipping OpenSSL git repository setup"
            ;;

        *)
            echo "Error"
            exit 1
            ;;
    esac
else
    setup_openssl_repository
fi
