#!/bin/bash
# NCF 06/11/2024
# arg1 = "--help" prints the help for the script
#

file=$1

if [ "$1" = "--help" ] ; then
    echo "This script extracts the following information out of an Orca output file:
          1.) If the optimization converged
          2.) If the frequency finished properly
          3.) If there are any imaginary Frequencies
          *************************
          4.) Electronic Energy (a.u.)
          5.) Electronic + Thermal Energies (a.u.)
          6.) Enthalpy (a.u.)
          7.) Free Energy (a.u.)
          8.) Basis Functions
          9.) Number of Atoms
          10.) Working Directory
          *************************
          Lines 4-10 in column format, delimited by = (for easy Excel implementation)
"
exit
fi

if [[ -z $file || ! -f $file  ]]  ; then
    printf "OH NO. Something is amiss. This file does not exist!\n"
    printf "For help on how to use this script, run the command: "
    printf '\e[32m%s\e[0m' "extract-data.sh --help"
    printf "\n"
    exit

else

    printf "*************************\n"

    hurray=`grep HURRAY $1 | wc -l`

    if [ $hurray -ne 0 ]
    then
        printf "Hurray! The optimization finished successfully\n"
    else
        printf "The optimization did not finish properly or has not finished yet\n"
    fi

    analytical_frequency=`grep "Analytical frequency calculation" 1.out | wc -l`

    if [ $analytical_frequency -ne 0 ]
    then
        printf "Hurray! The frequency finished successfully\n"
    else
        printf "The frequency did not finish properly or has not finished yet\n"
    fi

    imaginary_freq=`grep "imaginary mode" $1 | wc -l`

    if [ $imaginary_freq -ne 0 ]
    then
        printf '\e[31m%s\e[0m' "One or more imaginary frequencies found! Proceed with caution!"
        printf "\n"
    else
        printf "No imaginary frequencies!\n"
    fi

    printf "*************************\n"

    electronic_energy=`awk '/Total Energy/ {print $4; exit}' $1`
    printf "Electronic Energy: \t \t $electronic_energy\n"

    thermal_energy=`awk '/Total thermal energy/ {print$4; exit}' $1`
    printf "Electronic + Thermal Energy: \t $thermal_energy\n"

    enthalpy=`awk '/Total enthalpy/ {print $4; exit}' $1`
    printf "Enthalpy: \t \t \t $enthalpy\n"

    free_energy=`awk '/Final Gibbs free energy/ {print $6; exit}' $1`
    printf "Free Energy: \t \t \t $free_energy\n"

    basis=`awk '/Basis Dimension/ {print $NF; exit}' $1`
    printf "Basis Functions: \t \t $basis\n"

    atoms=`awk '/Number of atoms/ {print $5; exit}' $1`
    printf "Number of Atoms: \t \t $atoms\n"

    printf "Working Directory: \t \t `pwd`\n"

    printf "*************************\n"

    printf "`pwd` =$electronic_energy =$thermal_energy =$enthalpy =$free_energy =$basis =$atoms"
    printf "\n"

fi
