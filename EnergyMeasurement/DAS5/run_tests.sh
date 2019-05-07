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
    run
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
    run
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
    run
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
    run
done

#Nbody - PHP
problem=4
id=3
file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
output_filename="port$port.php-$id.problem$problem.$count.csv"
command="php -n $file ${input[$problem]}"
echo $command
run

#Revcomp - PHP
problem=5
ids=(1 2 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.php-$id.php"
    output_filename="port$port.php-$id.problem$problem.$count.csv"
    command="php -n $file ${input[$problem]}"
    echo $command "<" $command2
    run_rev
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
    run
done
END

: <<'END'
#Binarytrees - C#
problem=0
ids=(1 2 3 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command
    run
done

#Fannkuchredux - C#
problem=1
ids=(1 2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command
    run
done

#Fasta - C#
problem=2
ids=(1 2 3 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command
    run
done

#Mandelbrot - C#
problem=3
ids=(1 2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command
    run
done

#Nbody - C#
problem=4
ids=(1 2 3 4 5 6 8)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command
    run
done

#Revcomp - C#
problem=5
ids=(1 2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command "<" $command2
    run_rev
done

#Spectralnorm - C#
problem=6
ids=(1 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.cs"
    output_filename="port$port.cs-$id.problem$problem.$count.csv"
    mcs $file
    command="mono /home/lkoedijk/${problems[$problem]}/${problems[$problem]}.csharp-$id.exe ${input[$problem]}"
    echo $command
    $command
    run
done
END

: <<'END'
#Binarytrees - Ruby
problem=0
ids=(1 2 3 4)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
    output_filename="port$port.yarv-$id.problem$problem.$count.csv"
    command="ruby -W0 $file ${input[$problem]}"
    echo $command
    run
done

#Fannkuchredux - Ruby
problem=1
ids=(1 2)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
    output_filename="port$port.yarv-$id.problem$problem.$count.csv"
    command="ruby -W0 $file ${input[$problem]}"
    echo $command
    run
done

#Fannkuchredux - Ruby
problem=2
ids=(2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
    output_filename="port$port.yarv-$id.problem$problem.$count.csv"
    command="ruby -W0 $file ${input[$problem]}"
    echo $command
    run
done

#Mandelbrot - Ruby
problem=3
ids=(1 2 3 6 7)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
    output_filename="port$port.yarv-$id.problem$problem.$count.csv"
    command="ruby -W0 $file ${input[$problem]}"
    echo $command
    run
done

#Nbody - Ruby
problem=4
id=2
file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
output_filename="port$port.yarv-$id.problem$problem.$count.csv"
command="ruby -W0 $file ${input[$problem]}"
echo $command
run

#Revcomp - Ruby
problem=5
ids=(2 3)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
    output_filename="port$port.yarv-$id.problem$problem.$count.csv"
    command="ruby -W0 $file ${input[$problem]}"
    echo $command "<" $command2
    run_rev
done

#Spectralnorm - Ruby
problem=6
ids=(1 4 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.yarv-$id.yarv"
    output_filename="port$port.yarv-$id.problem$problem.$count.csv"
    command="ruby -W0 $file ${input[$problem]}"
    echo $command
    run
done
END

all_flags=True
: <<'END'
#Binarytrees - C
problem=0
ids=(1 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $id -eq 1 ]
    then
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native $file -o binarytrees.gcc_run -lm
        else
            gcc $file -o binarytrees.gcc_run -lm
        fi
    elif [ $id = 5 ]
    then
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread $file -o binarytrees.gcc_run
        else
            gcc -pthread $file -o binarytrees.gcc_run
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command
    run
    rm binarytrees.gcc_run
done

#Fannkuchredux - C
problem=1
ids=(1 2 3 4 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        if [ $id -eq 1 ] || [ $id -eq 3 ] || [ $id -eq 4 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native  $file -o fannkuchredux.gcc_run
        elif [ $id -eq 2 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread $file -o fannkuchredux.gcc_run
        elif [ $id -eq 5 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp $file -o fannkuchredux.gcc_run
        fi
    else
        if [ $id -eq 1 ] || [ $id -eq 5 ]
        then
            gcc $file -o fannkuchredux.gcc_run
        elif [ $id -eq 2 ]
        then
            gcc -O3 -pthread $file -o fannkuchredux.gcc_run
        elif [ $id -eq 3 ]
        then
            gcc -O3 $file -o fannkuchredux.gcc_run
        elif [ $id -eq 4 ]
        then
            gcc -O3 -march=native $file -o fannkuchredux.gcc_run
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command
    run
    rm fannkuchredux.gcc_run
done

#Fasta - C
problem=2
ids=(1 2 4 5 6 7)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        if [ $id -eq 1 ] || [ $id -eq 4 ] || [ $id -eq 5 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native $file -o fasta.gcc_run
        elif [ $id -eq 2 ] || [ $id -eq 6 ] || [ $id -eq 7 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp $file -o fasta.gcc_run
        fi
    else
        if [ $id -eq 6 ]
        then
            gcc -O3 $file -o fasta.gcc_run
        else
            gcc $file -o fasta.gcc_run
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command
    run
    rm fasta.gcc_run
done

#Mandelbrot - C
problem=3
ids=(1 2 3 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $id -eq 1 ] || [ $id -eq 3 ]
    then
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread -lm $file -o mandelbrot.gcc_run
        else
            gcc -pthread -lm $file -o mandelbrot.gcc_run
        fi
    elif [ $id -eq 2 ]
    then
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native $file -o mandelbrot.gcc_run
        else
            gcc $file -o mandelbrot.gcc_run
        fi
    elif [ $id -eq 6 ]
    then
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -mno-fma -fno-finite-math-only -fopenmp $file -o mandelbrot.gcc_run
        else
            gcc -O3 $file -o mandelbrot.gcc_run
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command
    run
    rm mandelbrot.gcc_run
done

#Nbody - C
problem=4
ids=(1 2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $id -eq 5 ]
    then
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native $file -o nbody.gcc_run
        else
            gcc -march=native $file -o nbody.gcc_run
        fi
    else
        if [ $all_flags ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 $file -o nbody.gcc_run -lm
        else
            gcc nbody.gcc.c -o nbody.gcc_run -lm
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command
    run
    rm nbody.gcc_run
done

#Revcomp - C
problem=5
ids=(1 2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        if [ $id -eq 1 ] || [ $id -eq 2 ] || [ $id -eq 3 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread $file -o revcomp.gcc_run
        elif [ $id -eq 4 ] || [ $id -eq 5 ]
        then
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native $file -o revcomp.gcc_run
        else
            gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp $file -o revcomp.gcc_run
        fi
    else
        if [ $id -eq 1 ] || [ $id -eq 2 ] || [ $id -eq 3 ]
        then
            gcc -pthread $file -o revcomp.gcc_run
        else
            gcc $file -o revcomp.gcc_run
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command "<" $command2
    run_rev
    rm revcomp.gcc_run
done

#Spectralnorm - C
problem=6
ids=(1 3 4 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gcc-$id.c"
    output_filename="allflags$all_flags.port$port.c-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -fopenmp $file -o spectralnorm.gcc_run -lm
    else
        if [ $id -eq 3 ] || [ $id -eq 5 ]
        then
            gcc -O3 $file -o spectralnorm.gcc_run -lm
        elif [ $id -eq 4 ]
        then
            gcc -fopenmp $file -o spectralnorm.gcc_run -lm
        else
            gcc $file -o spectralnorm.gcc_run -lm
        fi
    fi
    command="./${problems[$problem]}.gcc_run ${input[$problem]}"
    echo $command
    run
    rm spectralnorm.gcc_run
done
END

: <<'END'
#Binarytrees - C++
problem=0
id=8
#2 and 6 negative output
file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
if [ $all_flags ]
then
    g++ -c -pipe -O3 -fomit-frame-pointer -march=native -fopenmp $file -o binarytrees.c++.o && g++ binarytrees.c++.o -o binarytrees.gpp_run -fopenmp -lboost_system
else
    g++ -c $file -o binarytrees.c++.o && g++ binarytrees.c++.o -o binarytrees.gpp_run -lboost_system
fi
command="./${problems[$problem]}.gpp_run ${input[$problem]}"
echo $command
run
rm binarytrees.gpp_run

#Fannkuchredux - C++
problem=1
ids=(1 4 6 7)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
    output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
    if [ $id -eq 6 ] || [ $id -eq 7 ]
    then
        if [ $all_flags ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native $file -o fannkuchredux.c++.o && g++ fannkuchredux.c++.o -o fannkuchredux.gpp_run
        else
            g++ -c -march=native $file -o fannkuchredux.c++.o && g++ fannkuchredux.c++.o -o fannkuchredux.gpp_run
        fi
    elif [ $id -eq 1 ]
    then
        if [ $all_flags ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -std=c++11 -pthread $file -o fannkuchredux.c++.o && g++ fannkuchredux.c++.o -o fannkuchredux.gpp_run -lpthread
        else
            g++ -c -pthread $file -o fannkuchredux.c++.o && g++ fannkuchredux.c++.o -o fannkuchredux.gpp_run -lpthread
        fi
    else
        if [ $all_flags ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -pthread $file -o fannkuchredux.c++.o && g++ fannkuchredux.c++.o -o fannkuchredux.gpp_run -lpthread -lboost_thread -lboost_system
        else
            g++ -c $file -o fannkuchredux.c++.o && g++ fannkuchredux.c++.o -o fannkuchredux.gpp_run -lboost_thread
        fi
    fi
    command="./${problems[$problem]}.gpp_run ${input[$problem]}"
    echo $command
    run
    rm fannkuchredux.gpp_run
done

#Fasta - C++
problem=2
ids=(1 2 3 4 5 6)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
    output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
    if [ $id -eq 5 ] || [ $id -eq 6 ]
    then
        if [ $all_flags ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -std=c++11 $file -o fasta.c++.o && g++ fasta.c++.o -o fasta.gpp_run -lpthread
        else
            g++ -c $file -o fasta.c++.o && g++ fasta.c++.o -o fasta.gpp_run -lpthread
        fi
    else
        if [ $all_flags ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 $file -o fasta.c++.o && g++ fasta.c++.o -o fasta.gpp_run
        else
            g++ -c $file -o fasta.c++.o && g++ fasta.c++.o -o fasta.gpp_run
        fi
    fi
    command="./${problems[$problem]}.gpp_run ${input[$problem]}"
    echo $command
    run
    rm fasta.gpp_run
done

#Mandelbrot - C++
problem=3
ids=(2 3 5 6 8 9)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
    output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        if [ $id -eq 6 ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -fopenmp -mno-fma --std=c++14 $file -o mandelbrot.c++.o && g++ mandelbrot.c++.o -o mandelbrot.gpp_run -fopenmp
        elif [ $id -eq 8 ] || [ $id -eq 9 ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -fopenmp $file -o mandelbrot.c++.o && g++ mandelbrot.c++.o -o mandelbrot.gpp_run -fopenmp
        else
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3  $file -o mandelbrot.c++.o && g++ mandelbrot.c++.o -o mandelbrot.gpp_run
        fi
    else
        g++ -c $file -o mandelbrot.c++.o && g++ mandelbrot.c++.o -o mandelbrot.gpp_run
    fi
    command="./${problems[$problem]}.gpp_run ${input[$problem]}"
    echo $command
    run
    rm mandelbrot.gpp_run
done

#Nbody - C++
problem=4
ids=(1 3 4 5 6 7 8)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
    output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 $file -o nbody.c++.o && g++ nbody.c++.o -o nbody.gpp_run
    else
        if [ $id -eq 4 ]
        then
            g++ -c -march=native $file -o nbody.c++.o && g++ nbody.c++.o -o nbody.gpp_run
        else
            g++ -c $file -o nbody.c++.o && g++ nbody.c++.o -o nbody.gpp_run
        fi
    fi
    command="./${problems[$problem]}.gpp_run ${input[$problem]}"
    echo $command
    run
    rm nbody.gpp_run
done

#Revcomp - C++
problem=5
ids=(1 2 3 4 5)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
    output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        if [ $id -eq 2 ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -fopenmp $file -o revcomp.c++.o && g++ revcomp.c++.o -o revcomp.gpp_run -fopenmp
        elif [ $id -eq 4 ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -std=c++11 -mtune=native -mfpmath=sse -msse2 $file -o revcomp.c++.o && g++ revcomp.c++.o -o revcomp.gpp_run -pthread
        else
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native $file -o revcomp.c++.o && g++ revcomp.c++.o -o revcomp.gpp_run
        fi
    else
        if [ $id -eq 4 ]
        then
            g++ -c $file -o revcomp.c++.o && g++ revcomp.c++.o -o revcomp.gpp_run -pthread
        else
            g++ -c $file -o revcomp.c++.o && g++ revcomp.c++.o -o revcomp.gpp_run
        fi
    fi
    command="./${problems[$problem]}.gpp_run ${input[$problem]}"
    echo $command "<" $command2
    run_rev
    rm revcomp.gpp_run
done

#Spectralnorm - C++
problem=6
ids=(1 5 6 8)
for id in ${ids[*]}
do
    file="/home/lkoedijk/${problems[$problem]}/${problems[$problem]}.gpp-$id.c++"
    output_filename="allflags$all_flags.port$port.c++-$id.problem$problem.$count.csv"
    if [ $all_flags ]
    then
        if [ $id -eq 1 ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3  $file -o spectralnorm.c++.o && g++ spectralnorm.c++.o -o spectralnorm.gpp_run
        elif [ $id -eq 6 ]
        then
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -fopenmp $file -o spectralnorm.c++.o && g++ spectralnorm.c++.o -o spectralnorm.gpp_run -fopenmp
        else
            g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -fopenmp -O0 $file -o spectralnorm.c++.o && g++ spectralnorm.c++.o -o spectralnorm.gpp_run -fopenmp
        fi
    else
        if [ $id -eq 1 ]
        then
            g++ -c $file -o spectralnorm.c++.o && g++ spectralnorm.c++.o -o spectralnorm.gpp_run
        else
            g++ -c -fopenmp $fle -o spectralnorm.c++.o && g++ spectralnorm.c++.o -o spectralnorm.gpp_run -fopenmp
        fi
    fi
    command="./${problems[$problem]}.gpp_run ${input[$problem]}"
    echo $command
    $command
#run
    rm spectralnorm.gpp_run
done
END
