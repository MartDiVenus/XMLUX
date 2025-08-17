#!/bin/bash



targetFile="$(cat /tmp/xmluxeTargetFile)"

## Tutti gli id che iniziano con <a>, ossia il capitolo a.
# è troppo vincolante utilizzare la chiave <a>.
#grep -o "ID=\"a*.*" $targetFile.lmx > /tmp/xmluxe-css01
# In questo modo puoi scrivere ID anche nel preambolo, perché quest'ultimo escluso.
cat $targetFile.lmx | sed -n '/<!-- begin radix/,$p' > /tmp/xmluxe-css0000

## mi serve la coerenza di numero di righe tra il file lmx in cui effettuerò le iniezioni
## e il file selezionato in cui ho escluso il preambolo.
grep -n "<!-- begin radix" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxe-nLineaBeginRadix

leggoNBeginRadix=$(cat /tmp/xmluxe-nLineaBeginRadix)

righeEsatte=$(echo $leggoNBeginRadix - 1 | bc)

touch /tmp/xmluxe-IpezzoCoerenzaBeginRadixLmx

declare -i var=0

while ((k++ <$righeEsatte))
  do
  var=$var+1
  echo "riga per coerenza con il file lmx n. $var" >> /tmp/xmluxe-IpezzoCoerenzaBeginRadixLmx
done 

cat /tmp/xmluxe-IpezzoCoerenzaBeginRadixLmx /tmp/xmluxe-css0000 > /tmp/xmluxe-css000

## Il I ID è sempre quello del root, io non specifico nulla nel preambolo xml. 
grep "ID=*" /tmp/xmluxe-css000 | head -n 1 > /tmp/xmluxe-css00

## leggo il valore di root
cat /tmp/xmluxe-css00 | cut -d= -f2,2 | sed 's/"//g' | sed 's/>/ /' | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idRoot

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

## ora posso selezionare tutti gli ID appartenenti al root
grep "ID=\"$leggoIdRoot" /tmp/xmluxe-css000 | awk '$1 > 0 {print $2}' > /tmp/xmluxe-css01

cat /tmp/xmluxe-css01 | sort > /tmp/xmluxe-css02

cat /tmp/xmluxe-css02 | uniq > /tmp/xmluxe-css03

## tutti i capitoli e sottostanti elementi
grep "\." /tmp/xmluxe-css03 > /tmp/xmluxe-css04

cat /tmp/xmluxe-css04 | sort > /tmp/xmluxe-css05

## solo i capitoli, ossia gli a* senza .
comm -3 /tmp/xmluxe-css03 /tmp/xmluxe-css05 > /tmp/xmluxe-css06

## Nei valori degli elementi non possono esserci caratteri speciali, quali e.g. *, #, &.
# perché grep non leggerebbe la stringa e quindi non producendo file *.dtd, *.css perfetti.

################ INIZIO ROOT 

rm -fr  /tmp/xmluxe-cssRoot

mkdir /tmp/xmluxe-cssRoot

split -l1 /tmp/xmluxe-css01 /tmp/xmluxe-cssRoot/


for c in $(ls /tmp/xmluxe-cssRoot)
do
	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id

	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

	if test $leggoIdRoot == $leggoID

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoIdRoot" >> /tmp/xmluxe-itemsEtIDs

echo "$leggoItem" > /tmp/xmluxe-itemRoot
         
rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE ROOT 

############## INIZIO SINOSSI 
#
#for c in $(ls /tmp/xmluxe-cssRoot)
#
#do
#
#	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"
#
#        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item
#
#	leggoItem="$(cat /tmp/xmluxe-item)"
#
#	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0
#
#	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
#
#	leggoID="$(cat /tmp/xmluxe-id)"
#
#	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title
#
#	leggoTitle="$(cat /tmp/xmluxe-title)"
#
#	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
#
#	echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-sinossi
#
#	idSinossi="$(cat /tmp/xmluxe-sinossi)"
#
#	## sinossi: un solo numero (un solo zero)
#	if test "$leggoID" == "$idSinossi"
#
#	then
#
#echo "$leggoID" >> /tmp/xmluxe-allIDs
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs
#
#	cp /tmp/xmluxe-item /tmp/xmluxe-itemSinossi
#
#	rm -f /tmp/xmluxe-cssRoot/$c
#        
#	fi
#
#done
#
############# FINE SINOSSI 

################ INIZIO  PART

mkdir /tmp/xmluxe-gradusI

for c in $(ls /tmp/xmluxe-cssRoot)

do
	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id

	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)


	#### GradusI, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

		cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-gradusI

		cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusI

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE PART 

############## INIZIO CHAPTERS
mkdir /tmp/xmluxe-gradusII

for c in $(ls /tmp/xmluxe-cssRoot)

do

	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	#### Capitolo: il capitolo, insieme a part, non ha mai punti nell'ID; ma gradusI lo risolvo diversamente.

	if test $leggoDotFrequency -eq 1

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-gradusII

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusII

rm -f /tmp/xmluxe-cssRoot/$c

	fi
	
done
################ FINE CHAPTERS 

################ INIZIO SECTION

mkdir /tmp/xmluxe-gradusIII

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

grep "ID=\"$leggoIdRoot" /tmp/xmluxe-css05 > /tmp/xmluxe-sectionAnd

rm -fr /tmp/xmluxe-css05Split

mkdir /tmp/xmluxe-css05Split

split -l1 /tmp/xmluxe-sectionAnd  /tmp/xmluxe-css05Split/

for d in $(ls /tmp/xmluxe-css05Split)

do

rm -f /tmp/xmluxe-pcdata

touch /tmp/xmluxe-pcdata

	leggoD="$(cat /tmp/xmluxe-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	if test $leggoDotFrequency -eq 2

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusIII

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusIII

rm -f /tmp/xmluxe-css05Split/$d

fi

done

################ FINE SECTION

################ INIZIO SUBSECTION

mkdir /tmp/xmluxe-gradusIV

rm -f /tmp/xmluxe-ElementDtd

touch /tmp/xmluxe-ElementDtd

for d in $(ls /tmp/xmluxe-css05Split)

do

rm -f /tmp/xmluxe-pcdata

touch /tmp/xmluxe-pcdata


	leggoD="$(cat /tmp/xmluxe-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	if test $leggoDotFrequency -eq 3

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusIV

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusIV

        rm -f /tmp/xmluxe-css05Split/$d
	
	fi

done

################ FINE SUBSECTION 

################ INIZIO SUBSUBSECTION

mkdir /tmp/xmluxe-gradusV

for d in $(ls /tmp/xmluxe-css05Split)

do

	leggoD="$(cat /tmp/xmluxe-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	if test $leggoDotFrequency -eq 4

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusV

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusV

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE SUBSUBSECTION 

