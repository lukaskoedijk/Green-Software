#!/bin/bash

# Get all process with measure
process=$(pgrep -u lkoedijk measure)

# Kill all processes
for i in $process
do
kill $i
done
