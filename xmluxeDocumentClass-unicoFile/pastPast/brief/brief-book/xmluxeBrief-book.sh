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

############# INIZIO SINOSSI 

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

	echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-sinossi

	idSinossi="$(cat /tmp/xmluxe-sinossi)"

	## sinossi: un solo numero (un solo zero)
	if test "$leggoID" == "$idSinossi"

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

	cp /tmp/xmluxe-item /tmp/xmluxe-itemSinossi

	rm -f /tmp/xmluxe-cssRoot/$c
        
	fi

done

############# FINE SINOSSI 

################ INIZIO  PART

mkdir /tmp/xmluxe-parts

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


	#### Part, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

		cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-parts

		cp /tmp/xmluxe-item /tmp/xmluxe-itemPart

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE PART 

############## INIZIO CHAPTERS
mkdir /tmp/xmluxe-chapters

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

	#### Capitolo: il capitolo, insieme a part, non ha mai punti nell'ID; ma part lo risolvo diversamente.

	if test $leggoDotFrequency -eq 1

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-chapters

cp /tmp/xmluxe-item /tmp/xmluxe-itemChapter

rm -f /tmp/xmluxe-cssRoot/$c

	fi
	
done
################ FINE CHAPTERS 

################ INIZIO SECTION

mkdir /tmp/xmluxe-sections

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

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-sections

cp /tmp/xmluxe-item /tmp/xmluxe-itemSection

rm -f /tmp/xmluxe-css05Split/$d

fi

done

################ FINE SECTION

################ INIZIO SUBSECTION

mkdir /tmp/xmluxe-subsections

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

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-subsections

cp /tmp/xmluxe-item /tmp/xmluxe-itemSubsection

        rm -f /tmp/xmluxe-css05Split/$d
	
	fi

done

################ FINE SUBSECTION 

################ INIZIO SUBSUBSECTION

mkdir /tmp/xmluxe-subsubsections

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemSubsubsection

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-subsubsections

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE SUBSUBSECTION 

################ INIZIO PARAPGRAPH

mkdir /tmp/xmluxe-paragraphs

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemParagraph

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-paragraphs

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE PARAGRAPH

################ INIZIO SUBPARAGRAPH
mkdir /tmp/xmluxe-subparagraphs

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemSubparagraph

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-subparagraphs

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

	########### inizio part move

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

				touch /tmp/xmluxe-partsList

				for b in $(ls /tmp/xmluxe-parts)

				do

				leggoB="$(cat /tmp/xmluxe-parts/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-partsList

				done

				cat /tmp/xmluxe-partsList | sort > /tmp/xmluxe-partsListSorted

				cat /tmp/xmluxe-partsListSorted | tail -n1 > /tmp/xmluxe-partsListSortedMax0

				cat /tmp/xmluxe-partsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-partsListSortedMax01

				cat /tmp/xmluxe-partsListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-partsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-partsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-partsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-partsListSortedMax)"

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

				touch /tmp/xmluxe-partsList

				for b in $(ls /tmp/xmluxe-parts)

				do

				leggoB="$(cat /tmp/xmluxe-parts/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-partsList

				done

				cat /tmp/xmluxe-partsList | sort > /tmp/xmluxe-partsListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

cat /tmp/xmluxe-partsList | sort > /tmp/xmluxe-partsListSorted

				cat /tmp/xmluxe-partsListSorted | tail -n1 > /tmp/xmluxe-partsListSortedMax0

				cat /tmp/xmluxe-partsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-partsListSortedMax01

				cat /tmp/xmluxe-partsListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-partsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-partsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-partsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-partsListSortedMax)"

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

############## fine part move

### inizio chapter move	
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

				touch /tmp/xmluxe-chaptersList

				for b in $(ls /tmp/xmluxe-chapters)

				do

				leggoB="$(cat /tmp/xmluxe-chapters/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-chaptersList

				done
### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-chaptersPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-chaptersPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-chaptersList >  /tmp/xmluxe-chaptersListToSort

				cat /tmp/xmluxe-chaptersListToSort | sort > /tmp/xmluxe-chaptersListSorted

				cat /tmp/xmluxe-chaptersListSorted | tail -n1 > /tmp/xmluxe-chaptersListSortedMax0

				cat /tmp/xmluxe-chaptersListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-chaptersListSortedMax01

				cat /tmp/xmluxe-chaptersListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-chaptersListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-chaptersListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-chaptersListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-chaptersListSortedMax)"

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

				touch /tmp/xmluxe-chaptersList

				for b in $(ls /tmp/xmluxe-chapters)

				do

				leggoB="$(cat /tmp/xmluxe-chapters/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-chaptersList

				done

				### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-chaptersPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-chaptersPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-chaptersList >  /tmp/xmluxe-chaptersListToSort

				cat /tmp/xmluxe-chaptersListToSort | sort > /tmp/xmluxe-chaptersListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-chaptersListSorted | tail -n1 > /tmp/xmluxe-chaptersListSortedMax0

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-chaptersListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-chaptersListSortedMax01

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-chaptersListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-chaptersListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-chaptersListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-chaptersListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-chaptersListSortedMax)"

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

### inizio sections move	
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

				touch /tmp/xmluxe-sectionsList

				for b in $(ls /tmp/xmluxe-sections)

				do

				leggoB="$(cat /tmp/xmluxe-sections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-sectionsList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-sectionsPrefixToMatch

				leggoSectionsPrefixToMatch="$(cat /tmp/xmluxe-sectionsPrefixToMatch)"

				grep "$leggoSectionsPrefixToMatch" /tmp/xmluxe-sectionsList > /tmp/xmluxe-sectionsListToSort

				cat /tmp/xmluxe-sectionsListToSort | sort > /tmp/xmluxe-sectionsListSorted

				cat /tmp/xmluxe-sectionsListSorted | tail -n1 > /tmp/xmluxe-sectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-sectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-sectionsListSortedMax01
				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-sectionsListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-sectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-sectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-sectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-sectionsListSortedMax)"

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

				touch /tmp/xmluxe-sectionsList

				for b in $(ls /tmp/xmluxe-sections)

				do

				leggoB="$(cat /tmp/xmluxe-sections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-sectionsList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-sectionsPrefixToMatch

				leggoSectionsPrefixToMatch="$(cat /tmp/xmluxe-sectionsPrefixToMatch)"

				grep "$leggoSectionsPrefixToMatch" /tmp/xmluxe-sectionsList >  /tmp/xmluxe-sectionsListToSort

				cat /tmp/xmluxe-sectionsListToSort | sort > /tmp/xmluxe-sectionsListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-sectionsListSorted | tail -n1 > /tmp/xmluxe-sectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-sectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-sectionsListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-sectionsListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-sectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-sectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-sectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-sectionsListSortedMax)"

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

################# fine section move

### inizio subsections move	
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

				touch /tmp/xmluxe-subsectionsList

				for b in $(ls /tmp/xmluxe-subsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsectionsList

				done
### ricordati di aggiungere $idNumericIVPiece NON VPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" | sed 's/ //g' > /tmp/xmluxe-subsectionsPrefixToMatch

				leggoSubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsectionsPrefixToMatch)"

				grep "$leggoSubsectionsPrefixToMatch" /tmp/xmluxe-subsectionsList > /tmp/xmluxe-subsectionsListToSort

				cat /tmp/xmluxe-subsectionsListToSort | sort > /tmp/xmluxe-subsectionsListSorted

				cat /tmp/xmluxe-subsectionsListSorted | tail -n1 > /tmp/xmluxe-subsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsection
				cat /tmp/xmluxe-subsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsectionsListSortedMax01
				### ricordati di cambiare -f4,4 in -f5,5 per la subsubsection
				cat /tmp/xmluxe-subsectionsListSortedMax01 | cut -d. -f4,4 > /tmp/xmluxe-subsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

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

				touch /tmp/xmluxe-subsectionsList

				for b in $(ls /tmp/xmluxe-subsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsectionsList

				done
### ricordati di aggiungere alla sottosottosezione $idNumericIVPiece NON VPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" | sed 's/ //g' > /tmp/xmluxe-subsectionsPrefixToMatch

				leggoSubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsectionsPrefixToMatch)"

				grep "$leggoSubsectionsPrefixToMatch" /tmp/xmluxe-subsectionsList >  /tmp/xmluxe-subsectionsListToSort

				cat /tmp/xmluxe-subsectionsListToSort | sort > /tmp/xmluxe-subsectionsListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-subsectionsListSorted | tail -n1 > /tmp/xmluxe-subsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsection
				cat /tmp/xmluxe-subsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsectionsListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsubsection
				cat /tmp/xmluxe-subsectionsListSortedMax01 | cut -d. -f4,4 > /tmp/xmluxe-subsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

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