################ INIZIO PARAPGRAPH

mkdir /tmp/xmluxe-gradusVI

for d in $(ls /tmp/xmluxe-css05Split)

do
	leggoD="$(cat /tmp/xmluxe-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	if test $leggoDotFrequency -eq 5

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusVI

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusVI

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE PARAGRAPH

################ INIZIO SUBPARAGRAPH
mkdir /tmp/xmluxe-gradusVII

for d in $(ls /tmp/xmluxe-css05Split)

do

	leggoD="$(cat /tmp/xmluxe-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	if test $leggoDotFrequency -eq 6

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusVII

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusVII

	rm -f /tmp/xmluxe-css05Split/$d

	fi
done

################ FINE SUBPARAGRAPH 

if [ ! -f $targetFile.lmxe ]; then 

touch $targetFile.lmxe

fi

############################################################## ACTION MOVE (21 ottobre)
grep "move" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionMove

stat --format %s /tmp/xmluxe-actionMove > /tmp/xmluxe-actionMoveBytes

leggoBytesActionMove=$(cat /tmp/xmluxe-actionMoveBytes)


## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

## I if
if test $leggoBytesActionMove -gt 0

then

	mkdir /tmp/xmluxe-allIDsContainer
	
	split -l1 /tmp/xmluxe-allIDs /tmp/xmluxe-allIDsContainer/

### after -> vuoi scalare un id  in avanti
	grep "^-a" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 0

	then

		touch /tmp/xmluxe-optionA

		cat /tmp/xmluxeTargetFileOp | cut -d: -f2,2 | sed 's/-a//g' > /tmp/xmluxe-afterValue

		optionValue=$(cat /tmp/xmluxe-afterValue)

	fi
### before -> vuoi scalare un id  indietro
	grep "^-b" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 0

	then

		touch /tmp/xmluxe-optionB

		cat /tmp/xmluxeTargetFileOp | cut -d: -f2,2 | sed 's/-b//g' > /tmp/xmluxe-beforeValue

		optionValue=$(cat /tmp/xmluxe-beforeValue)

	fi


	cat /tmp/xmluxe-actionMove | cut -d= -f2,2 > /tmp/xmluxe-elementToMove

	leggoIDToMove="$(cat /tmp/xmluxe-elementToMove)"

	grep "$leggoIDToMove$" /tmp/xmluxe-allIDs > /tmp/xmluxe-verificoEsistenzaID

	stat --format %s /tmp/xmluxe-verificoEsistenzaID > /tmp/xmluxe-verificoEsistenzaIDBytes

	leggoBytesEsistenzaID=$(cat /tmp/xmluxe-verificoEsistenzaIDBytes)

	if test ! $leggoBytesEsistenzaID -gt 0

	then

		clear
		echo "Selected ID $leggoIDToMove to move, doesn't exist."
		echo "Forced exit"

		exit

	fi


## leggo la frequenza dei pti.
	sed 's/[^.]//g' /tmp/xmluxe-elementToMove | awk '{ print length }' > /tmp/xmluxe-elementKind

	leggoElementKind="$(cat /tmp/xmluxe-elementKind)"

	## per la sinossi non ha senso eseguire xmluxe --move, quindi parto direttamente da 1 [ossia dalle parti]

	########### inizio gradusI move

	if test $leggoElementKind -eq 0

	then

	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-LastPiece

	originalValue=$(cat /tmp/xmluxe-LastPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIList

				for b in $(ls /tmp/xmluxe-gradusI)

				do

				leggoB="$(cat /tmp/xmluxe-gradusI/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIList

				done

				cat /tmp/xmluxe-gradusIList | sort > /tmp/xmluxe-gradusIListSorted

				cat /tmp/xmluxe-gradusIListSorted | tail -n1 > /tmp/xmluxe-gradusIListSortedMax0

				cat /tmp/xmluxe-gradusIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIListSortedMax01

				cat /tmp/xmluxe-gradusIListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-gradusIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
		
		echo \"$leggoIdRoot \$newValue\" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot 0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot \$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"
		
		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe


done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		
		echo "$leggoIdRoot $newValue" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	#	fi
## qua legge anche il capitolo, invece qui devo stare nel blocco delle parti
	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)
## I if qua 
			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIList

				for b in $(ls /tmp/xmluxe-gradusI)

				do

				leggoB="$(cat /tmp/xmluxe-gradusI/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIList

				done

				cat /tmp/xmluxe-gradusIList | sort > /tmp/xmluxe-gradusIListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

cat /tmp/xmluxe-gradusIList | sort > /tmp/xmluxe-gradusIListSorted

				cat /tmp/xmluxe-gradusIListSorted | tail -n1 > /tmp/xmluxe-gradusIListSortedMax0

				cat /tmp/xmluxe-gradusIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIListSortedMax01

				cat /tmp/xmluxe-gradusIListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-gradusIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

			
echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi


		echo \"$leggoIdRoot \$newValue\" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot 0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot \$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		
		## IV if
		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		
		echo "$leggoIdRoot $newValue" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
	
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe


		fi

		fi

		fi
	
#		exit

#		fi
		### con questo fi ho finito il blocco dell'elemento 'part', ora tocca al capitolo.

#else
#	echo "la frequenza è un'altra" > /dev/null

# fi

## I if chiuso

############## fine gradusI move

