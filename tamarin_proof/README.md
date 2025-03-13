# Overview

In the directory you can find the following files:
| Path | Description |
| --- | --- |
| `model.spthy` | Tamarin model of the ODT protocol. |
| `proof.spthy` | The complete proof of all lemmas for the ODT protocol. |
| `partial-proof.spthy` | Proof of the ODT protocol where a non-automatically constructable lemma is already complete. |
| `myoracle.py` | Custom heuristic for proofs. |
| `prove.sh` | Script you can use to verify automatically constructable lemmas. |
| `expected_log_output.txt` | The last 43 lines of the `proof2.log` file that is generated after running `prove.sh`. |

The non-automatically constructable lemma is used to check if the protocol model is executable, i.e. there exists an honest execution of the protocol without adversary interference.
The lemma is not used in the proof of the binding integrity property and serves only as a check that the protocol model works.

# Setup

Before you can open the proof files, make sure to have `python3` installed, as well as [Tamarin](https://tamarin-prover.com/).
We use Tamarin version `1.11.0` and Maude version `3.5`.

Once both are installed, you can explore the proof by starting an interactive Tamarin session by calling the following in the current directory:
```bash
tamarin-prover interactive --derivcheck-timeout=-1 .
```
This opens a local webserver that you can access by going to `http://127.0.0.1:3001`.

Clicking on the `ODT` link next to `./proof.spthy` will load the complete proof. This operation usually takes around 30 minutes.

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
At the end of the log, it should say for all lemmas that they verified successfully. You can compare the output to the `expected_log_output.txt` file.
If you run tamarin in interactive mode as described above, you can inspect the proof file by clicking on `ODT` next to the `proof2.spthy`.
Again, this might take around 30 minutes until the proof is loaded.

Once the proof is loaded, all lemmas on the left side should be
green. Red lines are expected in the last lemma because it is an
`exist-trace` lemma. Only one of the proof paths needs to be solved
for the lemma to count as proven.

Note: there appears to be a bug in the current version of Tamarin
(1.11.0) where the proof output is missing commas (`,`) after the
macro definitions. If the proof file does not appear in the Tamarin
interface, you should perform the following:
- To fix it you must open the `proof2.spthy` file in a text editor and
  add a comma at the end of all lines (except the last one) between
  `macros:` (close to the beginning of the file) and the first `rule
  (modulo E) NP_Init:` definition.
- Alternatively, you can try to downgrade Tamarin to a prior version
  or install a newer version once it is available.

## Performing the proof manually in interactive mode

While not necessary, you can perform the proof manually by starting Tamarin in interactive mode and clicking on `ODT` next to `model.spthy`.
Next, you must repeat the following:
- Click on one of the `by sorry` links on the left side,
- Press `a` on the keyboard to start the autoprover.
- Once the autoprover is complete, Tamarin should focus on the next `by sorry` link.

You can repeat this for all lemmas except the last one. The last lemma is an `exist-trace` lemma whose purpose is to show that the protocol model is executable. Proving this manually is relatively difficult so we do not recommend you try it. If you want to see which choices you have to make to prove it, you can go back to the start page and click on `ODT` next to the `partial-proof.spthy` file. If you scroll down, you will find the proven lemma.

# Proof complexity

We construct the proof on a commodity laptop with an `Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz` CPU, 8 GB of RAM and 10 GB of swap space.
The automatically constructable proof take around 30 minutes to complete.
