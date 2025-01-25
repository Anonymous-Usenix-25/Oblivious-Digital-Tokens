# Overview

In the directory you can find the following files:
| Path | Description |
| --- | --- |
| `model.spthy` | Tamarin model of the ODT protocol. |
| `proof.spthy` | The complete proof of all lemmas for the ODT protocol. |
| `partial-model.spthy` | Model of the ODT protocol where a non-automatically constructable lemma is already complete. |
| `myoracle.py` | Custom heuristic for proofs. |
| `prove.sh` | Script you can use to verify automatically constructable lemmas. |

# Setup

Before you can open the proof files, make sure to have `python3` installed, as well as [Tamarin](https://tamarin-prover.com/).
We use Tamarin version `1.11.0` and Maude version `3.5`.

Once both are installed, you can explore the proof by starting an interactive Tamarin session by calling the following in the current directory:
```bash
tamarin-prover interactive .
```
After some time, this will open a local webserver that you can access by going to `http://127.0.0.1:3001`.

Clicking on the `proof` link will load the complete proof. This operation usually takes some time.

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
This will run Tamarin on the `partial-model.spthy` file and output `proof2.spthy` and `proof2.log`.
At the end of the log it should say that all proofs completed successfully.
If you run tamarin in interactive mode as described above, you can inspect the proof file by clicking on `proof2.spthy`. Again, this might take a while until the proof is loaded.

NB: there appears to be a bug in the current version of Tamarin where the proof output is missing commas (`,`) after the macro definitions. If the proof file does not appear in the Tamarin interface, you should perform the following:
- To fix it you must open the `proof2.spthy` file and add a comma at
  the end of all lines (except the last one) between `macros:` (close
  to the beginning of the file) and the first `rule (modulo E)
  NP_Init:` definition.

# Proof complexity

We construct the proof on a server with 252 GB of memory and with two `Intel Xeon E5-2650 v4` CPUs.
The automatically constructable proofs take around 1232 second to complete.
