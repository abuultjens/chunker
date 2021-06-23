#!/bin/bash

CHUNK_SIZE=$1
INFILE=$2
OUTFILE=$3

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# make dir for tmp files
mkdir ${RAND}

# prepare fasta file
grep -v ">" ${INFILE} | sed 's/./& /g' | tr -d '\n' | tr ' ' '\n' > ${RAND}/${RAND}.seq

# split seq
split -d -l ${CHUNK_SIZE} ${RAND}/${RAND}.seq ${RAND}/${RAND}_SPLIT

# make split fofn
ls ${RAND}/${RAND}_SPLIT* > ${RAND}/${RAND}_SPLIT_fofn.txt

# loop through
for TAXA in $(cat ${RAND}/${RAND}_SPLIT_fofn.txt); do
	echo ">${TAXA}" >> ${RAND}_tmp.fa
	tr -d '\n' < ${TAXA} >> ${RAND}_tmp.fa
	echo "" >> ${RAND}_tmp.fa
done

# write outfile
mv ${RAND}_tmp.fa ${OUTFILE}

# rm tmp files		
rm *${RAND}*
rm -r ${RAND}


