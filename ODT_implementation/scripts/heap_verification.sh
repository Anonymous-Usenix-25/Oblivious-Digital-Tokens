#!/bin/bash -e

echo -n "Setup ODT client and server for heap verification? [y/n] (You only need to do this if verifying for the first time or you performed stack verification or timing measurements previously): "
read -r ans
case "$ans" in
    y | Y)
        ./heap_verification_setup.sh
        ;;

    n | N)
        echo "Skipping configuration step"
        ;;

    *)
        echo "Error"
        exit 1
        ;;
esac

echo "Starting heap verification test"
./heap_verification_test.sh