### inizio gradusII move	
if test $leggoElementKind -eq 1

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece
## ricordati di aggiungere pezzi progressivamente per elementi inferiori al capitolo
## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericIIPiece /tmp/xmluxe-LastPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	if test $idNumericIIPiece -lt 10

	then


	originalValue=$(cat /tmp/xmluxe-idNumericIIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIIList

				for b in $(ls /tmp/xmluxe-gradusII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIList

				done
### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-gradusIIPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-gradusIIPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-gradusIIList >  /tmp/xmluxe-gradusIIListToSort

				cat /tmp/xmluxe-gradusIIListToSort | sort > /tmp/xmluxe-gradusIIListSorted

				cat /tmp/xmluxe-gradusIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIListSortedMax0

				cat /tmp/xmluxe-gradusIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIListSortedMax01

				cat /tmp/xmluxe-gradusIIListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-gradusIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
		
		echo \"$leggoIdRoot$idNumericIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot$idNumericIPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot$idNumericIPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

				echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		
		echo "$leggoIdRoot$idNumericIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIIList

				for b in $(ls /tmp/xmluxe-gradusII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIList

				done

				### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-gradusIIPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-gradusIIPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-gradusIIList >  /tmp/xmluxe-gradusIIListToSort

				cat /tmp/xmluxe-gradusIIListToSort | sort > /tmp/xmluxe-gradusIIListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIListSortedMax0

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-gradusIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIListSortedMax01

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-gradusIIListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-gradusIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi


		echo \"$leggoIdRoot$idNumericIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot$idNumericIPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot$idNumericIPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		
		echo "$leggoIdRoot$idNumericIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
	### con questo fi ho finito il blocco dell'elemento 'capitolo', ora tocca alla sezione.

### inizio gradusIII move	
if test $leggoElementKind -eq 2

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"
## ricordati di aggiungere pezzi progressivamente per elementi inferiori al sezione
## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericIIIPiece /tmp/xmluxe-LastPiece

	if test $idNumericIIIPiece -lt 10

	then

## ricordati di cambiare IIIPiece in IVPiece nel prox blocco subsection
	originalValue=$(cat /tmp/xmluxe-idNumericIIIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIIIList

				for b in $(ls /tmp/xmluxe-gradusIII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusIII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIIList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIIPrefixToMatch

				leggoGradusIIIsPrefixToMatch="$(cat /tmp/xmluxe-gradusIIIPrefixToMatch)"

				grep "$leggoGradusIIIsPrefixToMatch" /tmp/xmluxe-gradusIIIList > /tmp/xmluxe-gradusIIIListToSort

				cat /tmp/xmluxe-gradusIIIListToSort | sort > /tmp/xmluxe-gradusIIIListSorted

				cat /tmp/xmluxe-gradusIIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-gradusIIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIIListSortedMax01
				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-gradusIIIListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-gradusIIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN

		else
		### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere $idNumericIIIPiece in subsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIIIList

				for b in $(ls /tmp/xmluxe-gradusIII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusIII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIIList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIIPrefixToMatch

				leggoGradusIIIsPrefixToMatch="$(cat /tmp/xmluxe-gradusIIIPrefixToMatch)"

				grep "$leggoGradusIIIsPrefixToMatch" /tmp/xmluxe-gradusIIIList >  /tmp/xmluxe-gradusIIIListToSort

				cat /tmp/xmluxe-gradusIIIListToSort | sort > /tmp/xmluxe-gradusIIIListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusIIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-gradusIIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIIListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-gradusIIIListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-gradusIIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericIIIPiece in subsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
### con questo fi ho finito il blocco dell elemento sezione, ora tocca alla sottosezione.

################# fine gradusIII move

### inizio gradusIV move	
if test $leggoElementKind -eq 3

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

## ricordati di aggiungere VPiece a sottosottosezione
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

	idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericIVPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare IVPiece in VPiece in sottosottosezione
	if test $idNumericIVPiece -lt 10

	then

## ricordati di cambiare IVPiece in VPiece nel prox blocco subsubsection
	originalValue=$(cat /tmp/xmluxe-idNumericIVPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIVList

				for b in $(ls /tmp/xmluxe-gradusIV)

				do

				leggoB="$(cat /tmp/xmluxe-gradusIV/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIVList

				done
### ricordati di aggiungere $idNumericIVPiece NON VPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIVPrefixToMatch

				leggoSubgradusIIIPrefixToMatch="$(cat /tmp/xmluxe-gradusIVPrefixToMatch)"

				grep "$leggoSubgradusIIIPrefixToMatch" /tmp/xmluxe-gradusIVList > /tmp/xmluxe-gradusIVListToSort

				cat /tmp/xmluxe-gradusIVListToSort | sort > /tmp/xmluxe-gradusIVListSorted

				cat /tmp/xmluxe-gradusIVListSorted | tail -n1 > /tmp/xmluxe-gradusIVListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsection
				cat /tmp/xmluxe-gradusIVListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIVListSortedMax01
				### ricordati di cambiare -f4,4 in -f5,5 per la subsubsection
				cat /tmp/xmluxe-gradusIVListSortedMax01 | cut -d. -f4,4 > /tmp/xmluxe-gradusIVListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIVListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIVListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIVListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
### ricordati di aggiungere $idNumericIVPiece in subsubsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIVPiece in subsubsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere $idNumericIIIPiece in subsubsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusIVList

				for b in $(ls /tmp/xmluxe-gradusIV)

				do

				leggoB="$(cat /tmp/xmluxe-gradusIV/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIVList

				done
### ricordati di aggiungere alla sottosottosezione $idNumericIVPiece NON VPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIVPrefixToMatch

				leggoSubgradusIIIPrefixToMatch="$(cat /tmp/xmluxe-gradusIVPrefixToMatch)"

				grep "$leggoSubgradusIIIPrefixToMatch" /tmp/xmluxe-gradusIVList >  /tmp/xmluxe-gradusIVListToSort

				cat /tmp/xmluxe-gradusIVListToSort | sort > /tmp/xmluxe-gradusIVListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusIVListSorted | tail -n1 > /tmp/xmluxe-gradusIVListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsection
				cat /tmp/xmluxe-gradusIVListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIVListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsubsection
				cat /tmp/xmluxe-gradusIVListSortedMax01 | cut -d. -f4,4 > /tmp/xmluxe-gradusIVListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIVListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIVListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIVListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

### ricordati di aggiungere \$idNumericIVPiece per la sottosottosezione
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere \$idNumericIVPiece per la sottosottosezione
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere \$idNumericIVPiece per la sottosottosezione
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericIVPiece in subsubsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
### con questo fi ho finito il blocco dell elemento sezione, ora tocca alla sottosezione.

################# fine gradusIV

################# inizio gradusV
### inizio gradusV move	
## ricordati di cambiare 4 in 5 in paragraph
if test $leggoElementKind -eq 4

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

	idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

## ricordati di aggiungere VIPiece a paragraph
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

	idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericVPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare VPiece in VIPiece in paragraph
	if test $idNumericVPiece -lt 10

	then

## ricordati di cambiare VPiece in VIPiece nel prox blocco paragraph
	originalValue=$(cat /tmp/xmluxe-idNumericVPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusVList

				for b in $(ls /tmp/xmluxe-gradusV)

				do

				leggoB="$(cat /tmp/xmluxe-gradusV/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusVList

				done
### ricordati di aggiungere $idNumericVPiece NON VIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" | sed 's/ //g' > /tmp/xmluxe-gradusVPrefixToMatch

				leggoSubgradusIVPrefixToMatch="$(cat /tmp/xmluxe-gradusVPrefixToMatch)"

				grep "$leggoSubgradusIVPrefixToMatch" /tmp/xmluxe-gradusVList > /tmp/xmluxe-gradusVListToSort

				cat /tmp/xmluxe-gradusVListToSort | sort > /tmp/xmluxe-gradusVListSorted

				cat /tmp/xmluxe-gradusVListSorted | tail -n1 > /tmp/xmluxe-gradusVListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubsection
				cat /tmp/xmluxe-gradusVListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusVListSortedMax01
				### ricordati di cambiare -f5,5 in -f6,6 per il paragraph
				cat /tmp/xmluxe-gradusVListSortedMax01 | cut -d. -f5,5 > /tmp/xmluxe-gradusVListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusVListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusVListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusVListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
### ricordati di aggiungere $idNumericVPiece in paragraph
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVPiece in paragraph
echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN


		else
### ricordati di aggiungere $idNumericVPiece in paragraph
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere un pezzo a paragraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusVList

				for b in $(ls /tmp/xmluxe-gradusV)

				do

				leggoB="$(cat /tmp/xmluxe-gradusV/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusVList

				done
### ricordati di aggiungere a paragraph $idNumericVPiece NON VIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" | sed 's/ //g' > /tmp/xmluxe-gradusVPrefixToMatch

				leggoSubgradusIVPrefixToMatch="$(cat /tmp/xmluxe-gradusVPrefixToMatch)"

				grep "$leggoSubgradusIVPrefixToMatch" /tmp/xmluxe-gradusVList >  /tmp/xmluxe-gradusVListToSort

				cat /tmp/xmluxe-gradusVListToSort | sort > /tmp/xmluxe-gradusVListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusVListSorted | tail -n1 > /tmp/xmluxe-gradusVListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubsection
				cat /tmp/xmluxe-gradusVListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusVListSortedMax01

				### ricordati di cambiare -f5,5 in -f6,6 per la subsubsubsection
				cat /tmp/xmluxe-gradusVListSortedMax01 | cut -d. -f5,5 > /tmp/xmluxe-gradusVListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusVListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusVListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusVListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

### ricordati di aggiungere \$idNumericVPiece per il paragrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere \$idNumericVPiece per il paragrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere \$idNumericVPiece per il paragrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericVPiece in paragraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
### con questo fi ho finito il blocco dell elemento sezione, ora tocca alla sottosezione.

################# fine gradusV

################# inizio gradusVI
### inizio gradusVI move	
## ricordati di cambiare 5 in 6 in gradusVII
if test $leggoElementKind -eq 5

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

	idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

	idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

	## ricordati di aggiungere VIIPiece a subparagraph
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

	idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

## ricordati in subparagraph di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericVIPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare VIPiece in VIIPiece in subparagraph
	if test $idNumericVIPiece -lt 10

	then

## ricordati di cambiare VIPiece in VIIPiece nel prox blocco subparagraph
	originalValue=$(cat /tmp/xmluxe-idNumericVIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusVIList

				for b in $(ls /tmp/xmluxe-gradusVI)

				do

				leggoB="$(cat /tmp/xmluxe-gradusVI/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusVIList

				done
### ricordati di aggiungere in subparagraph $idNumericVIPiece NON VIIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" | sed 's/ //g' > /tmp/xmluxe-gradusVIPrefixToMatch

				leggoGradusVIsPrefixToMatch="$(cat /tmp/xmluxe-gradusVIPrefixToMatch)"

				grep "$leggoGradusVIsPrefixToMatch" /tmp/xmluxe-gradusVIList > /tmp/xmluxe-gradusVIListToSort

				cat /tmp/xmluxe-gradusVIListToSort | sort > /tmp/xmluxe-gradusVIListSorted

				cat /tmp/xmluxe-gradusVIListSorted | tail -n1 > /tmp/xmluxe-gradusVIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subparagraph
				cat /tmp/xmluxe-gradusVIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusVIListSortedMax01
				### ricordati di cambiare -f6,6 in -f7,7 per il paragraph
				cat /tmp/xmluxe-gradusVIListSortedMax01 | cut -d. -f6,6 > /tmp/xmluxe-gradusVIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusVIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusVIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusVIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
### ricordati di aggiungere $idNumericVIPiece in subparagraph
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVIPiece in subparagraph
echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN


		else
### ricordati di aggiungere $idNumericVPiece in paragraph
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere un pezzo a subparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusVIList

				for b in $(ls /tmp/xmluxe-gradusVI)

				do

				leggoB="$(cat /tmp/xmluxe-gradusVI/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusVIList

				done
### ricordati di aggiungere a subparagraph $idNumericVIPiece NON VIIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" | sed 's/ //g' > /tmp/xmluxe-gradusVIPrefixToMatch

				leggoGradusVIsPrefixToMatch="$(cat /tmp/xmluxe-gradusVIPrefixToMatch)"

				grep "$leggoGradusVIsPrefixToMatch" /tmp/xmluxe-gradusVIList >  /tmp/xmluxe-gradusVIListToSort

				cat /tmp/xmluxe-gradusVIListToSort | sort > /tmp/xmluxe-gradusVIListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusVIListSorted | tail -n1 > /tmp/xmluxe-gradusVIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a parapraph
				cat /tmp/xmluxe-gradusVIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusVIListSortedMax01

				### ricordati di cambiare -f6,6 in -f7,7 per subparagraph
				cat /tmp/xmluxe-gradusVIListSortedMax01 | cut -d. -f6,6 > /tmp/xmluxe-gradusVIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusVIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusVIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusVIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

### ricordati di aggiungere \$idNumericVIPiece per il subparagrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere \$idNumericVIPiece per il subparagrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere \$idNumericVIPiece per il subparagrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericVIPiece in subparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	

################# fine gradusVI

################# inizio gradusVII
### inizio gradusVII move	
## ricordati di cambiare 6 in 7 nel livello inferiore a gradusVIII quando e se lo implementerai
if test $leggoElementKind -eq 6

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

	idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

	idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

	idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

	## ricordati di aggiungere VIIIPiece nel livello inferiore a subsubparagraph
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f7,7 > /tmp/xmluxe-idNumericVIIPiece

	idNumericVIIPiece="$(cat /tmp/xmluxe-idNumericVIIPiece)"

## ricordati nell livello inferiore a subsubparagraph di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericVIIPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare VIIPiece in VIIIPiece nel livello inferiore a subsubparagraph
	if test $idNumericVIIPiece -lt 10

	then

## ricordati di cambiare VIIPiece in VIIIPiece nel livello inferiore a subsubparagraph
	originalValue=$(cat /tmp/xmluxe-idNumericVIIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusVIIList

				for b in $(ls /tmp/xmluxe-gradusVII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusVII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusVIIList

				done
### ricordati di aggiungere nel livello inferiore al subsubparagraph $idNumericVIIPiece NON VIIIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusVIIPrefixToMatch

				leggoSubgradusVIPrefixToMatch="$(cat /tmp/xmluxe-gradusVIIPrefixToMatch)"

				grep "$leggoSubgradusVIPrefixToMatch" /tmp/xmluxe-gradusVIIList > /tmp/xmluxe-gradusVIIListToSort

				cat /tmp/xmluxe-gradusVIIListToSort | sort > /tmp/xmluxe-gradusVIIListSorted

				cat /tmp/xmluxe-gradusVIIListSorted | tail -n1 > /tmp/xmluxe-gradusVIIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubparagraph
				cat /tmp/xmluxe-gradusVIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusVIIListSortedMax01
				### ricordati di cambiare -f7,7 in -f8,8 nel livello inferiore a subparagraph
				cat /tmp/xmluxe-gradusVIIListSortedMax01 | cut -d. -f7,7 > /tmp/xmluxe-gradusVIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusVIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusVIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusVIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
### ricordati che nel livello inferiore a subparagraph devi aggiungere $idNumericVIIPiece
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati che nel livello inferiore a subparagraph devi aggiungere $idNumericVIIPiece
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN


		else
### ricordati che nel livello inferiore a subparagraph devi aggiungere $idNumericVIIPiece
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore a subsubparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear	
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-gradusVIIList

				for b in $(ls /tmp/xmluxe-gradusVII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusVII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusVIIList

				done
### ricordati nel livello ingeriore a subparagraph di aggiungere $idNumericVIPiece NON VIIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusVIIPrefixToMatch

				leggoSubgradusVIPrefixToMatch="$(cat /tmp/xmluxe-gradusVIIPrefixToMatch)"

				grep "$leggoSubgradusVIPrefixToMatch" /tmp/xmluxe-gradusVIIList >  /tmp/xmluxe-gradusVIIListToSort

				cat /tmp/xmluxe-gradusVIIListToSort | sort > /tmp/xmluxe-gradusVIIListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusVIIListSorted | tail -n1 > /tmp/xmluxe-gradusVIIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subparapraph
				cat /tmp/xmluxe-gradusVIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusVIIListSortedMax01

				### ricordati di cambiare -f7,7 in -f8,8 nel livello inferiore a subsubparagraph
				cat /tmp/xmluxe-gradusVIIListSortedMax01 | cut -d. -f7,7 > /tmp/xmluxe-gradusVIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusVIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusVIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusVIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

### ricordati di aggiungere \$idNumericVIIPiece nel livello inferiore al subparagrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere \$idNumericVIIPiece nel livello inferiore al subparagrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere \$idNumericVIIPiece nel livello inferiore al subparagrafo
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore a subsubparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		clear
		echo "The new ID $fullNewID you want, exists already."
		echo "Forced exit."
  	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	

################# fine gradusVII

fi
## I if chiuso (quello dell'azione --move)



############################################################## ACTION ADD

grep "add" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionAdd

stat --format %s /tmp/xmluxe-actionAdd > /tmp/xmluxe-actionAddBytes

leggoBytes=$(cat /tmp/xmluxe-actionAddBytes)


## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

if test $leggoBytes -gt 0

then
	rm -f /tmp/xmluxe-optionW.lmx

	for a in $(ls /tmp/xmluxePseudoOptions)

	do

	grep "^-w" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionW.lmx
	
	fi

	grep "^-name" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionName.lmx
	
	fi


	done

	cat /tmp/xmluxe-actionAdd | cut -d= -f2,2 > /tmp/xmluxe-elementToAdd

	leggoIDToAdd="$(cat /tmp/xmluxe-elementToAdd)"

	## verifico se l'id che l'utente vuole aggiungere esista già
	grep "$leggoIDToAdd$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenza

	stat --format %s /tmp/xmluxe-verificaEsistenza > /tmp/xmluxe-verificaEsistenzaBytes

	leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaBytes)

	if test $leggoBytes -gt 0

	then
		leggoElementEtId="$(cat /tmp/xmluxe-verificaEsistenza)"
		clear

		echo "$leggoElementEtId exists already." 
		echo "Forced exit."

		exit
	fi

	sed 's/[^.]//g' /tmp/xmluxe-elementToAdd | awk '{ print length }' > /tmp/xmluxe-elementKind

	leggoElementKind="$(cat /tmp/xmluxe-elementKind)"

	# I if
	if test $leggoElementKind -eq 0

	then

################## INIZIO SINOSSI LMXE, LMX
#
#		grep "00" /tmp/xmluxe-elementToAdd > /tmp/xmluxe-sinossiOrNot
#
#		stat --format %s /tmp/xmluxe-sinossiOrNot > /tmp/xmluxe-sinossiOrNotBytes
#	
#		leggoBytesSinossi=$(cat /tmp/xmluxe-sinossiOrNotBytes)
#
#		## II if 
#		if test $leggoBytesSinossi -gt 0
#		then
#
#			## l'elemento da aggiungere è sinossi, la sinossi ha 00
#			# da fare
#
#			## Verifico che la sinossi davvero non esiste, e che quindi l'utente non stia sbagliando
#			# avolerla aggiungere
#
#			clear
#
#			java /usr/local/lib/xmlux/java/xmluxe/matter/synopsisFileWriter7.java
#
#			echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi
#
#			leggoIDToAdd="$(cat /tmp/xmluxe-idSinossi)"
#
#			grep -n "<$(cat /tmp/xmluxe-itemRoot) ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
#
#			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)
#
#			###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
###### è al di sotto di essa
#echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1
#
#leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)
#
#echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand
#
####### elimino il <<;>> che ho usato prima come separatore
#echo ":s/\;\(.*\)/\1/g
#ZZ" > /tmp/xmluxe-delPointVirgo
#
#
#vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand
#
#### elimino tutto ciò che è al di sotto della riga $leggoNumerLine
#
### backup file originale
#cp $targetFile.lmx /tmp/xmluxe-pre
#
#vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre
#
#### appendo a /tmp/pre
#leggoItem="$(cat /tmp/xmluxe-itemSinossi)"
#
#### III if
#		if [ -f /tmp/xmluxe-optionW.lmx ]; then
#
#			echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
#of the synopsis to add. At the end save and exit.
#" >> /tmp/xmluxe-optionW.lmx
#
#			gvim -f /tmp/xmluxe-optionW.lmx
#
#			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
#
#			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
#			
#			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"
#
#			echo "
#<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
#</$leggoItem>
#<!-- end $leggoIDToAdd -->
#" >> /tmp/xmluxe-pre
#
#else
#
#		echo "
#<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please
#
#</$leggoItem>
#<!-- end $leggoIDToAdd -->
#" >> /tmp/xmluxe-pre
#
#		fi
#### chiusura III if
#
############ II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
#### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>
#
#cp $targetFile.lmx /tmp/xmluxe-post
#
#echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1
#
#vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1
#
#vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post
#
#cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx
#
#echo "
#$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe
#
#	fi
	### chiusura II if

################# INIZIO PART LMXE, LMX

## I if
#		if test ! $leggoBytesSinossi -gt 0 
			
#		then 

		## l'elemento da aggiungere è una parte 
	
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericPiece

		idNumericPiece=$(cat /tmp/xmluxe-idNumericPiece)
## II if
		if test $idNumericPiece -lt 10

		then
			echo 0$(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousGradusI

			leggoIdNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)
### III if
			if test $leggoIdNumericPiecePreviousGradusI == "00"
			then

				echo "è la prima parte del documento" > /tmp/xmluxe-Ichild

					else
				idNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousGradusI$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousGradusI doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit
				
				fi
## chiusura IV if

			fi
## chiusura III if


		else

                        echo $(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousGradusI

			leggoIdNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)
### III if
			if test $leggoIdNumericPiecePreviousGradusI == "0"
			 then

				 echo "è la prima parte del documento" > /tmp/xmluxe-IGradusIe

			else
				idNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousGradusI$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousGradusI doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
### chiusura III if
			fi
### chiusura II if
		fi
### II if

### In alternativa hai anche /tmp/xmluxe-IGradusIe
			if [ ! -f /tmp/xmluxe-itemGradusI ]; then

			clear 

                        java /usr/local/lib/xmlux/java/xmluxe/matter/partFileWriter7.java 

			## non è obbligatorio avere la sinossi nel documento, quindi se non esiste devo
			## appendere la gradusI subito dopo l'inizio di <root ID ...

#			if [ -f /tmp/xmluxe-itemSinossi ]; then

#				echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-append

#				idNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-append)"

#				grep -n "<!-- end $idNumericPiecePreviousGradusI -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#			else

				echo "$leggoIdRoot" | sed 's/ //g' > /tmp/xmluxe-append

				idNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-append)"

				grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
	
#			fi
		
		else

			grep -n "<!-- end $leggoIdRoot$idNumericPiecePreviousGradusI -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

### chiusura II if
			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusI)"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

## chiusura I if
#	fi

fi

################# INIZIO CAPITOLO LMXE, LMX

	if test $leggoElementKind -eq 1

	then
		## l'elemento da aggiungere è un capitolo

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		if test $idNumericIIPiece -lt 10

		then
			echo 0$(echo $idNumericIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIPiecePrevious

			leggoIdNumericPiecePrevious="$(cat /tmp/xmluxe-idNumericIIPiecePrevious)"

			if test $leggoIdNumericPiecePrevious == "00"
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIPiecePrevious)

				## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi


		else

                        echo $(echo $idNumericIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIPiecePrevious

			leggoIdNumericPiecePrevious="$(cat /tmp/xmluxe-idNumericIIPiecePrevious)"

			if test $leggoIdNumericPiecePrevious == "0"
		
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild
				
				idNumericPreviousPiece="$idNumericIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi


		fi

			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece"

			## non è detto che esista una part, non è obbligatoria
			if [ -f /tmp/xmluxe-itemGradusI ]; then

			grep -n "ID=\"$leggoIdRoot$idNumericPrevious\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			else

			## non è detto che esista una sinossi, non è obbligatoria
#			if [ -f /tmp/xmluxe-itemSinossi ]; then
			
#			echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi 

#			leggoIdSinossi="$(cat /tmp/xmluxe-idSinossi)"

#		  	grep -n "<!-- end $leggoIdSinossi -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#			else

			## se non esiste né la parte, né la sinossi, allora appendo subito dopo l'inizio di <root
			grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			# echo "append under root" > /tmp/xmluxe-appendUnderRoot
#
#			fi

			fi
			
			if [ ! -f /tmp/xmluxe-itemGradusII ]; then

			echo "I chapter of a part" > /tmp/xmluxe-firstElementGradusII

				### first chapter not of a gradusI but of the entire document

			clear 

			java /usr/local/lib/xmlux/java/xmluxe/matter/chapterFileWriter7.java
			
			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

#	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

#echo $leggoNumberLine + 1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
#echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus


#else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

#	fi

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
#echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
#echo $leggoNumberLine-2| bc > /tmp/xmluxe-numberLineMinusMinus


#	fi

			
leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusII)"


if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

	fi

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO SEZIONE LMXE, LMX

	if test $leggoElementKind -eq 2

	then
		## l'elemento da aggiungere è una sezione
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		if test $idNumericIIIPiece -lt 10

		then
			echo 0$(echo $idNumericIIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIPiece"
			
			else
	
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi


		else

                        echo $(echo $idNumericIIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild
				
				idNumericPreviousPiece="$idNumericIIPiece"
				
			else
		
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi

		## Appendo all'interno di un capitolo, ma non è obbligatorio avere un capitolo.
			if [ -f /tmp/xmluxe-Ichild ]; then

				## Verifico se esiste un capitolo

				if [ -f /tmp/xmluxe-itemGradusII ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece"
			
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

				else
					## se il capitolo non esiste, posso appendere dopo la sinossi se questa esiste,
					## non è obbligatorio che la sinossi esista.

#					if [ -f /tmp/xmluxe-itemSinossi ]; then

#						echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi

				#		leggoIdSinossi="$(cat /tmp/xmluxe-idSinossi)"
#
#					grep -n "<!-- end $leggoIdSinossi -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#						else
						## siccome non è obbligatorio che la sinossi esista, allora appendo all'interno di root
						## quindi in tal caso non esiste né il capitolo, né la sinossi; la parte non la testo
						## perché se non esiste il capitolo non esiste nemmeno la parte.
	
					grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
#
#					fi
			fi

			## Non fare confusione tra I child e l'esistenza di ...-itemGradusIII, il I child si riferisce
			## all'appartenza a uno specifico padre, mentre  ...-itemGradusIII si riferisce all'esistenza
			## di un elemento 'section' all'interno di tutto il documento -- non all'interno di uno specifico padre --.
			if [ ! -f /tmp/xmluxe-itemGradusIII ]; then

	
				echo "I section of an element" > /tmp/xmluxe-firstElementGradusIII

			
				### first section not of chapter but of the entire document

			clear 

			java /usr/local/lib/xmlux/java/xmluxe/matter/sectionFileWriter7.java

			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

		
###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	if [ -f /tmp/xmluxe-itemGradusII ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus

	else
	
#	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

#echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
#echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

#else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine | bc > /tmp/xmluxe-numberLineMinusMinus

#	fi


	fi


	echo "esiste già un elemento section" > /dev/null

leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusIII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusIII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

	fi
echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO SOTTOSEZIONE LMXE, LMX
	if test $leggoElementKind -eq 3

	then

## l'elemento da aggiungere è una sottosezione

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		## Controllo coerenza locale, se non esiste il padre (element section)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No section element exists to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi

		if test $idNumericIVPiece -lt 10

		then
			echo 0$(echo $idNumericIVPiece - 1 | bc) > /tmp/xmluxe-idNumericIVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIVPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		else

                        echo $(echo $idNumericIVPiece - 1 | bc) > /tmp/xmluxe-idNumericIVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIIPiece"
					else
				
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIVPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi

		fi
		


			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece"

			if [ ! -f /tmp/xmluxe-itemGradusIV ]; then

				echo "I subsection of an element" > /tmp/xmluxe-firstElementGradusIV

				### first subsection not of a section but of the entire document

				clear 

			java /usr/local/lib/xmlux/java/xmluxe/matter/subsectionFileWriter7.java
			
			fi
			
		 	else
				
			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece"


			fi

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus
			
leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusIV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusIV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

	fi
echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO SOTTOSOTTOSEZIONE LMXE, LMX

	if test $leggoElementKind -eq 4

	then
	## L'elemento da aggiungere è una sottosottosezione

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

		idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

			## Controllo coerenza locale, se non esiste il padre (element section)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No subsection element $leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece exists
to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi


		if test $idNumericVPiece -lt 10

		then
			echo 0$(echo $idNumericVPiece - 1 | bc) > /tmp/xmluxe-idNumericVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIVPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVPiecePrevious)

	## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add 
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi


		else

                        echo $(echo $idNumericVPiece - 1 | bc) > /tmp/xmluxe-idNumericVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIVPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)

				## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi

		fi
		
	
			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece"
## prima del 19 ottobre, non va bene perché non viene rispettato l'eventuale contenuto della sezione.
		#	grep -n "ID=\"$leggoIdRoot$idNumericPrevious\"" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxe-numberLine

			if [ ! -f /tmp/xmluxe-itemGradusV ]; then

				echo "I subsubsection of an element" > /tmp/xmluxe-firstElementGradusV
			
				### first subsubsection not of a section but of the entire document

				clear 
	
				java /usr/local/lib/xmlux/java/xmluxe/matter/subsubsectionFileWriter7.java

			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece"

			fi

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine


			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus
			
leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

	fi
echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO PARAGRAPH LMXE, LMX

	if test $leggoElementKind -eq 5

	then
	# l'elemento da aggiungere è un paragraph

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

		idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

		idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

			## Controllo coerenza locale, se non esiste il padre (element section)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No subsubsection element $leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece exists
to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi



		if test $idNumericVIPiece -lt 10

		then
			echo 0$(echo $idNumericVIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVPiece"
					else
				idNumericPreviousPiece="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"
				## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
		
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIPiecePrevious)
			fi


		else

                        echo $(echo $idNumericVIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIPiecePrevious)

				## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi
		
			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece"

			if [ ! -f /tmp/xmluxe-itemGradusVI ]; then

				echo "I paragraph of an element" > /tmp/xmluxe-firstElementGradusVI

				### first paragraph not of an subsubsection but of the entire document

				clear 

			java /usr/local/lib/xmlux/java/xmluxe/matter/paragraphFileWriter7.java
                        
			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece"

			fi

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine-2| bc > /tmp/xmluxe-numberLineMinusMinus
			
leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusVI)"
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusVI)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx


 fi

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe
	
fi

################# INIZIO SUBPARAGRAPH LMXE, LMX

	if test $leggoElementKind -eq 6

	then
	## l'elemento da aggiungere è un subparagraph

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

		idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

		idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f7,7 > /tmp/xmluxe-idNumericVIIPiece

		idNumericVIIPiece="$(cat /tmp/xmluxe-idNumericVIIPiece)"

			## Controllo coerenza locale, se non esiste il padre (element section)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No paragraph element $leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece exists
to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi

		if test $idNumericVIIPiece -lt 10

		then
			echo 0$(echo $idNumericVIIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVIPiece"
					else

				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)

			## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add 
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
	
			fi


		else

                        echo $(echo $idNumericVIIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)

			## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi
		
			if [ -f /tmp/xmluxe-Ichild ]; then
			
			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece"
	
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			echo "I subparagraph of an element" > /tmp/xmluxe-firstElementGradusVII

			

			if [ ! -f /tmp/xmluxe-itemGradusVII ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece"


				### first subparagraph not of a paragraph but of the entire document
				clear 

			java /usr/local/lib/xmlux/java/xmluxe/matter/subparagraphFileWriter7.java

			fi


			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece"
			
			fi
			
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)


if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine-2| bc > /tmp/xmluxe-numberLineMinusMinus
			
leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusVII)"
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi


########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusVII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx


	fi

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi


fi




grep "remove" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRemove

stat --format %s /tmp/xmluxe-actionRemove > /tmp/xmluxe-actionRemoveBytes

leggoBytes=$(cat /tmp/xmluxe-actionRemoveBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionRemove | cut -d= -f2,2 | awk '$1 > 0 {print $1}' >  /tmp/xmluxe-idToRemove

idToRemove="$(cat /tmp/xmluxe-idToRemove)"

grep -n "ID=\"$idToRemove\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRemoveBeginLine

nLineBeginIdToRemove=$(cat /tmp/xmluxe-idToRemoveBeginLine)

grep -n "<!-- end $idToRemove -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRemoveEndLine

nLineEndIdToRemove=$(cat /tmp/xmluxe-idToRemoveEndLine)

linesToDelete=$(echo $nLineEndIdToRemove - $nLineBeginIdToRemove | bc)

echo "$nLineBeginIdToRemove Gd$linesToDelete
ZZ

" | sed 's/ //g' > /tmp/xmluxe-blockToDelete


vim -s /tmp/xmluxe-blockToDelete $targetFile.lmx

	echo "
$(date +"%Y-%m-%d-%H-%M")	$idToRemove removed" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

fi

grep "^--jump" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump

stat --format %s /tmp/xmluxe-actionJump > /tmp/xmluxe-actionJumpBytes

leggoBytes=$(cat /tmp/xmluxe-actionJumpBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionJump | cut -d= -f2,2 | awk '$1 > 0 {print $1}' >  /tmp/xmluxe-idToJump

idToJump="$(cat /tmp/xmluxe-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xmluxe-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

fi


grep "^--sort" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSort

stat --format %s /tmp/xmluxe-actionSort > /tmp/xmluxe-actionSortBytes

leggoBytes=$(cat /tmp/xmluxe-actionSortBytes)

if test $leggoBytes -gt 0

then
	rm -fr /tmp/pseudoOptionsBackup-xmluxe

	cp -r /tmp/xmluxePseudoOptions/ /tmp/pseudoOptionsBackup-xmluxe

	## Sorting by titles or by names

	grep "^-t" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeSortByTitle

	stat --format %s /tmp/xmluxeSortByTitle > /tmp/xmluxeSortByTitleBytes

	leggoBytes=$(cat /tmp/xmluxeSortByTitleBytes)

	if test $leggoBytes -gt 0

	then

		/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byTitle.sh

	else
		## default

		/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byName.sh
	fi

#	grep "^-n" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeSortByName

#	stat --format %s /tmp/xmluxeSortByName > /tmp/xmluxeSortByNameBytes

#	leggoBytes=$(cat /tmp/xmluxeSortByNameBytes)

#	if test $leggoBytes -gt 0

#	then

#		/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byName.sh

#	fi



#	rm -fr /tmp/xmluxePseudoOptions
if [ ! -d /tmp/xmluxePseudoOptions ]; then

	cp -r /tmp/pseudoOptionsBackup-xmluxe /tmp/xmluxePseudoOptions
fi

fi

grep "ins" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionInsert

stat --format %s /tmp/xmluxe-actionInsert > /tmp/xmluxe-actionInsertBytes

leggoBytes=$(cat /tmp/xmluxe-actionInsertBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionInsert | cut -d= -f2,2 | awk '$1 > 0 {print $1}' > /tmp/insXmluxe-idToInsert

	rm -fr /tmp/pseudoOptionsBackup-xmluxe

	cp -r /tmp/xmluxePseudoOptions/ /tmp/pseudoOptionsBackup-xmluxe

	rm -fr /tmp/InsXmluxe-PseudoOptions

	cp -r /tmp/xmluxePseudoOptions /tmp/InsXmluxe-PseudoOptions
	
        /usr/local/lib/xmlux/xmluxeScripts/insert/insert.sh

#	rm -fr /tmp/xmluxePseudoOptions

if [ ! -d /tmp/xmluxePseudoOptions ]; then

	cp -r /tmp/pseudoOptionsBackup-xmluxe /tmp/xmluxePseudoOptions
fi

fi

######### Select id block in read-only mode
grep "selectR" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR

stat --format %s /tmp/xmluxe-actionSelectR > /tmp/xmluxe-actionSelectRBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectR | cut -d= -f2,2 | awk '$1 > 0 {print $1}' >  /tmp/xmluxe-idToSelectR

idToSelectR="$(cat /tmp/xmluxe-idToSelectR)"

grep -n "ID=\"$idToSelectR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectRBeginLine

nLineBeginIdToSelectR=$(cat /tmp/xmluxe-idToSelectRBeginLine)

grep -n "<!-- end $idToSelectR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectR=$(cat /tmp/xmluxe-idToSelectREndLine)

echo $nLineEndIdToSelectR - $nLineBeginIdToSelectR | bc > /tmp/xmluxe-linesToSelect

linesToSelectR=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectRPlusComment=$(($linesToSelectR + 1))

#echo "$nLineBeginIdToSelectR Gd$linesToSelectR
#ZZ

#" | sed 's/ //g' > /tmp/xmluxe-blockToSelectR


#vim -s /tmp/xmluxe-blockToSelectR $targetFile.lmx

#### Fine 'se dovessi rimuovere il blocco'.

### inizio modifica rispetto a remove
cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#grep -n "<!-- end $idToSelectR -->" /tmp/xmluxe-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xmluxe-idToSelectREndLine

#echo " "
#echo "
#Prima linea da selezionare:
#$nLineBeginIdToSelectR testing
#real $realFirstLine testing

#Linee da selezionare:
#$linesToSelectR testing
#con commento finale $linesToSelectRPlusComment testing

#/tmp/xmluxe-bloccoSelezionato.lmx testing
#" 

#read -p "testing 6392" EnterNull

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
echo  "$linesToSelectR GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato

vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

gview -f /tmp/xmluxe-bloccoSelezionato.lmx


## fine modifica rispetto a remove

	echo "
$(date +"%Y-%m-%d-%H-%M")	$idToSelectR selected in read-only mode" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

#read -p "testing 6421" EnterNull

fi

######### Select id block in write mode

grep "selectW" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW

stat --format %s /tmp/xmluxe-actionSelectW > /tmp/xmluxe-actionSelectWBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectWBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectW | cut -d= -f2,2 | awk '$1 > 0 {print $1}' >  /tmp/xmluxe-idToSelectW

idToSelectW="$(cat /tmp/xmluxe-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xmluxe-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWEndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xmluxe-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xmluxe-linesToSelect

linesToSelectW=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

#echo "$nLineBeginIdToSelectW Gd$linesToSelectW
#ZZ

#" | sed 's/ //g' > /tmp/xmluxe-blockToSelectW

#vim -s /tmp/xmluxe-blockToSelectW $targetFile.lmx

#### Fine 'se dovessi rimuovere il blocco'.

### inizio modifica rispetto a remove
cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#grep -n "<!-- end $idToSelectW -->" /tmp/xmluxe-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWEndLine

#echo " "
#echo "
#Prima linea da selezionare:
#$nLineBeginIdToSelectW testing
#real $realFirstLine testing

#Linee da selezionare:
#$linesToSelectW testing
#con commento finale $linesToSelectWPlusComment testing

#/tmp/xmluxe-bloccoSelezionato.lmx testing
#" 

#read -p "testing 6392" EnterNull

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
echo  "$linesToSelectW GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato

vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

gvim -f /tmp/xmluxe-bloccoSelezionato.lmx

realFirstLine=$(($nLineBeginIdToSelectW - 1))

#cat $targetFile.lmx | sed -n '1,'$nLineBeginIdToSelectW'p' > /tmp/xmluxe-targetFile-blocco_01.lmx

cat $targetFile.lmx | sed -n '1,'$realFirstLine'p' > /tmp/xmluxe-targetFile-blocco_01.lmx

awk '{ nlines++;  print nlines }' $targetFile.lmx | tail -n1 > /tmp/xmluxe-nLines

nLines=$(cat /tmp/xmluxe-nLines)

cat $targetFile.lmx | sed -n ''$nLineEndIdToSelectW','$nLines'p' > /tmp/xmluxe-targetFile-blocco_03.lmx

## composizione

cat /tmp/xmluxe-targetFile-blocco_01.lmx /tmp/xmluxe-bloccoSelezionato.lmx > /tmp/xmluxe-targetFile-blocco_02.lmx

cat /tmp/xmluxe-targetFile-blocco_02.lmx /tmp/xmluxe-targetFile-blocco_03.lmx > /tmp/xmluxe-targetFile-blocco_04.lmx

cp /tmp/xmluxe-targetFile-blocco_04.lmx $targetFile.lmx


	echo "
$(date +"%Y-%m-%d-%H-%M")	$idToSelectW selected in write mode" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

fi



rm -fr /tmp/xmluxe*


exit

