#!/bin/bash -e

echo "This script will guide you through the setup process for the Intel SGX SDK and Intel SGX PSW."


# Clone the repository, checkout the correct commit and prepare the repository for compilation on Linux

setup_sgx_sdk_repository() {
    if git clone https://github.com/intel/linux-sgx; then
        echo "Finished cloning repository"
    else
        echo "Error: failed to clone Intel SGX SDK repository"
        exit
    fi
    cd linux-sgx/
    git --no-advice checkout 7385e10ce1106215d15f874a024ca224c7417eea
    cd sdk/cpprt/linux/libunwind/
    ./autogen.sh
    cd ../../../../
    patch -p1 < ../../patches/Intel-SGX-SDK.patch
    echo "Patching file sdk/cpprt/linux/libunwind/configure"
    sed -i 's/for ac_option in --version -v -V -qversion -version; do/for ac_option in --version -v; do/' sdk/cpprt/linux/libunwind/configure
    sed -i 's/for ac_option in --version -v -V -qversion; do/for ac_option in --version -v; do/' sdk/cpprt/linux/libunwind/configure
    echo "Finished Intel SGX SDK repository setup"
    cd ..
}

if [[ -e "linux-sgx/" ]]; then
    echo -n "Intel SGX SDK git repository already exists. Overwrite and setup again? [y/n]: "
    read -r ans
    case "$ans" in
        y | Y)
            rm -rf linux-sgx/
            setup_sgx_sdk_repository
            ;;

        n | N)
            echo "Skipping SGX SDK git repository setup"
            ;;

        *)
            echo "Error"
            exit
            ;;
    esac
else
    setup_sgx_sdk_repository
fi


install_sgx_sdk() {
    echo "Starting Intel SGX SDK installation"
    cd linux-sgx/
    echo "Starting preparation"
    make preparation -j7 -l6
    echo "Finished preparation"
    echo "Starting sdk compilation"
    make sdk -j7 -l6
    echo "Finished sdk compilation"
    echo "Starting sdk installer compilation"
    make sdk_install_pkg -j7 -l6
    echo "Finished sdk installer compilation"
    echo "Running sdk installer"
    sudo ./linux/installer/bin/sgx_linux_x64_sdk_2.25.100.3.bin <<EOF
no
/opt/intel
EOF
    cd ..
}

if [[ -e "/opt/intel/sgxsdk/" ]]; then
    echo -n "Intel SGX SDK already installed. Reinstall? [y/n]: "
    read -r ans
    case "$ans" in
        y | Y)
            sudo /opt/intel/sgxsdk/uninstall.sh
            install_sgx_sdk
            ;;

        n | N)
            echo "Skipping SGX SDK installation"
            ;;

        *)
            echo "Error"
            exit
            ;;
    esac
else
    install_sgx_sdk
fi


install_sgx_psw() {
    echo "Starting Intel SGX PSW installation"
    cd linux-sgx/
    source /opt/intel/sgxsdk/environment
    echo "Starting psw compilation"
    make psw -j7 -l6
    echo "Finished psw compilation"
    echo "Starting psw installer compilation"
    make psw_install_pkg -j7 -l6
    echo "Finished psw installer compilation"
    echo "Running psw installer"
    sudo ./linux/installer/bin/sgx_linux_x64_psw_2.25.100.3.bin
    cd ..
}

if [[ -e "/opt/intel/sgxpsw/" ]]; then
    echo -n "Intel SGX PSW already installed. Reinstall? [y/n]: "
    read -r ans
    case "$ans" in
        y | Y)
            sudo /opt/intel/sgxpsw/uninstall.sh
            install_sgx_psw
            ;;

        n | N)
            echo "Skipping SGX PSW installation"
            ;;

        *)
            echo "Error"
            exit
            ;;
    esac
else
    install_sgx_psw
fi
