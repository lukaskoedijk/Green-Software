#!/bin/bash
#SBATCH -N 1 -w "node028"

# PLEASE CHANGE TO YOUR HOME DIRECTORY
measure_script="/home/skok/PDU/measure_continues.sh"
kill_measurement="/home/skok/PDU/kill_script.sh"
output_location="/home/skok/results/"

while getopts "o:" opt; do
  case $opt in
    o)
      output=$OPTARG
      ;;
  esac
done

if ! test "$output" ; then
    echo "-o is obligatory (OUTPUT NAME)"
    exit 1
fi
# output="pebble-test-1"
port=3

echo "Measurement script (DAS-4): $measure_script"
echo "Kill script (DAS-4): $kill_measurement"
output="$output_location$output.csv"
echo "Output file (DAS-4): $output"

# Cooldown system
sleep 10

# make sure no measurement is running
ssh skok@fs0.das4.cs.vu.nl $kill_measurement

# Start measurement
ssh skok@fs0.das4.cs.vu.nl $measure_script -o $output -p $port &

# Run program
#for i in `seq 2000`
#do
java -jar programs/classmate-longmethod-30000-java1.8.jar
#done

# Stop measurement
ssh skok@fs0.das4.cs.vu.nl $kill_measurement

# Copy to das-t if you want
scp skok@fs0.das4.cs.vu.nl:$output /home/skok

