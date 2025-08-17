#!/bin/bash

### Regola: I titoli devono essere scritti, possibilmente, con _ e /o - separatori, e.g. Mario_Marcello-Fantini,
## o in camel case.
##
### Regola: Per ordinare crescendo e.g. i GradusIII a01.01.01, va eseguita e.g. l'istanza ascendente:
##  ~$> xmluxe --sort-a=a01.01.01 --f=*
#
### Regola: Per ordinare descrescendo e.g. i GradusIII a01.01.01, va eseguita e.g. l'istanza discendente:
##  ~$> xmluxe --sort-d=a01.01.01 --f=*
#
##^^^^^^^^^^^^^ Ascending sort
## ascendente: dalla A alla Z, da 0 a +infinito
#
### Regola: non devono esserci titoli, keys (interni a un item) uguali --- ovviamente. 
#
##^^^^^^^^^^^^^ Descending sort 
## ascendente: dalla Z alla A, da +infinito a 0
#
### Regola: non devono esserci titoli, keys (interni a un item) uguali --- ovviamente. 

rm -fr /tmp/xmluxse*

targetFile="$(cat /tmp/xmluxeTargetFile)"

##  /tmp/xmluxse-targetFile
# potrebbe servire in futuro agli script di formattazione lanciato da questo, in quanto
# /tmp/xmluxeTargetFile viene elminato da xmluxe lanciato internamente (sempre) da questo.
#cp /tmp/xmluxeTargetFile /tmp/xmluxse-targetFile

cat $targetFile.lmx | sed -n '/<!-- begin radix/,$p' > /tmp/xmluxe-css0000

## mi serve la coerenza di numero di righe tra il file lmx in cui effettuerò le iniezioni
## e il file selezionato in cui ho escluso il preambolo.
grep -n "<!-- begin radix" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxe-nLineaBeginRadix

leggoNBeginRadix=$(cat /tmp/xmluxe-nLineaBeginRadix)

righeEsatte=$(($leggoNBeginRadix - 1))

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

leggoIdRoot=$(cat /tmp/xmluxe-idRoot)

sorta () {

	cat /tmp/xmluxseSort-actionSortID-aResp  | cut -d= -f2,2 > /tmp/xmluxseSort-IDValue

	IDmain="$(cat /tmp/xmluxseSort-IDValue)"

	/usr/local/bin/xmluxv -in -s --f=$targetFile

	cat /tmp/xmluxev-blockToView | sed '/<!--/d' | sed '/-->/d' > /tmp/xmluxsev-blockToViewSed

#	read -p "testing 36" EnterNull

	## il titolo principale del file non devo ordinarlo ovviamente
	vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxsev-blockToViewSed

	awk '{ nlines++;  print nlines }' /tmp/xmluxsev-blockToViewSed | tail -n1 > /tmp/xmluxsev-blockToViewSedToFreq

	nLines=$(cat /tmp/xmluxsev-blockToViewSedToFreq)


	sed 's/[^.]//g' /tmp/xmluxseSort-IDValue | awk '{ print length }' > /tmp/xmluxe-dotFrequency

#	read -p "testing 48" EnterNull
	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	declare -i var=0

	for a in `seq $nLines`

	do

		var=var+1

	cat /tmp/xmluxsev-blockToViewSed | head -n$var | tail -n1 | awk '$1 > 0 {print $1}' > /tmp/xmluxse-IDFrequencyCheck

	sed 's/[^.]//g' /tmp/xmluxse-IDFrequencyCheck  | awk '{ print length }' > /tmp/xmluxe-dotFrequencyVar

#	read -p "testing 63" EnterNull
	dotFreqVar=$(cat /tmp/xmluxe-dotFrequencyVar)

	if test $dotFreqVar -eq $leggoDotFrequency

	then
		sed -n ''$var'p' /tmp/xmluxsev-blockToViewSed >> /tmp/xmluxsev-blockToViewScelto

#	read -p "testing 71" EnterNull
	fi

done
	awk '{ nlines++;  print nlines }' /tmp/xmluxsev-blockToViewScelto | tail -n1 > /tmp/xmluxseSort-namesLines

	nNamesLines=$(cat /tmp/xmluxseSort-namesLines)

	declare -i var=0

	for a in `seq $nNamesLines`

	do
		var=var+1

		cat /tmp/xmluxsev-blockToViewScelto | head -n$var | tail -n1 | awk '{for(i=2;i<=NF;i++) print " " $i}' | tr -d '\n' | sed 's/^.//g' >> /tmp/xmluxse-nameVar00
		echo "" >> /tmp/xmluxse-nameVar00


	done

	sed '/^$/d' /tmp/xmluxse-nameVar00 > /tmp/xmluxse-nameVar

	#read -p "
	#testing 101
	#cat /tmp/xmluxse-nameVar
	#" EnterNull

	cat /tmp/xmluxse-nameVar  | sed 's/.* "//g' | sed 's/"//g' > /tmp/xmluxse-nameVarClean
	
	cat /tmp/xmluxse-nameVarClean | sort  > /tmp/xmluxseSort-names

	declare -i var=0

	for a in `seq $nNamesLines`

	do
		var=var+1

		
		cat /tmp/xmluxseSort-names  | head -n$var | tail -n1 > /tmp/xmluxseSort-nameVar

		selectedName="$(cat /tmp/xmluxseSort-nameVar)"

		#read -p "
		#testing 96
#
#		selectedName = $selectedName
#
#		" EnterNull

	#	grep -n "^$selectedName$" /tmp/xmluxse-nameVar | cut -d: -f1,1 | head -n$var | tail -n1 > /tmp/xmluxseSort-nLineIDVar
	## Ok li ordina bene
## | head -n$var | tail -n1 servono solo se ci sono titoli uguali, ma non devono esserci titoli uguali.

		grep -n "^$selectedName$" /tmp/xmluxse-nameVarClean | cut -d: -f1,1 > /tmp/xmluxseSort-nLineIDVar
	
		nLineIDVar=$(cat /tmp/xmluxseSort-nLineIDVar)

		sed -n ''$nLineIDVar'p' /tmp/xmluxsev-blockToViewScelto | awk '$1 > 0 {print $1}' >> /tmp/xmluxseSort-sortingIDs
#	read -p "
#	testing 102
#
#	nLineIDVar = $nLineIDVar
#	
#	cat /tmp/xmluxseSort-sortingIDs
#	$(cat /tmp/xmluxseSort-sortingIDs)" EnterNull
		
	done

}