################# fine subsection

################# inizio subsubsections
### inizio subsubsections move	
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

				touch /tmp/xmluxe-subsubsectionsList

				for b in $(ls /tmp/xmluxe-subsubsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsubsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsubsectionsList

				done
### ricordati di aggiungere $idNumericVPiece NON VIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" | sed 's/ //g' > /tmp/xmluxe-subsubsectionsPrefixToMatch

				leggoSubsubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsubsectionsPrefixToMatch)"

				grep "$leggoSubsubsectionsPrefixToMatch" /tmp/xmluxe-subsubsectionsList > /tmp/xmluxe-subsubsectionsListToSort

				cat /tmp/xmluxe-subsubsectionsListToSort | sort > /tmp/xmluxe-subsubsectionsListSorted

				cat /tmp/xmluxe-subsubsectionsListSorted | tail -n1 > /tmp/xmluxe-subsubsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubsection
				cat /tmp/xmluxe-subsubsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsubsectionsListSortedMax01
				### ricordati di cambiare -f5,5 in -f6,6 per il paragraph
				cat /tmp/xmluxe-subsubsectionsListSortedMax01 | cut -d. -f5,5 > /tmp/xmluxe-subsubsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsubsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

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

				touch /tmp/xmluxe-subsubsectionsList

				for b in $(ls /tmp/xmluxe-subsubsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsubsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsubsectionsList

				done
### ricordati di aggiungere a paragraph $idNumericVPiece NON VIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" | sed 's/ //g' > /tmp/xmluxe-subsubsectionsPrefixToMatch

				leggoSubsubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsubsectionsPrefixToMatch)"

				grep "$leggoSubsubsectionsPrefixToMatch" /tmp/xmluxe-subsubsectionsList >  /tmp/xmluxe-subsubsectionsListToSort

				cat /tmp/xmluxe-subsubsectionsListToSort | sort > /tmp/xmluxe-subsubsectionsListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-subsubsectionsListSorted | tail -n1 > /tmp/xmluxe-subsubsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubsection
				cat /tmp/xmluxe-subsubsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsubsectionsListSortedMax01

				### ricordati di cambiare -f5,5 in -f6,6 per la subsubsubsection
				cat /tmp/xmluxe-subsubsectionsListSortedMax01 | cut -d. -f5,5 > /tmp/xmluxe-subsubsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsubsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

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

################# fine subsubsection

################# inizio paragraph
### inizio paragraphs move	
## ricordati di cambiare 5 in 6 in subparagraph
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

				touch /tmp/xmluxe-paragraphsList

				for b in $(ls /tmp/xmluxe-paragraphs)

				do

				leggoB="$(cat /tmp/xmluxe-paragraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-paragraphsList

				done
### ricordati di aggiungere in subparagraph $idNumericVIPiece NON VIIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" | sed 's/ //g' > /tmp/xmluxe-paragraphsPrefixToMatch

				leggoParagraphsPrefixToMatch="$(cat /tmp/xmluxe-paragraphsPrefixToMatch)"

				grep "$leggoParagraphsPrefixToMatch" /tmp/xmluxe-paragraphsList > /tmp/xmluxe-paragraphsListToSort

				cat /tmp/xmluxe-paragraphsListToSort | sort > /tmp/xmluxe-paragraphsListSorted

				cat /tmp/xmluxe-paragraphsListSorted | tail -n1 > /tmp/xmluxe-paragraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subparagraph
				cat /tmp/xmluxe-paragraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-paragraphsListSortedMax01
				### ricordati di cambiare -f6,6 in -f7,7 per il paragraph
				cat /tmp/xmluxe-paragraphsListSortedMax01 | cut -d. -f6,6 > /tmp/xmluxe-paragraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-paragraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

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

				touch /tmp/xmluxe-paragraphsList

				for b in $(ls /tmp/xmluxe-paragraphs)

				do

				leggoB="$(cat /tmp/xmluxe-paragraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-paragraphsList

				done
