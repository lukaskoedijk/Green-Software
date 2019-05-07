#!/bin/bash

# run using: nohup prun -v -np [#cpus] -o [name] -t [[[hh:]mm:]ss] -reserve [id] -keep ./run_tests.sh &
# example: nohup prun -v -np 1 -o outputfile -t 60 -reserve [id] -keep ./run_tests.sh

# Port to node configuration
# port 2: DAS-5/node029
# port 3: DAS-5/node028
# port 4: DAS-5/node027
# port 5: DAS-5/node026
# port 6: DAS-5/node025
# port 7: DAS-5/node024

problems=(binarytrees fannkuchredux fasta mandelbrot nbody revcomp spectralnorm)
#echo ${problems[1]}
#input_small=(10 7 1000 200 1000 "0 < revcomp_small.txt" 100)
#input_large=(21 12 25000000 16000 50000000 "0 < revcomp_large.txt" 5500)
input=(10 7 1000 200 1000 "0" 100) #change this one for the other output
command2="/home/lkoedijk/revcomp/revcomp_small.txt" #needs to be cahnged for large

measure_script="/home/lkoedijk/measure_continues.sh"
kill_measurement="/home/lkoedijk/kill_script.sh"
output_location_base="/home/lkoedijk/results/"
output_filename="test.csv"
port=3
count=1

run() {
#sleep 10
    output_location="$output_location_base${problems[problem]}/$output_filename"
    ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
    ssh lkoedijk@fs0.das4.cs.vu.nl $measure_script -o $output_location -p $port &
    $command
    ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
}

run_rev() {
    #sleep 10
    output_location="$output_location_base${problems[problem]}/$output_filename"
    ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
    ssh lkoedijk@fs0.das4.cs.vu.nl $measure_script -o $output_location -p $port &
    $command < $command2
    ssh lkoedijk@fs0.das4.cs.vu.nl $kill_measurement
}

#: <<'END'
#END
: <<'END'
#Binarytrees - Java
problem=0
ids=(2 3 4 6 7)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command
    run
    mv ${problems[$problem]}.java $file
    rm *.class
done

#Fannkuchredux - Java
problem=1
ids=(1 2 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command
    run
    mv ${problems[$problem]}.java $file
    rm *.class
done

#Fasta - Java
problem=2
ids=(2 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command
    run
    mv ${problems[$problem]}.java $file
    rm *.class
done

#Mandelbrot - Java
problem=3
ids=(1 2 3 4 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command
    run
    mv ${problems[$problem]}.java $file
    rm *.class
done

#Nbody - Java
problem=4
ids=(1 2 3 4 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command
    run
    mv ${problems[$problem]}.java $file
    rm *.class
done

#Revcomp - Java
problem=5
ids=(3 4 5 6 8)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command "<" $command2
    run_rev
    mv ${problems[$problem]}.java $file
    rm *.class
done

#Spectralnorm - Java
problem=6
ids=(1 2)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.java-$id.java"
    output_filename="port$port.java-$id.problem$problem.$count.csv"
    mv $file ${problems[$problem]}.java
    javac -d . ${problems[$problem]}.java
    command="java ${problems[$problem]} ${input[$problem]}"
    echo $command
    run
    mv ${problems[$problem]}.java $file
    rm *.class
done
END

: <<'END'
#Binarytrees - JavaScript
problem=0
file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.js"
output_filename="port$port.javascript.problem$problem.$count.csv"
command="node $file ${input[$problem]}"
echo $command
run

#Fannkuchredux - JavaScript
problem=1
ids=(1 3 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.node-$id.node"
    output_filename="port$port.javascript-$id.problem$problem.$count.csv"
    cp -L $file ${problems[$problem]}.js
    command="node ${problems[$problem]}.js ${input[$problem]}"
    echo $command
    run
done

#Fasta - JavaScript
problem=2
ids=(1 2 3 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.node-$id.node"
    output_filename="port$port.javascript-$id.problem$problem.$count.csv"
    cp -L $file ${problems[$problem]}.js
    command="node ${problems[$problem]}.js ${input[$problem]}"
    echo $command
    run
done

#Mandelbrot - JavaScript
problem=3
file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.js"
output_filename="port$port.javascript.problem$problem.$count.csv"
command="node $file ${input[$problem]}"
echo $command
run

#Nbody - JavaScript
problem=4
ids=(1 2 4 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.node-$id.node"
    output_filename="port$port.javascript-$id.problem$problem.$count.csv"
    cp -L $file ${problems[$problem]}.js
    command="node ${problems[$problem]}.js ${input[$problem]}"
    echo $command
    run
done

#Revcomp - JavaScript
problem=5
ids=(2 7)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.node-$id.node"
    output_filename="port$port.javascript-$id.problem$problem.$count.csv"
    cp -L $file ${problems[$problem]}.js
    command="node ${problems[$problem]}.js ${input[$problem]}"
    echo $command "<" $command2
    run_rev
done

#Spectralnorm - JavaScript
problem=6
ids=(1 2 3 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.node-$id.node"
    output_filename="port$port.javascript-$id.problem$problem.$count.csv"
    cp -L $file ${problems[$problem]}.js
    command="node ${problems[$problem]}.js ${input[$problem]}"
    echo $command
    run
done
END

: <<'END'
#Binarytrees - Python3
problem=0
ids=(1 2)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command
    run
done


#Fannkuchredux - Python3
problem=1
ids=(1 2 4 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command
    run
done

#Fasta - Python3
problem=2
ids=(1 2 3)
#5 different output
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command
    run
done

#Mandelbrot - Python3
problem=3
ids=(2 5)
#6 no module numpy
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command
    run
done

#Nbody - Python3
problem=4
ids=(1 2)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command
    run
done

#Revcomp - Python3
problem=5
ids=(4 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command "<" $command2
    $command < $command2
    run_rev
done

#Spectralnorm - Python3
problem=6
ids=(5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.python3-$id.py"
    output_filename="port$port.python3-$id.problem$problem.$count.csv"
    command="python3 $file ${input[$problem]}"
    echo $command
    run
done
END

: <<'END'
#Binarytrees - PHP
problem=0
ids=(1 2 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command
    #run
done

#Fannkuchredux - PHP
problem=1
ids=(1 2 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command
    #run
done

#Fasta - PHP
problem=2
ids=(2 3 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command
    #run
done

#Mandelbrot - PHP
problem=3
ids=(1 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command
    #run
done

#Nbody - PHP
problem=4
id=3
file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
output_filename="port$port.php-$id.problem$problem.$count.csv"
command="php -n $file ${input[$problem]}"
echo $command
#run

#Revcomp - PHP
problem=5
ids=(1 2 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command "<" $command2
    #run
done

#Spectralnorm - PHP
problem=6
ids=(2 3)
#1 parse error
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command
    $command
    #run
done
END
