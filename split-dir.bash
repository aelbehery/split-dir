#!/usr/bin/env bash

usage()
{
echo "
Description: $0 splits a directory into desired number of subdirectories with approximately similar number of files

Usage:
-i | --indir                    input directory
-n                              desired number of subdirectories

-h | --help             Display this help message and exit
"
}

#parse commandline options
while [ "$1" != "" ]; do
    case $1 in
        -i | --indir )                    shift
                                                                DIR_TO_SPLIT=$1
                                ;;
        -n )                              shift
                                                                NDIRS=$1
                                ;;

        -h | --help )                                           usage
                                                                exit
                                ;;
        * )                                                     usage
                                                                exit 1
    esac
    shift
done

#create desired number of subdirectories in a new directory called split_dirs
mkdir split_dirs
cd split_dirs
for i in `seq 1 "$NDIRS"`; do
        mkdir dir_${i}
done

#Get the number of files in the directory to be splitted and set the number of files per subdirectory
TNFILES=`find ../${DIR_TO_SPLIT}/ -type f | wc -l`
if [ $(( TNFILES % NDIRS )) -eq 0 ]; then
        NFILES=$(( TNFILES / NDIRS ))
else
        NFILES=$((TNFILES / ( NDIRS - 1 ) ))
fi

i=1 #variable to change subdirectory
n=0 #variable to count files per subdirectory
for f in ../${DIR_TO_SPLIT}/* ; do
        cp $f dir_${i}/
        ((n+=1))
        if [ "$n" -eq "$NFILES" ]; then
                ((i+=1))
                n=0
        fi
done