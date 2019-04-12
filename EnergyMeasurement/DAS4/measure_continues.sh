#!/bin/bash

# Racktivity PDU "rpdu04" with several DAS-5 nodes is at 10.141.0.195

# This is the last known port to node mapping:
# port 0: unused
# port 1: unused
# port 2: DAS-5/node029
# port 3: DAS-5/node028
# port 4: DAS-5/node027
# port 5: DAS-5/node026
# port 6: DAS-5/node025
# port 7: DAS-5/node024

while getopts "o:p:" opt; do
  case $opt in
    o)
      output=$OPTARG
      ;;
    p)
      port=$OPTARG
      ;;
  esac
done

if ! test "$output" ; then
    echo "-o is obligatory (OUTPUT NAME)"
    exit 1
fi

if ! test "$port" ; then
    echo "-p is obligatory (PORT NODE USING [2-7])"
    exit 2
fi

ip="10.141.0.195"
mib="/var/scratch/versto/Racktivity/ES-RACKTIVITY-MIB.txt"

node=".1.$port"

echo "Power(W), Current(A), Energy(kWH), Time(mS)" > $output
while true
do
querry_time=$(date +"%s%3N")
result=$(snmpwalk -v 1 -Cc -c public -t 9 -M .:/usr/share/snmp/mibs -m $mib $ip EPowerEntry)

power=$(fgrep "pPower$node" <<< "$result")
power_number=$(echo "$power" | grep -o -E '[0-9]+'| tail -1)

current=$(fgrep "pCurrent$node" <<< "$result")
current_number=$(echo "$current" | grep -o -E '[0-9]+'| tail -2 )
current_number=$(echo -n "$current_number" | tr '\n' '.')

energy=$(fgrep "pActiveEnergy$node" <<< "$result")
energy_number=$(echo "$energy" | grep -o -E '[0-9]+'| tail -2 )
energy_number=$(echo -n "$energy_number" | tr '\n' '.')
echo "$power_number, "$current_number", $energy_number, $querry_time" >> $output
done