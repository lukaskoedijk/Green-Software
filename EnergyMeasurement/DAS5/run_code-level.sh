#!/bin/bash
port=3
measure_script="/home/lkoedijk/$port.measure_continues.sh"
kill_measurement="/home/lkoedijk/$port.kill_script.sh"
output_location_base="/var/scratch/lkoedijk/results2/"
output_filename="test.csv"

run() {
    sleep 10
    output_location="$output_location_base$output_filename"
    ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
    ssh lkoedijk@fs0.das4.cs.vu.nl $measure_script -o $output_location -p $port &
    $command > /var/scratch/lkoedijk/output.txt
    ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
}

sleep 10
output_location="/var/scratch/lkoedijk/results2/idle_before.csv"
ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
ssh lkoedijk@fs0.das4.cs.vu.nl $measure_script -o $output_location -p $port &
sleep 60
ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement

for count in {1..30}
do
    file="/var/scratch/lkoedijk/while.py"
    output_filename="port$port.while.$count.csv"
    command="python3 $file 10000"
    echo $command
    run
done

for count in {1..30}
do
    file="/var/scratch/lkoedijk/for.py"
    output_filename="port$port.for.$count.csv"
    command="python3 $file 10000"
    echo $command
    run
done

for count in {1..30}
do
    file="/var/scratch/lkoedijk/sameline.py"
    output_filename="port$port.sameline.$count.csv"
    command="python3 $file 10000"
    echo $command
    run
done

for count in {1..30}
do
    file="/var/scratch/lkoedijk/diffline.py"
    output_filename="port$port.diffline.$count.csv"
    command="python3 $file 10000"
    echo $command
    run
done

sleep 10
output_location="/var/scratch/lkoedijk/results2/idle_after.csv"
ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
ssh lkoedijk@fs0.das4.cs.vu.nl $measure_script -o $output_location -p $port &
sleep 60
ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
