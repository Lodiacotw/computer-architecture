#! /bin/bash

configPool="cache1 cache2"
benchPool="reference1 reference2"
timeLimit=60

root=$( pwd )
outputDir=$root/output
studentDir=$root/student
benchDir=$root/testcases/bench
configDir=$root/testcases/config
verifyBin=$root/verifier/verify
chmod 744 $verifyBin
chmod 744 ./verifier/verify
binaryName=project

function executionCmd ()
{
	local argv="$configDir/$1.org $benchDir/$2.lst $outputDir/index.rpt"
	local log=$( ( time -p timeout $timeLimit ./$binaryName $argv ) 2>&1 > /dev/null )
	if [[ $log =~ "perl -e" ]]; then
		echo "TLE"
	else
		echo "$( echo "$log" | grep real | cut -d ' ' -f 2 )"
	fi
}

function verifyCmd ()
{
	#local argv="$configDir/$1.org $benchDir/$2.lst $outputDir/index.rpt"
	local log=$( ../verifier/verify ../testcases/config/$1.org ../testcases/bench/$2.lst ../output/index.rpt | cat )
    
	if [[ $log =~ "Congratulations!!" ]]; then
		echo "Success"
	else
		echo "Fail"
	fi
}



echo "|---------------------------------------------------------|"
echo "|                                                         |"
echo "|    This script is used for CA final project grading.    |"
echo "|                                                         |"
echo "|---------------------------------------------------------|"

cd $studentDir/
printf " Configuration file  |        Testbench        |  Miss count  |  Runtime  |  Status\n"
for config in $configPool; do
    for bench in $benchPool; do
        printf "%20s | %23s |" $config $bench

        runtime=$( executionCmd $config $bench )

        if [[ $runtime != "TLE" ]]; then
            status=$( verifyCmd $config $bench )

            if [[ $status == "Success" ]]; then
                miss_count=$( cat ../output/index.rpt | grep 'Total cache miss count:' | cut -d ' ' -f 5 )
            else
                fail_flag="1"
                miss_count="Wrong"
            fi

        else
            fail_flag="1"
            miss_count="TLE"
            status="TLE"
        fi

        printf "%13s | %9s |  %s\n" $miss_count $runtime "$status"

    done
done

if [[ $fail_flag == "1" ]]; then
    printf "Something's wrong I can feel it. \n"

else
    printf "Congratulations !! Your work passes all basic cases. \n"
fi
