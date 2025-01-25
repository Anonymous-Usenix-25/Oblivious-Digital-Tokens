# Overview

In the directory you can find the following:
| Path | Description |
| --- | --- |
| `/enclave_application` | Contains code for an agent application that uses an OpenSSL server that is embedded in an Intel SGX enclave. |
| `/patches` | Various patch files used in the ODT setup. |
| `/timing_measurement` | Scripts used to measure the execution speed of the ODT client and ODT server. |
| `complete-results.ods` | The raw timing measurements and the results. |

The project and testing require the following software:
- Intel SGX SDK driver
  - We use the out-of-tree driver because our system does not support
      Flexible Launch Control (FLC)
- Intel SGX SDK
- Intel SGX PSW
- Intel SGX SSL

We describe how to install each of them in the next section.
We provide testing instructions after the installation instructions.

# Setup
This is the high-level procedure to setup the project:
1. Install the Intel SGX SDK driver, SDK and PSW.
2. Install the Intel SGX SSL library.
   - Patch the OpenSSL library included with the Intel SGX SSL
     installation to support ODT client operation.
3. Download OpenSSL and patch it to support ODT server operation.
4. Compile an agent application that uses the patched Intel SGX SSL
   library to connect to the patched ODT server.

Note that we developed our prototype on `Manjaro Linux` with the
`6.6.71-1` kernel on an `Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz`
CPU. For other systems, follow the installation instructions found at
Github pages of the original libraries.

## Intel SGX SDK driver installation
The Intel SGX SDK driver should be included in the latest Linux
kernel. However, it works only for devices that have an SGX CPU with
Flexible Launch Control (FLC) support.