### ricordati di aggiungere a subparagraph $idNumericVIPiece NON VIIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" | sed 's/ //g' > /tmp/xmluxe-paragraphsPrefixToMatch

				leggoParagraphsPrefixToMatch="$(cat /tmp/xmluxe-paragraphsPrefixToMatch)"

				grep "$leggoParagraphsPrefixToMatch" /tmp/xmluxe-paragraphsList >  /tmp/xmluxe-paragraphsListToSort

				cat /tmp/xmluxe-paragraphsListToSort | sort > /tmp/xmluxe-paragraphsListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-paragraphsListSorted | tail -n1 > /tmp/xmluxe-paragraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a parapraph
				cat /tmp/xmluxe-paragraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-paragraphsListSortedMax01

				### ricordati di cambiare -f6,6 in -f7,7 per subparagraph
				cat /tmp/xmluxe-paragraphsListSortedMax01 | cut -d. -f6,6 > /tmp/xmluxe-paragraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-paragraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

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

################# fine paragraph

################# inizio subparagraph
################# inizio subparagraph
### inizio subparagraphs move	
## ricordati di cambiare 6 in 7 nel livello inferiore a subsubparagraph
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

				touch /tmp/xmluxe-subparagraphsList

				for b in $(ls /tmp/xmluxe-subparagraphs)

				do

				leggoB="$(cat /tmp/xmluxe-subparagraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subparagraphsList

				done
### ricordati di aggiungere nel livello inferiore al subsubparagraph $idNumericVIIPiece NON VIIIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" | sed 's/ //g' > /tmp/xmluxe-subparagraphsPrefixToMatch

				leggoSubparagraphsPrefixToMatch="$(cat /tmp/xmluxe-subparagraphsPrefixToMatch)"

				grep "$leggoSubparagraphsPrefixToMatch" /tmp/xmluxe-subparagraphsList > /tmp/xmluxe-subparagraphsListToSort

				cat /tmp/xmluxe-subparagraphsListToSort | sort > /tmp/xmluxe-subparagraphsListSorted

				cat /tmp/xmluxe-subparagraphsListSorted | tail -n1 > /tmp/xmluxe-subparagraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubparagraph
				cat /tmp/xmluxe-subparagraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subparagraphsListSortedMax01
				### ricordati di cambiare -f7,7 in -f8,8 nel livello inferiore a subparagraph
				cat /tmp/xmluxe-subparagraphsListSortedMax01 | cut -d. -f7,7 > /tmp/xmluxe-subparagraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subparagraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

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

				touch /tmp/xmluxe-subparagraphsList

				for b in $(ls /tmp/xmluxe-subparagraphs)

				do

				leggoB="$(cat /tmp/xmluxe-subparagraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subparagraphsList

				done
### ricordati nel livello ingeriore a subparagraph di aggiungere $idNumericVIPiece NON VIIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" | sed 's/ //g' > /tmp/xmluxe-subparagraphsPrefixToMatch

				leggoSubparagraphsPrefixToMatch="$(cat /tmp/xmluxe-subparagraphsPrefixToMatch)"

				grep "$leggoSubparagraphsPrefixToMatch" /tmp/xmluxe-subparagraphsList >  /tmp/xmluxe-subparagraphsListToSort

				cat /tmp/xmluxe-subparagraphsListToSort | sort > /tmp/xmluxe-subparagraphsListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-subparagraphsListSorted | tail -n1 > /tmp/xmluxe-subparagraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subparapraph
				cat /tmp/xmluxe-subparagraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subparagraphsListSortedMax01

				### ricordati di cambiare -f7,7 in -f8,8 nel livello inferiore a subsubparagraph
				cat /tmp/xmluxe-subparagraphsListSortedMax01 | cut -d. -f7,7 > /tmp/xmluxe-subparagraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subparagraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

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

################# fine subparagraph

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