sortd () {

	cat /tmp/xmluxseSort-actionSortID-dResp  | cut -d= -f2,2 > /tmp/xmluxseSort-IDValue

	IDmain="$(cat /tmp/xmluxseSort-IDValue)"

	/usr/local/bin/xmluxv -in -s --f=$targetFile

	cat /tmp/xmluxev-blockToView | sed '/<!--/d' | sed '/-->/d' > /tmp/xmluxsev-blockToViewSed
#	read -p "testing 117" EnterNull

	## il titolo principale del file non devo ordinarlo ovviamente
	vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxsev-blockToViewSed

	awk '{ nlines++;  print nlines }' /tmp/xmluxsev-blockToViewSed | tail -n1 > /tmp/xmluxsev-blockToViewSedToFreq

	nLines=$(cat /tmp/xmluxsev-blockToViewSedToFreq)


	sed 's/[^.]//g' /tmp/xmluxseSort-IDValue | awk '{ print length }' > /tmp/xmluxe-dotFrequency
#	read -p "testing 128" EnterNull

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	declare -i var=0

	for a in `seq $nLines`

	do

		var=var+1

	cat /tmp/xmluxsev-blockToViewSed | head -n$var | tail -n1 | awk '$1 > 0 {print $1}' > /tmp/xmluxse-IDFrequencyCheck

	sed 's/[^.]//g' /tmp/xmluxse-IDFrequencyCheck  | awk '{ print length }' > /tmp/xmluxe-dotFrequencyVar
#	read -p "testing 143" EnterNull

	dotFreqVar=$(cat /tmp/xmluxe-dotFrequencyVar)

	if test $dotFreqVar -eq $leggoDotFrequency

	then
		sed -n ''$var'p' /tmp/xmluxsev-blockToViewSed >> /tmp/xmluxsev-blockToViewScelto
#	read -p "testing 151" EnterNull

	fi

done

     	touch /tmp/xmluxseSort-sortingIDs

	awk '{ nlines++;  print nlines }' /tmp/xmluxsev-blockToViewScelto | tail -n1 > /tmp/xmluxseSort-namesLines

	nNamesLines=$(cat /tmp/xmluxseSort-namesLines)

	declare -i var=0

	for a in `seq $nNamesLines`

	do
		var=var+1

		cat /tmp/xmluxsev-blockToViewScelto | head -n$var | tail -n1 | awk '{for(i=2;i<=NF;i++) print " " $i}' | tr -d '\n' | sed 's/^.//g' >> /tmp/xmluxse-nameVar00
		echo "" >> /tmp/xmluxse-nameVar00


	done

	sed '/^$/d' /tmp/xmluxse-nameVar00 > /tmp/xmluxse-nameVar

	#read -p "
	#testing 207
	#cat /tmp/xmluxse-nameVar
	#" EnterNull

	cat /tmp/xmluxse-nameVar | sed 's/.* "//g' | sed 's/"//g' > /tmp/xmluxse-nameVarClean

	cat /tmp/xmluxse-nameVarClean | sort -r > /tmp/xmluxseReverseSort-names

	declare -i var=0

	for a in `seq $nNamesLines`

	do
		var=var+1

		
		cat /tmp/xmluxseReverseSort-names  | head -n$var | tail -n1 > /tmp/xmluxseReverseSort-nameVar


		selectedName="$(cat /tmp/xmluxseReverseSort-nameVar)"

		#read -p "
		#testing 211
		#selectedName = $selectedName
		#" EnterNull

#		nNamesLinesPlus=$(($nNamesLines + 1))

#		decremento=$(($nNamesLinesPlus - $var))

#		grep -n "^$selectedName$" /tmp/xmluxse-nameVar | cut -d: -f1,1 | head -n$decremento | tail -n1 > /tmp/xmluxseSort-nLineIDVar
	
#		nLineIDVar=$(cat /tmp/xmluxseSort-nLineIDVar)

## Ok li ordina bene
## decremento e nTtilesLinesPlus serve solo se ci sono titoli uguali, ma non devono esserci titoli uguali.
#	read -p "testing 183
	
#nNamesLines = $nNamesLines

#var = $var

#decremento=$(($nNamesLines - $var))

#nLineIDVar = $(cat /tmp/xmluxseSort-nLineIDVar)

#	" EnterNull

grep -n "^$selectedName$" /tmp/xmluxse-nameVarClean | cut -d: -f1,1  > /tmp/xmluxseSort-nLineIDVar
	
		nLineIDVar=$(cat /tmp/xmluxseSort-nLineIDVar)

sed -n ''$nLineIDVar'p' /tmp/xmluxsev-blockToViewScelto | awk '$1 > 0 {print $1}' >> /tmp/xmluxseSort-sortingIDs

#read -p "
#testing 260
#
#nLineIDVar = $nLineIDVar
#
#cat /tmp/xmluxseSort-sortingIDs
#$(cat /tmp/xmluxseSort-sortingIDs)
#" EnterNull

# ok, gli ID sono ordinati in base all'ordine discendente dei titoli.

	done


}


