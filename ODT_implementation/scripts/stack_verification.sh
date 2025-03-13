#!/bin/bash -e

echo -n "Setup ODT client and server for stack verification? [y/n] (You only need to do this if verifying for the first time or you performed heap verification or timing measurements previously): "
read -r ans
case "$ans" in
    y | Y)
        ./stack_verification_setup.sh
        ;;

    n | N)
        echo "Skipping configuration step"
        ;;

    *)
        echo "Error"
        exit 1
        ;;
esac

echo "Starting stack verification test"
./stack_verification_test.sh