################# INIZIO SINOSSI LMXE, LMX

		grep "00" /tmp/xmluxe-elementToAdd > /tmp/xmluxe-sinossiOrNot

		stat --format %s /tmp/xmluxe-sinossiOrNot > /tmp/xmluxe-sinossiOrNotBytes
	
		leggoBytesSinossi=$(cat /tmp/xmluxe-sinossiOrNotBytes)

		## II if 
		if test $leggoBytesSinossi -gt 0
		then

			## l'elemento da aggiungere è sinossi, la sinossi ha 00
			# da fare

			## Verifico che la sinossi davvero non esiste, e che quindi l'utente non stia sbagliando
			# avolerla aggiungere

			clear

			java /usr/local/lib/xmlux/java/xmluxe/matter/synopsisFileWriter7.java

			echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi

			leggoIDToAdd="$(cat /tmp/xmluxe-idSinossi)"

			grep -n "<$(cat /tmp/xmluxe-itemRoot) ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

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
leggoItem="$(cat /tmp/xmluxe-itemSinossi)"

### III if
		if [ -f /tmp/xmluxe-optionW.lmx ]; then

			echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the synopsis to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

		fi
### chiusura III if

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

	fi
	### chiusura II if

################# INIZIO PART LMXE, LMX

## I if
		if test ! $leggoBytesSinossi -gt 0 
			
		then 

		## l'elemento da aggiungere è una parte 
	
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericPiece

		idNumericPiece=$(cat /tmp/xmluxe-idNumericPiece)
