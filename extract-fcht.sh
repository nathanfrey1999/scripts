#!/bin/bash
# NCF
# 07/24/19

file=$1

if [ "$1" = "--help" ] ; then
    echo "This script extracts emission or absoprtion data from an FCHT calculation for use in Excel, where arg1 is the name of the file (most likely 1.out).
The resulting data will be located in a file named data.out in three columns:

Energy(cm^-1) Wavelength(nm) Intensity(microJ*mol^-1) for emission

OR

Energy(cm^-1) Wavelength(nm) Intensity(dm^3*mol^-1*cm^-1) for absorption
"
    exit
fi

if [[ -z $file || ! -f $file  ]]  ; then
    echo OH NO. Something is amiss. This file does not exist!
    exit
fi



printf "\n"
first=` grep -A6 -n 'Legend' 1.out | tail -1 | awk '{print $1}' | sed 's%-%%g' | sed 's%:%%g' `  #| awk -F ' ' '{print $1}'
#awk '/'"$first"'/,/ -----------------------------/' $file | grep -v -- '--' | awk '{print $1}' #> emission.out

energy_array=(`awk 'NR=='"$first"',/ -----------------------------/' $file | grep -v -- '--' | awk '{print $1}'`)

wavelength_array=()

intensity_array=(`awk 'NR=='"$first"',/ -----------------------------/' $file | grep -v -- '--' | awk '{print $2}' | sed -e 's%D%E%g'`)

conversion_factor=10000000

printf "\n"

for i in "${energy_array[@]}"
do
    #printf "%s " ". . . . . . . . . . . . . . . . ."
    wavenumber="$i"
    result=`echo "$conversion_factor / $wavenumber" | bc -l`
    wavelength_array=("${wavelength_array[@]}" "$result")
done

if [ -f "data.out" ] ; then
    rm "data.out"
fi

for (( j = 0 ; j < ${#energy_array[@]} ; j++ ))
do
    echo "${energy_array[$j]}" "${wavelength_array[$j]}" "${intensity_array[$j]}" >> data.out
done
