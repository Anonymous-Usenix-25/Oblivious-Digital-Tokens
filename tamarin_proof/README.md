# Overview

In the directory you can find the following files:
| Path | Description |
| --- | --- |
| `model.spthy` | Tamarin model of the ODT protocol. |
| `proof.spthy` | The complete proof of all lemmas for the ODT protocol. |
| `partial-proof.spthy` | Proof of the ODT protocol where a non-automatically constructable lemma is already complete. |
| `myoracle.py` | Custom heuristic for proofs. |
| `prove.sh` | Script you can use to verify automatically constructable lemmas. |

The non-automatically constructable lemma is used to check if the protocol model is executable, i.e. there exists an honest execution of the protocol without adversary interference.
The lemma is not used in the proof of the binding integrity property and serves only as a check that the protocol model works.

# Setup

Before you can open the proof files, make sure to have `python3` installed, as well as [Tamarin](https://tamarin-prover.com/).
We use Tamarin version `1.11.0` and Maude version `3.5`.

Once both are installed, you can explore the proof by starting an interactive Tamarin session by calling the following in the current directory:
```bash
tamarin-prover interactive .
```
This opens a local webserver that you can access by going to `http://127.0.0.1:3001`.

Clicking on the `proof` link will load the complete proof. This operation usually takes around 30 minutes.

## Encoding error

In case Tamarin shows an encoding error, you can try to run it again as follows:
```bash
LC_ALL=C.UTF-8 tamarin-prover interactive .
```

## Posix error

In case Tamarin shows `posix_spawnp: does not exist (No such file or directory)` ensure that `myoracle.py` is executable:
```bash
chmod +x myoracle.py
```

# Checking the proof

If you wish to check the proof yourself, you can execute:
```bash
./prove.sh
```
This will run Tamarin on the `partial-proof.spthy` file and output `proof2.spthy` and `proof2.log`.
At the end of the log it should say that all proofs completed successfully.
If you run tamarin in interactive mode as described above, you can inspect the proof file by clicking on `proof2.spthy`.
Again, this might take around 30 minutes until the proof is loaded.

Note: there appears to be a bug in the current version of Tamarin where the proof output is missing commas (`,`) after the macro definitions.
If the proof file does not appear in the Tamarin interface, you should perform the following:
- To fix it you must open the `proof2.spthy` file in a text editor and
  add a comma at the end of all lines (except the last one) between
  `macros:` (close to the beginning of the file) and the first `rule
  (modulo E) NP_Init:` definition.

# Proof complexity

We construct the proof on a commodity laptop with an `Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz` CPU, 8 GB of RAM and 10 GB of swap space.
The automatically constructable proof take around 30 minutes to complete.
