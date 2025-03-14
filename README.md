# About

This is the artifacts repository for the USENIX25 paper titled "Oblivious Digital Tokens".

# Organization

The repository is organized as follows:
| Path | Description |
| --- | --- |
| `tamarin_proof/` | Contains our Tamarin protocol model as well as the proof for `binding_integrity` and all auxiliary lemmas. |
| `ODT_implementation/` | The implementation of our protocol and the timing measurement scripts. |
| `ODT_implementation/complete-results.ods` | The file containing the timing measurement results and the raw data. |
| `Dockerfile` | A setup script for a Docker container of our ODT implementation. More details are given in the `ODT_implementation/README.md` file. |

For additional instructions please look into the respective directories and their `README.md` files.

# System and hardware requirements

We performed our proofs and developed our prototype on `Manjaro Linux`
with the `6.6.71-1` kernel on an `Intel(R) Core(TM) i5-10210U CPU @
1.60GHz` CPU, 8 GB of RAM and 10 GB of swap space.

The proofs should work on all systems with at least 8 GB of RAM and 10
GB of swap space. The Tamarin software should work on all major
operating systems.

The implementation requires an Intel processor with, at least, SGX1
support and an operating system that supports the Intel SGX driver.
