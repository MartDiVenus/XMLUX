#!/bin/bash
#
### Author: Mario Fantini
## All rights reserved
#
# Scopo: Elimina banchi di linee vuote, lascia solo le linee vuote pari a una riga.
#
# e.g. creo il file b.txt di esempio
# Ma questo script lo uso in xmlux per formattare i file *.lmx.

rm -fr /tmp/xmluxef*

if [ -f /tmp/xmluxeTargetFile ]; then

	## se tale script fosse lanciato direttamente da xmluxe, allora
targetFile=$(cat /tmp/xmluxeTargetFile)

else
# altrimenti, se fosse lanciato dallo script sorting ...
	targetFile=$(cat /tmp/xmluxse-targetFile)

fi



grep -n "^$" $targetFile.lmx | sed 's/://g' > /tmp/xmluxef-01

awk '{ nlines++;  print nlines }' /tmp/xmluxef-01 | tail -n1 > /tmp/xmluxef-02

nLines=$(cat /tmp/xmluxef-02)

declare -i var=0

for a in `seq $nLines`

do

var=var+1

grep -n "^$" $targetFile.lmx | sed 's/://g' > /tmp/xmluxef-03

rm -fr /tmp/xmluxef-container

mkdir /tmp/xmluxef-container

split -l1 /tmp/xmluxef-03 /tmp/xmluxef-container/

rm -f /tmp/xmluxef-previous

for b in $(ls /tmp/xmluxef-container)

do
	leggoB=$(cat /tmp/xmluxef-container/$b)

#read -p "testing 37
#\$leggoB = $leggoB
#" EnterNull

if [ -f /tmp/xmluxef-previous ]; then

	leggoPrevious=$(cat /tmp/xmluxef-previous)

	attualeLessPrevious=$(($leggoB - $leggoPrevious))

	if test $attualeLessPrevious -eq 1

	then
		echo $attualeLessPrevious > /tmp/xmluxef-toDel-$var


#read -p "testing 51
#sed ''\$leggoB'd' \$targetFile.lmx > /tmp/xmluxef-newFile
#sed ''$leggoB'd' $targetFile.lmx > /tmp/xmluxef-newFile
#" EnterNull

sed ''$leggoB'd' $targetFile.lmx > /tmp/xmluxef-newFile

		cp /tmp/xmluxef-newFile $targetFile.lmx

		break
	fi

	echo $leggoB > /tmp/xmluxef-previous
else
	echo $leggoB > /tmp/xmluxef-previous

fi

done

done

rm -fr /tmp/xmluxef*

exit