## II if
		if test $idNumericPiece -lt 10

		then
			echo 0$(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousPart

			leggoIdNumericPiecePreviousPart=$(cat /tmp/xmluxe-idNumericPiecePreviousPart)
### III if
			if test $leggoIdNumericPiecePreviousPart == "00"
			then

				echo "è la prima parte del documento" > /tmp/xmluxe-Ichild

					else
				idNumericPiecePreviousPart=$(cat /tmp/xmluxe-idNumericPiecePreviousPart)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousPart$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousPart doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit
				
				fi
## chiusura IV if

			fi
## chiusura III if


		else

                        echo $(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousPart

			leggoIdNumericPiecePreviousPart=$(cat /tmp/xmluxe-idNumericPiecePreviousPart)
### III if
			if test $leggoIdNumericPiecePreviousPart == "0"
			 then

				 echo "è la prima parte del documento" > /tmp/xmluxe-IParte

			else
				idNumericPiecePreviousPart=$(cat /tmp/xmluxe-idNumericPiecePreviousPart)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousPart$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousPart doesn't exist, but you would like to add
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

### In alternativa hai anche /tmp/xmluxe-IParte
			if [ ! -f /tmp/xmluxe-itemPart ]; then

			clear 

                        java /usr/local/lib/xmlux/java/xmluxe/matter/partFileWriter7.java 

			## non è obbligatorio avere la sinossi nel documento, quindi se non esiste devo
			## appendere la part subito dopo l'inizio di <root ID ...

			if [ -f /tmp/xmluxe-itemSinossi ]; then

				echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-append

				idNumericPiecePreviousPart="$(cat /tmp/xmluxe-append)"

				grep -n "<!-- end $idNumericPiecePreviousPart -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			else

				echo "$leggoIdRoot" | sed 's/ //g' > /tmp/xmluxe-append

				idNumericPiecePreviousPart="$(cat /tmp/xmluxe-append)"

				grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
	
			fi
		
		else

			grep -n "<!-- end $leggoIdRoot$idNumericPiecePreviousPart -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

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
leggoItem="$(cat /tmp/xmluxe-itemPart)"

### II if
		if [ -f /tmp/xmluxe-optionW.lmx ]; then

			echo "Insert title of the part to add, starting from line number 3.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
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
	fi

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
			if [ -f /tmp/xmluxe-itemPart ]; then

			grep -n "ID=\"$leggoIdRoot$idNumericPrevious\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			else

			## non è detto che esista una sinossi, non è obbligatoria
			if [ -f /tmp/xmluxe-itemSinossi ]; then
			
			echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi 

			leggoIdSinossi="$(cat /tmp/xmluxe-idSinossi)"

		  	grep -n "<!-- end $leggoIdSinossi -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			else

			## se non esiste né la parte, né la sinossi, allora appendo subito dopo l'inizio di <root
			grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			# echo "append under root" > /tmp/xmluxe-appendUnderRoot

			fi

			fi
			
			if [ ! -f /tmp/xmluxe-itemChapter ]; then

			echo "I chapter of a part" > /tmp/xmluxe-firstElementChapter

				### first chapter not of a part but of the entire document

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

	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

echo $leggoNumberLine + 1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus


else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

	fi

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
leggoItem="$(cat /tmp/xmluxe-itemChapter)"


	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the chapter to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
leggoItem="$(cat /tmp/xmluxe-itemChapter)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the chapter to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "00"
			
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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "0"
			
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

				if [ -f /tmp/xmluxe-itemChapter ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece"
			
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

				else
					## se il capitolo non esiste, posso appendere dopo la sinossi se questa esiste,
					## non è obbligatorio che la sinossi esista.

					if [ -f /tmp/xmluxe-itemSinossi ]; then

						echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi

						leggoIdSinossi="$(cat /tmp/xmluxe-idSinossi)"

					grep -n "<!-- end $leggoIdSinossi -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

						else
						## siccome non è obbligatorio che la sinossi esista, allora appendo all'interno di root
						## quindi in tal caso non esiste né il capitolo, né la sinossi; la parte non la testo
						## perché se non esiste il capitolo non esiste nemmeno la parte.
	
					grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

					fi
			fi

			## Non fare confusione tra I child e l'esistenza di ...-itemSection, il I child si riferisce
			## all'appartenza a uno specifico padre, mentre  ...-itemSection si riferisce all'esistenza
			## di un elemento 'section' all'interno di tutto il documento -- non all'interno di uno specifico padre --.
			if [ ! -f /tmp/xmluxe-itemSection ]; then

	
				echo "I section of an element" > /tmp/xmluxe-firstElementSection

			
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

	if [ -f /tmp/xmluxe-itemChapter ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus

	else
	
	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine | bc > /tmp/xmluxe-numberLineMinusMinus

	fi


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
leggoItem="$(cat /tmp/xmluxe-itemSection)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the section to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
leggoItem="$(cat /tmp/xmluxe-itemSection)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the section to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericIVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "00"
			
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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericIVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "0"
			
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

			if [ ! -f /tmp/xmluxe-itemSubsection ]; then

				echo "I subsection of an element" > /tmp/xmluxe-firstElementSubsection

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
leggoItem="$(cat /tmp/xmluxe-itemSubsection)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the subsection to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
leggoItem="$(cat /tmp/xmluxe-itemSubsection)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the subsection to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "00"
			
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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "0"
			
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

			if [ ! -f /tmp/xmluxe-itemSubsubsection ]; then

				echo "I subsubsection of an element" > /tmp/xmluxe-firstElementSubsubsection
			
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
leggoItem="$(cat /tmp/xmluxe-itemSubsubsection)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the subsubsection to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
leggoItem="$(cat /tmp/xmluxe-itemSubsubsection)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the subsubsection to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "00"
			
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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "0"
			
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

			if [ ! -f /tmp/xmluxe-itemParagraph ]; then

				echo "I paragraph of an element" > /tmp/xmluxe-firstElementParagraph

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
leggoItem="$(cat /tmp/xmluxe-itemParagraph)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the paragraph to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
leggoItem="$(cat /tmp/xmluxe-itemParagraph)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the paragraph to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "00"
			
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

			leggoIdNumericPiecePreviousPart="$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousPart == "0"
			
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

			echo "I subparagraph of an element" > /tmp/xmluxe-firstElementSubparagraph

			

			if [ ! -f /tmp/xmluxe-itemSubparagraph ]; then

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
leggoItem="$(cat /tmp/xmluxe-itemSubparagraph)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the subparagraph to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
leggoItem="$(cat /tmp/xmluxe-itemSubparagraph)"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of the subparagraph to add. At the end save and exit.
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

else

		echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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
######### Select id block in read-only mode


grep "selectR" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR

stat --format %s /tmp/xmluxe-actionSelectR > /tmp/xmluxe-actionSelectRBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectR | cut -d= -f2,2 | awk '$1 > 0 {print $1}' >  /tmp/xmluxe-idToSelectR

idToSelectR="$(cat /tmp/xmluxe-idToSelectR)"

grep -n "ID="$idToSelectR"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectRBeginLine

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

grep -n "ID="$idToSelectW"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWBeginLine

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