sortMain () {

for a in {1}

do

grep "sort" /tmp/xmluxePseudoOptions/* > /tmp/xmluxseSort-actionSortID

stat --format %s /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortIDBytes

leggoBytesActionSortID=$(cat /tmp/xmluxseSort-actionSortIDBytes)

## I if
if test $leggoBytesActionSortID -gt 0

then

	for b in {1}

	do

grep "sort-a" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-aResp

stat --format %s /tmp/xmluxseSort-actionSortID-aResp > /tmp/xmluxseSort-actionSortID-aBytes

sortIdABytes=$(cat /tmp/xmluxseSort-actionSortID-aBytes) 

if test $sortIdABytes -gt 0

then
	echo "cimice ascending" > /tmp/xmluxseSort-cimiceAscendingIDa
	sorta

	break
fi

grep "sort-d" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-dResp

stat --format %s /tmp/xmluxseSort-actionSortID-dResp > /tmp/xmluxseSort-actionSortID-dBytes

sortIdDBytes=$(cat /tmp/xmluxseSort-actionSortID-dBytes) 

if test $sortIdDBytes -gt 0
then

	echo "cimice descending" > /tmp/xmluxseSort-cimiceDescendingIDd
	sortd
break

fi


done

fi

done

}

sortMain

moving () {

nNamesLines=$(cat /tmp/xmluxseSort-namesLines)

nNamesLinesPlus=$(echo $nNamesLines + 1 | bc)


## Devo iniziare da sotto	
declare -i var=$nNamesLinesPlus

## modifica 21 settembre 2024 seq nNamesLinesPlus -> nNamesLines
	for b in `seq $nNamesLines`

	do

var=var-1


cat /tmp/xmluxseSort-sortingIDs | head -n$var | tail -n1 > /tmp/xmluxseSort-IdToMove

leggoIdToMove="$(cat /tmp/xmluxseSort-IdToMove)"

#read -p "
#testing 299
#leggoIdToMove = $leggoIdToMove
#" EnterNull

cat /tmp/xmluxseSort-IdToMove | cut -d. -f1,1 > /tmp/xmluxse-freqIGradus

leggoIGradus="$(cat /tmp/xmluxse-freqIGradus)"

grep "$leggoIGradus" /tmp/xmluxseSort-sortingIDs > /tmp/xmluxse-IGradusFrequency0

awk '{ nlines++;  print nlines }' /tmp/xmluxse-IGradusFrequency0 | tail -n1 > /tmp/xmluxse-IGradusFrequency

nLinesIGradus=$(cat /tmp/xmluxse-IGradusFrequency)

#read -p "
#testing 315
#leggoIdToMove = $leggoIdToMove
#" EnterNull

if test $nLinesIGradus -eq 1

then

if ! test $leggoDotFrequency -eq 0

then

	echo "skip, nulla da ordinare perché l'elemento è unico" > /dev/null

else

# Devo ordinare anche i gradusI, molto utile ordinarli, pensa all'esempio <contatti> dove i gradusI sono
# i nomi e cognomi.
	echo "$leggoIdToMove" >> /tmp/xmluxse-idsToShift

	/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byName-gradusI.sh

	exit

fi

else

      echo "$leggoIdToMove" >> /tmp/xmluxse-idsToShift


fi

done
## Prima devo spostare di un'unità in più l'ID selezionato, alla fine ripeto il ciclo
## per spostarli tutti di un'unità in meno. In tal modo evito sovrapposizioni. e.g.
## Se l'ultimo ID è diventato il a01.02 (su quattro ID) allora non posso spostare
## a01.02 in a01.03 perché sovrapporrebbe l'esistente a01.03.
	## Prima devo spostare a01.02 in a01.(02+04) [+ il totale degli ID per mettermi in sicurezza,
	## in tale modo evito qualsiasi sovrapposizione]. 
	## Poi aggiungere la differenza tra la posizione iniziale e l'ultima, per effettuare lo spostamento
	## vero e proprio. 
	## Poi spostare tutti di 4 unità in meno per ripristinare.

sed -r '/^\s*$/d' /tmp/xmluxse-idsToShift > /tmp/xmluxse-idsToShift01

#	read -p "testing 341" EnterNull

awk '{ nlines++;  print nlines }' /tmp/xmluxse-idsToShift01 | tail -n1 > /tmp/xmluxse-nLinesToShift

nLinesToShift=$(cat /tmp/xmluxse-nLinesToShift)

nLinesToShiftPlus=$(echo $nLinesToShift + 1 | bc)

mkdir /tmp/xmluxse-IGradusContainer

declare -i var=$nLinesToShiftPlus

	for c in `seq $nLinesToShift`

	do

var=var-1

cat /tmp/xmluxse-idsToShift01 | head -n$var | tail -n1 > /tmp/xmluxseSort-IdToOrder

cat /tmp/xmluxseSort-IdToOrder | cut -d. -f1,1 > /tmp/xmluxse-Igradus

leggoIGradus="$(cat /tmp/xmluxse-Igradus)"

grep "^$leggoIGradus" /tmp/xmluxse-idsToShift01 > /tmp/xmluxse-frequencyIGradus

awk '{ nlines++;  print nlines }' /tmp/xmluxse-frequencyIGradus  | tail -n1 > /tmp/xmluxse-frequencyIGradusCount

frequIGradus=$(cat /tmp/xmluxse-frequencyIGradusCount)

leggoIdToOrder="$(cat /tmp/xmluxseSort-IdToOrder)"


nLinesToOrder=$frequIGradus

nLinesToOrderPlus=$(echo $nLinesToOrder + 1 | bc)

passMove=$(echo $nLinesToOrder + 1 | bc)


### è più veloce vim di xmluxe --move, xmluxe --move serve per altre necessità
#/usr/local/bin/xmluxe --move="$leggoIdToOrder" -a$passMove --f=$targetFile




if test $leggoDotFrequency -eq 0

then

leggoPre=$leggoIdRoot

cat /tmp/xmluxseSort-IdToOrder | sed 's/'$leggoIdRoot'0//' > /tmp/xmluxse-subIdToOrder

else

cat /tmp/xmluxseSort-IdToOrder | sed 's/\.[^\.]*$//' > /tmp/xmluxse-IDPreNew

leggoPre="$(cat /tmp/xmluxse-IDPreNew)"

cat /tmp/xmluxseSort-IdToOrder | sed 's/.*\.//' | sed '2p' > /tmp/xmluxse-subIdToOrder

fi

#read -p "testing 490
#leggoPre = $leggoPre
#" EnterNull


subIdToOrder=$(cat /tmp/xmluxse-subIdToOrder)

newSubId=$(echo $subIdToOrder + $passMove | bc)

if test $newSubId -lt 10

then

newSubIdL="0$newSubId"

else

newSubIdL="$newSubId"

fi

if test $leggoDotFrequency -eq 0

then

IDNew="$leggoPre$newSubIdL"

else

IDNew="$leggoPre.$newSubIdL"

fi

#read -p "testing 554
#IDNew = $IDNew
#" EnterNull

vim -c ":%s/$leggoIdToOrder/$IDNew/g" $targetFile.lmx -c :w -c :q

cat /tmp/xmluxseSort-IdToOrder | sed 's/.*\.//' | sed '2p' > /tmp/xmluxse-lastSubIdToOrder

#read -p "testing 413" EnterNull

lastSubIdToOrder=$(cat /tmp/xmluxse-lastSubIdToOrder)

subIdOrdered=$(echo $lastSubIdToOrder + $nLinesToOrderPlus | bc)

if test $subIdOrdered -lt 10

then
	subIdOrderedL="0$subIdOrdered"

else

subIdOrderedL=$subIdOrdered

fi

if test $leggoDotFrequency -eq 0

then

leggoPrefix=$leggoIdRoot

else

cat /tmp/xmluxseSort-IdToOrder | sed 's/\.[^\.]*$//' > /tmp/xmluxseSort-IdToOrderLessLastSubId

leggoPrefix="$(cat /tmp/xmluxseSort-IdToOrderLessLastSubId)"

fi


if test $leggoDotFrequency -eq 0

then

IDOrdered="$leggoPrefix$subIdOrderedL"

else

IDOrdered="$leggoPrefix.$subIdOrderedL"

fi

echo $IDOrdered >> /tmp/xmluxse-IGradusContainer/$leggoIGradus

#read -p "testing 599
#IDOrdered = $IDOrdered
#" EnterNull

done

mkdir /tmp/xmluxseSort-blocksBegin

mkdir /tmp/xmluxseSort-blocksEnd

## Devo trattatare gli id secondo la loro radice "IGradus". Non posso impostare i contatori
## raccogliendo e.g. sia gli id a01.01.01, sia a02.01.01. Devo invece separare gli a01.01.*
## dai a02.01.*
for d in $(ls /tmp/xmluxse-IGradusContainer)

do

	awk '{ nlines++;  print nlines }' /tmp/xmluxse-IGradusContainer/$d  | tail -n1 > /tmp/xmluxse-FinalFrequencyIGradusCount

	finalFreq=$(cat /tmp/xmluxse-FinalFrequencyIGradusCount)

rm -fr /tmp/xmluxse-finalContainer

mkdir /tmp/xmluxse-finalContainer

split -l1 /tmp/xmluxse-IGradusContainer/$d /tmp/xmluxse-finalContainer/

declare -i var=0

for e in $(ls /tmp/xmluxse-finalContainer)

do
	var=var+1

	leggoID=$(cat /tmp/xmluxse-finalContainer/$e)

#	read -p "
#	testing 473
#	
#	leggoID = $leggoID
#	" EnterNull

if test $leggoDotFrequency -eq 0

then

cat /tmp/xmluxse-finalContainer/$e | sed 's/'$leggoIdRoot'0//' > /tmp/xmluxse-lastSubIdToDowngrade

else

cat /tmp/xmluxse-finalContainer/$e | sed 's/.*\.//' | sed '2p' > /tmp/xmluxse-lastSubIdToDowngrade

fi


lastSubIdToDowngrade=$(cat /tmp/xmluxse-lastSubIdToDowngrade)

passo=$(echo $lastSubIdToDowngrade - $var | bc)

if test $leggoDotFrequency -eq 0

then

leggoPre=$leggoIdRoot

else

cat /tmp/xmluxse-finalContainer/$e | sed 's/\.[^\.]*$//' > /tmp/xmluxse-IDPreNew

leggoPre="$(cat /tmp/xmluxse-IDPreNew)"

fi

newSubId=$(echo $lastSubIdToDowngrade - $passo | bc)

if test $newSubId -lt 10

then

newSubIdL="0$newSubId"

else

newSubIdL="$newSubId"

fi

if test $leggoDotFrequency -eq 0

then

IDNew="$leggoPre$newSubIdL"

else

IDNew="$leggoPre.$newSubIdL"

fi

#read -p "testing 698
#IDNew = $IDNew
#" EnterNull

vim -c ":%s/$leggoID/$IDNew/g" $targetFile.lmx -c :w -c :q

## Non posso usare xmluxe --move... -b per spostamenti da id a cifra finale maggiore
## di 7, perché i livelli ricorsivi sono massimo 7. Quindi uso vim.
#/usr/local/bin/xmluxe --move="$leggoID" -b$passo --f=$targetFile

#### Ok gli id sono stati ordinati, ora rimane solo la sistemazione "fisica" dei blocchi.
lastSubId=$(echo $lastSubIdToDowngrade - $passo | bc)

if test $leggoDotFrequency -eq 0

then

leggoPre=$leggoIdRoot

cat /tmp/xmluxse-finalContainer/$e | sed 's/'$leggoIdRoot'0//' > /tmp/xmluxseSort-IdSortedLastSubId

else

cat /tmp/xmluxse-finalContainer/$e | sed 's/\.[^\.]*$//' > /tmp/xmluxseSort-IdSortedLessLastSubId

leggoPre="$(cat /tmp/xmluxseSort-IdSortedLessLastSubId)"

cat /tmp/xmluxse-finalContainer/$e | sed 's/.*\.//' | sed '2p' > /tmp/xmluxseSort-IdSortedLastSubId

fi

subIdSorted=$(cat /tmp/xmluxseSort-IdSortedLastSubId)

subIdSortedDownGraded=$(echo $subIdSorted - $passo | bc)


if test $subIdSortedDownGraded -lt 10

then

newSubIdSortedDownGraded="0$subIdSortedDownGraded"

else

newSubIdSortedDownGraded="$subIdSortedDownGraded"

fi

if test $leggoDotFrequency -eq 0

then

newID=$leggoPre$newSubIdSortedDownGraded

else

newID=$leggoPre.$newSubIdSortedDownGraded

fi

#read -p "testing 733
#newID = $newID
#" EnterNull

echo $newID | cut -d. -f1,1 > /tmp/xmluxse-finalIgradus

leggoIGradus="$(cat /tmp/xmluxse-finalIgradus)"

echo $leggoIGradus >> /tmp/xmluxseSort-IgradusList0

cat /tmp/xmluxseSort-IgradusList0 | sort | uniq > /tmp/xmluxseSort-IgradusList

grep -n "\"$newID\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxseSort-blocksBegin/$var-$newID-$leggoIGradus

grep -n "<!-- end $newID -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxseSort-blocksEnd/$var-$newID-$leggoIGradus

#read -p "
#testing 538 
#newID = $newID
#" EnterNull

done

done

}

moving

### ascending
translateA () {

mkdir /tmp/xmluxseSort-IgradusSplit

split -l1 /tmp/xmluxseSort-IgradusList /tmp/xmluxseSort-IgradusSplit/

for f in $(ls /tmp/xmluxseSort-IgradusSplit)

do
	leggoF="$(cat /tmp/xmluxseSort-IgradusSplit/$f)"
	
	find /tmp/xmluxseSort-blocksBegin/ -name "*$leggoF" > /tmp/xmluxseSort-blocksBeginGradus

	rm -fr /tmp/xmluxseSort-blocksBeginGradusSplit

	mkdir /tmp/xmluxseSort-blocksBeginGradusSplit

	cat /tmp/xmluxseSort-blocksBeginGradus | sort > /tmp/xmluxseSort-blocksBeginGradusSort 

#read -p "testing 816
#cat /tmp/xmluxseSort-blocksBeginGradus | sort > /tmp/xmluxseSort-blocksBeginGradusSort
#" EnterNull

	split -l1 /tmp/xmluxseSort-blocksBeginGradusSort /tmp/xmluxseSort-blocksBeginGradusSplit/

	for g in $(ls /tmp/xmluxseSort-blocksBeginGradusSplit)

	do
		leggoG="$(cat /tmp/xmluxseSort-blocksBeginGradusSplit/$g)"

		echo $leggoG | sed 's/.*.\///' | sed 's/-/ /g' | awk '$1 > 0 {print $2}' > /tmp/xmluxse-translateID

leggoTranslateID="$(cat /tmp/xmluxse-translateID)"

if test $leggoDotFrequency -eq 0

then

cat /tmp/xmluxse-translateID | sed 's/'$leggoIdRoot'0//' > /tmp/xmluxse-translateIDSubId

else
	
cat /tmp/xmluxse-translateID | sed 's/.*\.//' | sed '2p' > /tmp/xmluxse-translateIDSubId

fi

subIdTranslate=$(cat /tmp/xmluxse-translateIDSubId)

#### !!! No eseguire il classico metodo per  anteporre o meno lo zero
## perché per i gradi con il punto, quindi quelli interni a gradusI, sfaserebbe tutto.
# per i gradi gradusI dovrò necessariamente invocare il test per leggoDotFrequency
#
if test $leggoDotFrequency -eq 0

then

if test $subIdTranslate -lt 10

then

subIdTranslateL="0$subIdTranslate"

else

subIdTranslateL="$subIdTranslate"

fi

else

subIdTranslateL=$subIdTranslate

fi

if test $leggoDotFrequency -eq 0

then

leggoPre=$leggoIdRoot

translateIDL=$leggoPre$subIdTranslateL

else

cat /tmp/xmluxse-translateID | sed 's/\.[^\.]*$//' > /tmp/xmluxse-translateIDPre

leggoPre="$(cat /tmp/xmluxse-translateIDPre)"

translateIDL="$leggoPre.$subIdTranslateL"

fi

#read -p "testing 871
#translateIDL = $translateIDL
#" EnterNull

grep -n "ID=\"$translateIDL\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDBegin

lineBegin=$(cat /tmp/xmluxse-translateIDBegin)

#read -p "testing 893
#lineBegin = $lineBegin
#" EnterNull

grep -n "<!-- end $translateIDL -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDEnd

lineEnd=$(cat /tmp/xmluxse-translateIDEnd)

#read -p "testing 901
#lineEnd = $lineEnd
#" EnterNull

previousSubIdTranslate=$(echo $subIdTranslate - 1 | bc)

if test $previousSubIdTranslate -lt 10

then

previousSubIdTranslateL="0$previousSubIdTranslate"

else

previousSubIdTranslateL="$previousSubIdTranslate"

fi

if test $leggoDotFrequency -eq 0

then

previousID=$leggoPre$previousSubIdTranslateL

else

previousID="$leggoPre.$previousSubIdTranslateL"

fi

#read -p "testing 931
#previousID = $previousID
#" EnterNull

grep -n "<!-- end $previousID -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDEndPrevious

stat --format %s /tmp/xmluxse-translateIDEndPrevious > /tmp/xmluxse-translateIDEndPreviousBytes

previousEndBytes=$(cat /tmp/xmluxse-translateIDEndPreviousBytes)

if test $previousEndBytes -gt 0

then

lineEndPrevious=$(cat /tmp/xmluxse-translateIDEndPrevious)

#read -p "testing 947
#lineEndPrevious = $lineEndPrevious
#" EnterNull


grep -n "ID=\"$previousID\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDBeginPrevious

lineBeginPrevious=$(cat /tmp/xmluxse-translateIDBeginPrevious)

#read -p "testing 956
#lineBeginPrevious = $lineBeginPrevious
#" EnterNull

if test $lineBegin -lt $lineEndPrevious

then

	sed -n '1,'$lineEndPrevious'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco01

#read -p "testing 966
#vim /tmp/xmluxse-translate-blocco01
#" EnterNull

sed ''$lineBegin','$lineEnd'd' /tmp/xmluxse-translate-blocco01 > /tmp/xmluxse-translate-blocco01New

echo "" >> /tmp/xmluxse-translate-blocco01New
#read -p "testing 661
#vim /tmp/xmluxse-translate-blocco01New
#" EnterNull


sed -n ''$lineBegin','$lineEnd'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco02

#read -p "testing 979
#vim /tmp/xmluxse-translate-blocco02
#" EnterNull	

cat /tmp/xmluxse-translate-blocco01New /tmp/xmluxse-translate-blocco02 > /tmp/xmluxse-translate-blocco03
       
	sed -n ''$lineEndPrevious',$p' $targetFile.lmx > /tmp/xmluxse-translate-blocco04

	vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxse-translate-blocco04

	cat /tmp/xmluxse-translate-blocco03 /tmp/xmluxse-translate-blocco04 > $targetFile.lmx

fi

fi

	done

done

}

### descending
translateD () {

mkdir /tmp/xmluxseSort-IgradusSplit

split -l1 /tmp/xmluxseSort-IgradusList /tmp/xmluxseSort-IgradusSplit/

for f in $(ls /tmp/xmluxseSort-IgradusSplit)

do
	leggoF="$(cat /tmp/xmluxseSort-IgradusSplit/$f)"
	
	find /tmp/xmluxseSort-blocksBegin/ -name "*$leggoF" > /tmp/xmluxseSort-blocksBeginGradus

	rm -fr /tmp/xmluxseSort-blocksBeginGradusSplit

	mkdir /tmp/xmluxseSort-blocksBeginGradusSplit

	cat /tmp/xmluxseSort-blocksBeginGradus | sort -r > /tmp/xmluxseSort-blocksBeginGradusSortReverse
	
	split -l1 /tmp/xmluxseSort-blocksBeginGradusSortReverse /tmp/xmluxseSort-blocksBeginGradusSplit/

	for g in $(ls /tmp/xmluxseSort-blocksBeginGradusSplit)

	do
		leggoG="$(cat /tmp/xmluxseSort-blocksBeginGradusSplit/$g)"

		echo $leggoG | sed 's/.*.\///' | sed 's/-/ /g' | awk '$1 > 0 {print $2}' > /tmp/xmluxse-translateID

leggoTranslateID="$(cat /tmp/xmluxse-translateID)"

#read -p "
#testing 705
#leggoTranslateID = $leggoTranslateID
#" EnterNull


cat /tmp/xmluxse-translateID | sed 's/.*\.//' | sed '2p' > /tmp/xmluxse-translateIDSubId

subIdTranslate=$(cat /tmp/xmluxse-translateIDSubId)

#if test $subIdTranslate -lt 10

#then

#subIdTranslateL="0$subIdTranslate"

#else

#subIdTranslateL="$subIdTranslate"

#fi

cat /tmp/xmluxse-translateID | sed 's/\.[^\.]*$//' > /tmp/xmluxse-translateIDPre

leggoPre="$(cat /tmp/xmluxse-translateIDPre)"

#translateIDL="$leggoPre.$subIdTranslateL"

translateIDL="$leggoPre.$subIdTranslate"

#read -p "
#testing 738
#translateIDL = $translateIDL
#" EnterNull

grep -n "ID=\"$translateIDL\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDBegin

lineBegin=$(cat /tmp/xmluxse-translateIDBegin)

grep -n "<!-- end $translateIDL -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDEnd

lineEnd=$(cat /tmp/xmluxse-translateIDEnd)

previousSubIdTranslate=$(echo $subIdTranslate - 1 | bc)

if test $previousSubIdTranslate -lt 10

then

previousSubIdTranslateL="0$previousSubIdTranslate"

else

previousSubIdTranslateL="$previousSubIdTranslate"

fi

previousID="$leggoPre.$previousSubIdTranslateL"

grep -n "<!-- end $previousID -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDEndPrevious

stat --format %s /tmp/xmluxse-translateIDEndPrevious > /tmp/xmluxse-translateIDEndPreviousBytes

previousEndBytes=$(cat /tmp/xmluxse-translateIDEndPreviousBytes)

if test $previousEndBytes -gt 0

then

lineEndPrevious=$(cat /tmp/xmluxse-translateIDEndPrevious)

grep -n "ID=\"$previousID\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDBeginPrevious

lineBeginPrevious=$(cat /tmp/xmluxse-translateIDBeginPrevious)

if test $lineBegin -gt $lineEndPrevious

then

	sed -n '1,'$lineBeginPrevious'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco01

#	read -p "
#	testing 780
#
#/tmp/xmluxse-translate-blocco01
#
#" EnterNull

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxse-translate-blocco01

	# modifica 2024.09.21

	#sed -n ''$lineBeginPrevious','$lineEndPrevious'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco02
		
	sed -n ''$lineBeginPrevious','$lineBegin'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco02

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxse-translate-blocco02

	## dovrei testarlo per capire se occorresse tale linea vuota finale, sicuramente per l'omonimo dopo <else> occorre,
	# ma non mi serve tanto uso la formattazione alla fine:
	# /usr/local/lib/xmlux/xmluxeScripts/format/addEmptyLinesAfterElementEnd.sh
	#echo "" >> /tmp/xmluxse-translate-blocco02

	# fine modifica 2024.09.21
#	read -p "
#	testing 789
#
#/tmp/xmluxse-translate-blocco02
#
#" EnterNull

	cat /tmp/xmluxse-translate-blocco01 /tmp/xmluxse-translate-blocco02 > /tmp/xmluxse-translate-blocco03

#	read -p "
#	testing 801
#
#/tmp/xmluxse-translate-blocco03
#
#" EnterNull

	sed -n ''$lineBegin',$p' $targetFile.lmx > /tmp/xmluxse-translate-blocco04

	cat /tmp/xmluxse-translate-blocco03 /tmp/xmluxse-translate-blocco04 > $targetFile.lmx
else

	sed -n '1,'$lineBegin'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco01

#	read -p "
#	testing 815
#
#/tmp/xmluxse-translate-blocco01
#
#" EnterNull

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxse-translate-blocco01

	sed -n ''$lineBeginPrevious','$lineEndPrevious'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco02
	
	#echo "" >> /tmp/xmluxse-translate-blocco02
#	read -p "
#	testing 826
#
#/tmp/xmluxse-translate-blocco02
#
#" EnterNull

	cat /tmp/xmluxse-translate-blocco01 /tmp/xmluxse-translate-blocco02 > /tmp/xmluxse-translate-blocco03

#	read -p "
#	testing 835
#
#/tmp/xmluxse-translate-blocco03
#
#" EnterNull

	sed -n ''$lineBegin',$p' $targetFile.lmx > /tmp/xmluxse-translate-blocco04
	
#	read -p "
#	testing 844
#
#/tmp/xmluxse-translate-blocco04
#
#" EnterNull

	grep -n "ID=\"$previousID\"" /tmp/xmluxse-translate-blocco04 | cut -d: -f1,1 > /tmp/xmluxse-translateIDBeginPreviousResiduo

	lineBeginPreviousResiduo=$(cat /tmp/xmluxse-translateIDBeginPreviousResiduo)

	grep -n "<!-- end $previousID -->" /tmp/xmluxse-translate-blocco04 | cut -d: -f1,1 > /tmp/xmluxse-translateIDEndPreviousResiduo

	lineEndPreviousResiduo=$(cat /tmp/xmluxse-translateIDEndPreviousResiduo)

	sed ''$lineBeginPreviousResiduo','$lineEndPreviousResiduo'd' /tmp/xmluxse-translate-blocco04 > /tmp/xmluxse-translate-blocco04New
	
#	read -p "
#	testing 861
#
#/tmp/xmluxse-translate-blocco04New
#
#" EnterNull

	cat /tmp/xmluxse-translate-blocco03 /tmp/xmluxse-translate-blocco04New > $targetFile.lmx

fi

fi

	done

done

}

if [ -f /tmp/xmluxseSort-cimiceAscendingIDa ]; then

translateA

else

translateD

fi

## formattazione
/usr/local/lib/xmlux/xmluxeScripts/format/addEmptyLinesAfterElementEnd.sh

/usr/local/lib/xmlux/xmluxeScripts/format/delMultipleEmptyLines.sh

rm -fr /tmp/xmluxse*


exit


