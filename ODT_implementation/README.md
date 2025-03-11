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

In the following sections, we describe how to install these dependencies, how to test the implementation and how to perform performance measurements.

# Setup
This is the high-level procedure to setup the project:
1. Install the Intel SGX SDK driver (see subsection below)
2. Go into the `scripts/` directory and run the `./setup.sh` script to
   install and setup the following:
   - Build tools for Intel SGX (for Ubuntu)
   - Intel SGX SDK library
   - Intel SGX PSW library
   - Intel SGX SSL library with O-TEE functionality
   - OpenSSL with ODT server functionality
   - Agent application that uses the O-TEE to connect over TLS

The build tools, the SGX SDK library, the SGX PSW library and the SGX
SSL library are installed system wide in `/opt/intel`. The rest are
installed locally in the repository.

Each of the above dependencies has a corresponding script in case one
of the steps fail and you wish to manually retry. You can find
references to other scripts in the `./setup.sh` script. Everything in
the `./setup.sh` script should work on other Linux distributions
except the build tools setup, which we tailored to Ubuntu due to its
popularity. Note that we developed our prototype and scripts on
`Manjaro Linux` with the `6.6.71-1` kernel on an `Intel(R) Core(TM)
i5-10210U CPU @ 1.60GHz` CPU.

**Note that it is important that you are in the `scripts/` directory
when running the `./setup.sh` script and all of the other scripts
referenced in this document!**


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
SGX SDK is supported out-of-the box.

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
randomization (ASLR). In case the script fails you can run the
`./enable_aslr.sh` script to enable ASLR again. Otherwise, ASLR will
be enabled automatically again the next time you restart your device
or when the script runs successfully.

# Timing measurements

In order to perform timing measurements, you must change to the
`scripts/` directory and run the `./runtime_measurement.sh` script. It
will configure and recompile all of the libraries for runtime
measurement and then perform various combinations of timing
measurements needed to construct Table 2 and Table 3 in the Oblivious
Digital Tokens Usenix paper.

Once the measurements are completed you can run
`./analyze_results.py`. The Python script will output the results of
the measurements in the format of Table 2 and Table 3 from the paper.
