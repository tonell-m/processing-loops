#!/bin/bash

EXECUTION_COUNT=10

for i in $(seq $EXECUTION_COUNT); do
    # Run the sketch using the Processing CLI (must run this script from the root directory)
    processing-java --sketch=`pwd` --run

    date=$(date '+%Y-%m-%d_%H-%M-%S')

    convert -delay 0 -loop 0 $(ls output/frames/*.png | sort -V) 'output/gif/render_'$date'.gif'
done