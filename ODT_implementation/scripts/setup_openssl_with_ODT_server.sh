#!/bin/bash -e

echo "This script will guide you through the setup process for the OpenSSL library that is modified to work with ODTs."

setup_and_patch_openssl_repository() {
    if git clone https://github.com/openssl/openssl/; then
        echo "Finished cloning repository"
    else
        echo "Error: failed to clone OpenSSL repository"
        exit 1
    fi
    cd openssl/
    git checkout 707b54bee2
    echo "Patching repository with ODT server functionality"
    git apply ../../patches/ODT-server.patch
    echo "Compiling OpenSSL"
    ./config
    make all -j7 -l6
}

if [[ -e "openssl/" ]]; then
    echo -n "OpenSSL git repository already exists. Overwrite and patch? [y/n]: "
    ans="y"
    case "$ans" in
        y | Y)
            rm -rf openssl/
            setup_and_patch_openssl_repository
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
    setup_and_patch_openssl_repository
fi
