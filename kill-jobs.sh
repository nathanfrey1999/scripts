#!/bin/bash
# NCF
# 07/31/19

if [ "$1" = "--help" ] ; then
    echo "This script kills the job running from the current directory. NOTE: This version of the script only works for Slurm, not PBS."

exit

fi

directory=`pwd`

number=`~/bin/jobs.sh | grep $directory | awk '{print $3}' `

echo "Are you sure you want to kill $number from $directory? This is your last chance! (y/n)"
    read response
    if [ $response = "y" ]; then
        echo "Killing job $number"
        scancel $number
        exit
    else
    echo "Sweet! Job $number is still running!"
    fi
    exit