Because our CPU does not support FLC, we install the out-of-tree
driver. We obtain the driver for Manjaro from the [AUR
repository](https://aur.archlinux.org/packages/linux-sgx-driver-dkms-git). If
you are using the `6.6.71-1` kernel, it should install without
errors. Note that it does not compile on newer kernels, and for older
kernels you can try to apply our `patches/PKGBUILD.patch` to the build
files.

## Intel SGX SDK & PSW installation
Since SGX SDK is not provided for `Manjaro Linux`, we build everything
from source. For other distributions or prerequisites for manual
compilation check out the installation instructions in [the
repository.](https://github.com/intel/linux-sgx). Tip: for most `make`
commands, you can use the `-j` and `-l` flags to speed up compilation.

1. Clone the repository from
   [here](https://github.com/intel/linux-sgx) and `git checkout`
   commit `7385e10ce1106215d15f874a024ca224c7417eea`.
2. Follow the instructions from this [Github
   issue](https://github.com/intel/linux-sgx/issues/1066) to prepare
   the repository for compilation on Linux.
2. Compile and install the SGX SDK library as follows:
   - `make preparation`
   - `make sdk`
   - `make sdk_install_pkg`
   - Call `./linux/installer/bin/sgx_linux_x64_sdk_2.25.100.3.bin` to
     start the installation process
     - Install the SDK into the `/opt/intel` directory
3. Make sure you are in a `bash` shell and `source` the
   `/opt/intel/sgxsdk/environment` file.
4. Compile and install the SGX PSW library as follows:
   - `make psw`
   - `make psw_install_pkg`
   - Call `./linux/installer/bin/sgx_linux_x64_psw_2.25.100.3.bin` to
     start the installation process

## Intel SGX SSL installation
We use the `support_tls_openssl3` branch of the library:
https://github.com/intel/intel-sgx-ssl/tree/support_tls_openssl3

1. Clone the repository from
   [here](https://github.com/intel/intel-sgx-ssl) and `git checkout` the
   branch `support_tls_openssl3`
2. Make sure you are in a `bash` shell and `source` the
   `/opt/intel/sgxsdk/environment` file.
3. Download the `openssl-3.0.12.tar.gz` archive from
   [GitHub](https://github.com/openssl/openssl/releases/tag/openssl-3.0.12)
   and put it into the `openssl_source` directory (leave it archived).
4. Go back to the root of the repository, `cd` into the `Linux`
   directory (make sure you are not in the `openssl_source/Linux`
   directory) and run `make all` once.
   - The OpenSSL archive is now extracted in the
     `openssl_source/openssl-3.0.12` directory
5. Modify the `Linux/build_openssl.sh` script as follows:
```bash
# rm -rf $OPENSSL_VERSION
# tar xvf $OPENSSL_VERSION.tar.gz || exit 1
```
    - Commenting out those lines ensures that our OpenSSL patch in the
      next step does not get overwritten.
6. Apply `patches/ODT-client.patch` to the OpenSSL library (version
   3.0.12) found in the `openssl_source` directory to add ODT support
   to it.
   - Call `patch -p1 < ./path/to/OTD-client.patch` when you are inside
     of the `openssl_source/openssl-3.0.12`.
     - Make sure to adjust `./path/to/OTD-client.patch` to the
       relative path where the `ODT-client.patch` is stored.
   - Run `make all` twice in the `openssl_source/openssl-3.0.12`
     directory to build the OpenSSL library
7. Go back to the `Linux` directory in the root of the repository and
   run `make all` and `sudo make install`.

## OpenSSL ODT server setup
Clone the [OpenSSL repository](https://github.com/openssl/openssl/)
and checkout the `707b54bee2` commit.

1. Apply `patches/ODT-server.patch` to the OpenSSL library using `git apply`.
2. Run `./config` and `make all` in the OpenSSL directory.

## Agent enclave application setup
Make sure again that you are in a `bash` shell and you have called
`source /opt/intel/sgxsdk/environment`. Create a `build` directory
inside of the `enclave_application` directory, switch to it, and call:

```bash
cmake ..
cmake --build .
```

# Heap verification test
The client and server are by default configured for heap
verification. If you wish to test this out follow the steps
bellow. For stack verification, see next section.

For heap verification, we assume the ODT server can get the memory
contents of the agent through a covert channel. We simulate this by
making the agent dump its heap contents into a file. The file should
then be copied into the root directory of the ODT server. All steps
are described in the following subsections.

## ODT client

1. Switch to the agent application build directory
   `enclave_application/build`.
2. Start the application by running the following command:
```bash
./application aaa -server:127.0.0.1 -port:4433
```
    - Once launched, the application dumps its heap into
      `app_heap_dump`.
    - Copy this file into the root directory of the OpenSSL ODT
      server.
    - Also, note down the `Heap length: XXXXX` output from the
      client. In the next section we use the value to tell the web
      server the length of the heap it is measuring.
3. Start the ODT server according to the next subsection and then
   rerun the ODT client to get a successful verification.

## ODT server

1. Switch to the OpenSSL ODT server root directory
2. Set the `LD_LIBRARY_PATH` to `.` by calling `export LD_LIBRARY_PATH .`
3. Generate an RSA key and self-signed certificate.
   - `./apps/openssl genrsa -out server.key 4096` generates a key
   - `./apps/openssl req -new -x509 -key server.key -out
     server-cert.pem -days 365` generates a self-signed certificate.
     - You can leave all of the certificate fields empty.
4. Modify the length of the heap the server expects to measure
   - In the `Configure` file on line 1729, set the `ODT_HEAP_LENGTH`
     to the `XXXXX` value noted down in the previous section when
     running the ODT client.
   - Call `make all` twice to recompile the library.
5. Start the ODT server by running the following command:
```bash
./apps/openssl s_server -key <path_to_key> -cert <path_to_cert> -num_tickets 0 -www -quiet
```
6. Rerun the ODT client in a parallel terminal. The server should say
   that the verification was successful.


# Stack verification test
Stack verification demonstrates how a server can verify a client
without the need to forward any data. Both the client and the server
generate a seeded array of random values. If the measurements are
performed inside of this array, then the verification succeeds.

To configure the code for stack testing we must change two
configuration files and disable address space layout randomization
(ASLR).

The requirement to disable ASLR is a limitation of our current
implementation and not of our scheme's design. One could modify the
kernel with an interface for getting the top and bottom address of the
stack that is only accessible to the enclave. This way the stack
measurements would always be performed relative to the stack
itself. However, this goes beyond the scope of our prototype.

## Configuration changes

1. Open the `Configure` file in the `openssl_source/openssl-3.0.12`
   directory of the Intel SGX SSL library.
   - Set `ODT_VERIFY_HEAP` to `0` and `ODT_VERIFY_STACK` to `1`
     (line 1646).
   - Recompile the OpenSSL library by running `make all` twice. This
     is necessary to detect changes in the configuration.
   - Recompile and reinstall the Intel SGX SSL library by running
     `make all` and `sudo make install` in the top level `Linux`
     directory (not the `openssl_source/Linux` directory).
2. Open the `CMakeLists.txt` file in the root of the agent application
   and set `ODT_DUMP_HEAP` and `ODT_PREPARE_HEAP` to `0`, and set
   `ODT_PREPARE_STACK` to `1`.
   - Recompile the agent enclave application by calling the following
     commands in the `build` directory you created in the previous
     steps:
```bash
cmake ..
cmake --build .
```
3. Disable ASLR by running `echo 0 | sudo tee
   /proc/sys/kernel/randomize_va_space`
   - You can enable it again by using `echo 2` instead.
4. Run the agent application as follows:
```bash
./application aaa -server:127.0.0.1 -port:4433
```
    - Note down the `Stack length: XXXX` and `Offset of the stack
      large_array YYYY` values for the next step.
5. Open the `Configure` file in the root directory of the ODT OpenSSL
   server and set `ODT_STACK_LENGTH` and `ODT_STACK_OFFSET` to the
   aforementioned values.
   - The offset might not need to be changed, depending on your
     environment.
   - Furthermore, set `ODT_VERIFY_HEAP` to `0` and `ODT_VERIFY_STACK`
     to `1`.
   - Recompile the ODT OpenSSL library and then start the web server
     (for instructions on how to prepare the key and certificate see
     server instructions in the previous section):
```bash
./apps/openssl s_server -key <path_to_key> -cert <path_to_cert> -num_tickets 0 -www -quiet
```

You can start the ODT OpenSSL server and run the ODT client
application to check that stack verification is working properly.

# Timing measurements

We perform all timing measurements using heap verification and all
debugging disabled. Follow the next steps to prepare all libraries and
the agent application for measurement testing.

1. Open the `Configure` file in the root directory of the ODT OpenSSL
   server.
   - Set `ODT_VERIFY_STACK` and `ODT_PRINT_DEBUG` to `0`
   - Set `ODT_VERIFY_HEAP` and `ODT_PERFORM_TIMING_MEASUREMENT` to `1`
   - Recompile the ODT OpenSSL server
2. Open the `Configure` file in the root directory of the Intel SGX
   SSL OpenSSL library.
   - Set `ODT_VERIFY_STACK` to `0`
   - Set `ODT_VERIFY_HEAP` to `1`
   - Recompile the OpenSSL library.
   - Recompile and reinstall the Intel SGX SSL library.
3. Open the `CMakeLists.txt` file in the root directory of the agent
   application.
   - Set `ODT_DUMP_HEAP` and `ODT_DUMP_STACK` to `0`
   - Set `ODT_PREPARE_STACK` to `0`
   - Set `ODT_PREPARE_HEAP` to `1`
   - Set `ODT_DEBUG` to `0`
   - Recompile the agent application.


## Measuring ODT client performance

1. Start either a normal OpenSSL server or the modified ODT OpenSSL
   server
   - Linux distributions usually have OpenSSL already installed. If
     not, you can compile a fresh version of OpenSSL without the ODT
     patch and use the same command line option that is used to start
     the modified ODT OpenSSL server.
2. Run the `ODT-client.sh` script from the `timing_measurement` directory
   - The script takes as the first argument the absolute path to the
     `build/` directory of the agent application.
   - The output of the script is a pair of values separated by a
     comma.
     - The first value represents the time taken to create and send
     the heartbeat message.
     - The second value is the total time taken for the application to
     run. This includes starting the enclave and doing a TLS
     handshake.
   - You can redirect (`>`)the output of the script into a file. Only
     the measurements will be redirected, the indices are output on
     standard error.

## Measuring OpenSSL client performance

1. Same as the first step above.
2. Run the `openssl-client.sh` script from the `timing_measurement`
   directory.
   - The script takes as the first argument the absolute path to a
     directory where an unmodified OpenSSL library is installed.
     - We used the system provided library found in `/usr/bin/`
   - The output of the script is a single value. It is the total time
     taken for the OpenSSL client to run a single handshake with the
     server.
   - Similarly to the previous script, you can store the timing output
     by redirecting (`>`) it into a file.

## Measuring ODT server performance

1. Start the modified ODT server.
   - If the `ODT_PERFORM_TIMING_MEASUREMENT` flag is set to `1`, the
     server outputs a pair of values separated by a comma.
     - The first values is the total time taken to generate the
     `ServerHello` nonce. This includes calculating `v` and applying
     Elligator to it.
     - The second value is the time taken to apply Elligator encoding
       to `v`.
     - The difference of these two values is the time taken to
       calculate `v`.
2. With the ODT server running, start the `script-for-server-testing.sh` script from the
   `timing_measurement` directory.
   - The script outputs the time the ODT server took to respond to the
     handshake from the perspective of an unmodified TLS client.

## Measuring OpenSSL server performance

1. Start a normal OpenSSL server.
   - You can use the same command you use for starting the ODT server,
     but you need to replace the path to the key and certificate with
     the correct paths.
2. Run the `script-for-server-testing.sh` script from the
   `timing_measurement` directory.
   - The script outputs the time the OpenSSL server took to respond to
     the handshake.
