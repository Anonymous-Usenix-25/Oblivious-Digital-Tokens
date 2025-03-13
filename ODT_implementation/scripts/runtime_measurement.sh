#!/bin/bash -e

echo -n "Setup ODT client and server for runtime measurement? [y/n] (You only need to do this if measuring for the first time or you performed heap verification or stack verification previously): "
read -r ans
case "$ans" in
    y | Y)
        ./runtime_measurement_setup.sh
        ;;

    n | N)
        echo "Skipping configuration step"
        ;;

    *)
        echo "Error"
        exit 1
        ;;
esac

echo "Starting measurements"
./perform_runtime_measurement.sh
