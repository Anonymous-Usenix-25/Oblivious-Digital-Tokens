# Overview

In the directory you can find the following:
| Path | Description |
| --- | --- |
| `enclave_application/` | Contains code for an agent application that uses an OpenSSL client that is embedded in an Intel SGX enclave. |
| `patches/` | Various patch files used in the ODT setup. |
| `timing_measurement/` | Scripts used to measure the execution speed of the ODT client and ODT server. |
| `complete-results.ods` | The raw timing measurements and the results. |
| `scripts/` | Various scripts that perform steps described in this `README` file. |
| `README.old` | The old version of the README file that describes the individual steps performed by our scripts. |

The ODT prototype requires the following software:
- Intel SGX SDK driver
  - We use the out-of-tree driver because our system only support SGX1
    capabilities
- Intel SGX SDK
- Intel SGX PSW
- Intel SGX SSL
- OpenSSL

In the following sections, we describe how to install these dependencies, how to test the implementation and how to perform performance measurements.

# Setup
There are three ways to setup an ODT implementation:
1. Use a Docker image where the setup is complete.
2. Build the Docker image yourself.
3. Compile and install the ODT implementation directly on your system.

Since all three of these rely on the SGX driver of the operating system, we first explain how to obtain it. Afterwards, we explain each of the three setup options.

## Intel SGX SDK driver installation
The Intel SGX SDK driver should be included in the latest Linux
kernel. However, it works only for devices that have an SGX CPU with
Flexible Launch Control (FLC) support.

Because our CPU does not support FLC, we install the out-of-tree
driver. We obtain the driver for Manjaro from the [AUR
repository.](https://aur.archlinux.org/packages/linux-sgx-driver-dkms-git) If
you are using the `6.6.71-1` kernel, it should install without
errors. Note that it does not compile on newer kernels, and for older
kernels you can try to apply our `patches/PKGBUILD.patch` to the build
files.

For other setups, we recommend switching to one for which the Intel
SGX SDK is supported out-of-the box. For other distributions please take a look at the [Intel SGX driver GitHub repository.](https://github.com/intel/linux-sgx-driver)

## Use a Docker image

You can obtain a Docker image with the complete setup by calling:
```
docker pull mihaell021/setup_complete
```

Afterwards, start an interactive session in the image by calling:
```
docker run -it --device=/dev/isgx -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mihaell021/setup_complete
```

Once inside, you should be in the `scripts` directory. If not, call:
```
cd /ODT_implementation/scripts/
```

## Build the Docker image

To build the docker image, go to the root of the repository and call:
```
docker build -t setup_complete
```

Afterwards, start an interactive session in the image by calling:
```
docker run -it --device=/dev/isgx -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket setup_complete
```

Once inside, you should be in the `scripts` directory. If not, call:
```
cd /ODT_implementation/scripts/
```

## Compile and install the ODT implementation on the system

This is the high-level procedure to setup the project:
1. Install a CMake version that is newer than `3.29`
2. Install Python 3
3. Install the following build tools:
   - [Intel SGX build
     tools](https://github.com/intel/linux-sgx?tab=readme-ov-file#prerequisites)
     - Install both the `required tools to build the Intel(R) SGX SDK`
       and the dependencies specified after `To install the additional
       required tools: `
     - If you are on Ubuntu, you can run our `build_tools_setup.sh`
       script found in the `scripts/` directory to install the SGX
       build tools.
   - [OpenSSL build
     tools](https://github.com/openssl/openssl/blob/master/INSTALL.md#prerequisites)
4. Go into the `scripts/` directory and run the `./setup.sh` script to
   install and setup the following:
   - Intel SGX SDK library
   - Intel SGX PSW library
   - Intel SGX SSL library with O-TEE functionality
   - OpenSSL with ODT server functionality
   - Agent application that uses the O-TEE to connect over TLS
   - A normal OpenSSL installation

The SGX SDK library, the SGX PSW library and the SGX SSL library are
installed system wide in `/opt/intel`. The rest are installed locally
in the `scripts/` directory of the repository. Specifically, the
OpenSSL library with ODT server functionality is installed in
`openssl/`, the agent application is installed in
`enclave_application/`, and the normal OpenSSL is installed in
`openssl_normal/`.

Each of the above dependencies has a corresponding script in case one
of the steps fail and you wish to manually retry. You can find
references to other scripts in the `./setup.sh` script. Everything in
the `./setup.sh` script should work on other Linux distributions. Note
that we developed our prototype and scripts on `Manjaro Linux` with
the `6.6.71-1` kernel on an `Intel(R) Core(TM) i5-10210U CPU @
1.60GHz` CPU.

**Note that it is important that you are in the `scripts/` directory
when running the `./setup.sh` script and all of the other scripts
referenced in this document!**

# Heap verification test

In order to run a heap verification test, you must change to the
`scripts/` directory and run the `./heap_verification.sh` script. It
will configure and recompile all of the libraries for heap
verification and then perform a heap verification test. If successful,
you should see `ODT verification success` printed to the screen.

# Stack verification test

In order to run a stack verification test, you must change to the
`scripts/` directory and run the `./stack_verification.sh` script. It
will configure and recompile all of the libraries for stack
verification and then perform a stack verification test. If
successful, you should see `ODT verification success` printed to the
screen.

Note that the script will temporarily disable address space layout
randomization (ASLR). In case the script fails, you can run the
`./enable_aslr.sh` script to enable ASLR again. Otherwise, ASLR will
be enabled automatically again the next time you restart your device
or when the script runs successfully.

# Timing measurements

In order to perform timing measurements, you must change to the
`scripts/` directory and run the `./runtime_measurement.sh` script. It
will configure and recompile all of the libraries for runtime
measurement and then perform various combinations of timing
measurements needed to construct Table 2 and Table 3 in the Oblivious
Digital Tokens USENIX paper.

Once the measurements are completed, you can run
`./analyze_results.py`. The Python script will output the results of
the measurements in the format of Table 2 and Table 3 from the paper.
