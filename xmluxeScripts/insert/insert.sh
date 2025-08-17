#!/bin/bash

rm -fr /tmp/InsXmluxe-ins*
rm -fr /tmp/xmluxse*

cp /tmp/xmluxeTargetFile /tmp/insXmluxe-TargetFile

targetFile="$(cat /tmp/insXmluxe-TargetFile)"


idToInsert="$(cat /tmp/insXmluxe-idToInsert)"


insertMain () {

for a in {1}

do

grep "^--ins" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxseSort-actionSortID

stat --format %s /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortIDBytes

leggoBytesActionSortID=$(cat /tmp/xmluxseSort-actionSortIDBytes)


## I if
if test $leggoBytesActionSortID -gt 0

then


	for b in {1}

	do

grep ":--ins=" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-aResp

stat --format %s /tmp/xmluxseSort-actionSortID-aResp > /tmp/xmluxseSort-actionSortID-aBytes

sortIdABytes=$(cat /tmp/xmluxseSort-actionSortID-aBytes) 

if test $sortIdABytes -gt 0

then
	echo "cimice insert only" > /tmp/xmluxseSort-cimiceOnlyInsert

	break
fi

grep ":--ins-a=" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-aResp

stat --format %s /tmp/xmluxseSort-actionSortID-aResp > /tmp/xmluxseSort-actionSortID-aBytes

sortIdABytes=$(cat /tmp/xmluxseSort-actionSortID-aBytes) 

if test $sortIdABytes -gt 0

then
	echo "cimice ascending through name attribute" > /tmp/xmluxseSort-cimiceAscendingIDa-name

	break
fi

grep ":--ins-at=" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-aResp

stat --format %s /tmp/xmluxseSort-actionSortID-aResp > /tmp/xmluxseSort-actionSortID-aBytes

sortIdABytes=$(cat /tmp/xmluxseSort-actionSortID-aBytes) 

if test $sortIdABytes -gt 0

then

	echo "cimice ascending through title" > /tmp/xmluxseSort-cimiceAscendingIDa-title

	break
fi


grep ":--ins-d=" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-dResp

stat --format %s /tmp/xmluxseSort-actionSortID-dResp > /tmp/xmluxseSort-actionSortID-dBytes

sortIdDBytes=$(cat /tmp/xmluxseSort-actionSortID-dBytes) 

if test $sortIdDBytes -gt 0
then

	echo "cimice descending through name attribute" > /tmp/xmluxseSort-cimiceDescendingIDd-name
break

fi

grep ":--ins-dt=" /tmp/xmluxseSort-actionSortID > /tmp/xmluxseSort-actionSortID-dResp

stat --format %s /tmp/xmluxseSort-actionSortID-dResp > /tmp/xmluxseSort-actionSortID-dBytes

sortIdDBytes=$(cat /tmp/xmluxseSort-actionSortID-dBytes) 

if test $sortIdDBytes -gt 0
then

	echo "cimice descending through title attribute" > /tmp/xmluxseSort-cimiceDescendingIDd-title
break

fi

done

fi

done

}

insertMain

/usr/local/bin/xmluxv -ie -s --f=$targetFile

## Pulisco dai commenti
cat /tmp/xmluxev-blockToView | sed '/<!--/d' | sed '/-->/d' > /tmp/xmluxsev-blockToViewSed

## il titolo principale del file non devo ordinarlo ovviamente
#vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxsev-blockToViewSed

cat /tmp/xmluxsev-blockToViewSed | awk '$1 > 0 {print $1}' > /tmp/insXmluxe-IDColumn

grep -n "^$idToInsert$" /tmp/insXmluxe-IDColumn | cut -d: -f1,1 > /tmp/insXmluxe-IDnLine

idNLine=$(cat /tmp/insXmluxe-IDnLine)

sed -n ''$idNLine'p' /tmp/xmluxsev-blockToViewSed | awk '$1 > 0 {print $2}' > /tmp/insXmluxe-elementToInsert

element="$(cat /tmp/insXmluxe-elementToInsert)"

## Seleziono il grado I

cat /tmp/insXmluxe-idToInsert | cut -d. -f1,1 > /tmp/insXmluxe-insGradusI

## leggoGradusI serve a selezionare la famiglia, e.g.
## se volessi inserire in un data-seven il gradusIII a01.01.04 e non a02.01.04, mi occorre selezionare
## <a01> proprio con leggoGradusI.
leggoGradusI="$(cat /tmp/insXmluxe-insGradusI)"

sed 's/[^.]//g' /tmp/insXmluxe-idToInsert | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)


	for DotFrequency in {1}

	do

	if test $leggoDotFrequency -eq 0

	then

		touch /tmp/xmluxe-cimiceDotFrequencyZero

		for LASTid in {1}

		do

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché i category data, i pie data, i matter, i brief, hanno due elementi con ID senza <.>
	# senza considerate la radix ovviamente.
	# !!!! lo spazio tra $leggoGradusI e " è voluto, necessario.
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)


cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi

newID="$radix$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché i category data, i pie data, i matter, i brief, hanno due elementi con ID senza <.>
	# senza considerate la radix ovviamente.
	# !!!! lo spazio tra $leggoGradusI e " è voluto, necessario.
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi

newID="$radix$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché i category data, i pie data, i matter, i brief, hanno due elementi con ID senza <.>
	# senza considerate la radix ovviamente.
	# !!!! lo spazio tra $leggoGradusI e " è voluto, necessario.
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi

newID="$radix$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché i category data, i pie data, i matter, i brief, hanno due elementi con ID senza <.>
	# senza considerate la radix ovviamente.
	# !!!! lo spazio tra $leggoGradusI e " è voluto, necessario.
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi

newID="$radix$subIdL"

break

fi

## Non posso stabilire newID ora per i categoryDataset, lo farò dopo.
if [ -f /tmp/xmluxe-cimiceCategoryDataset01 ]; then

#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

touch /tmp/xmluxe-cimiceCategoryDataset01-series

grep " Series$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI=$(cat /tmp/insXmluxe-lastID)

#read -p "
#testing 279
#lastIDGradusI=\$(cat /tmp/insXmluxe-lastID)
#lastIDGradusI=$(cat /tmp/insXmluxe-lastID)
#" EnterNull

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

break

fi


## Non posso stabilire newID ora per i categoryDataset, lo farò dopo.
if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

touch /tmp/xmluxe-cimiceCategoryDataset02-series

grep " Series$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI=$(cat /tmp/insXmluxe-lastID)

#read -p "
#testing 279
#lastIDGradusI=\$(cat /tmp/insXmluxe-lastID)
#lastIDGradusI=$(cat /tmp/insXmluxe-lastID)
#" EnterNull

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

break

fi

if [ -f /tmp/xmluxe-cimicePieDataset ]; then
	
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

### per pie dataset, non devo individuare la famiglia con grep "^$leggoGradusI", quando la frequenza dei <.> è zero.
grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi

newID="$radix$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusI$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

## Individuare il newID
# lo stesso metodo che avrai per le categoryDataset ...
# if [ -f /tmp/xmluxe-cimiceDotFrequencyZero ]; then

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi

newID="$radix$subIdL"

break

fi

done

break
	fi



	if test $leggoDotFrequency -eq 1

	then

		for LASTid in {1}

		do

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

## Non posso ricavare ora i newID per i categoryDataset, lo farò dopo
if [ -f /tmp/xmluxe-cimiceCategoryDataset01 ]; then

#grep "Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" > /tmp/insXmluxe-IDs

grep "Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv | awk '$1 > 0 {print $1}' > /tmp/insXmluxe-IDs

touch /tmp/xmluxe-cimiceCategoryDataset01-items

	### Per i category dataset02, devo inserire tanti Item quanti
	## sono già presenti nelle precedenti Series

#lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

#grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

#leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

break

fi


## Non posso ricavare ora i newID per i categoryDataset, lo farò dopo
if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

#grep "Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" > /tmp/insXmluxe-IDs

grep "Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv | awk '$1 > 0 {print $1}' > /tmp/insXmluxe-IDs

touch /tmp/xmluxe-cimiceCategoryDataset02-items

	### Per i category dataset02, devo inserire tanti Item quanti
	## sono già presenti nelle precedenti Series

#lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

#grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

#leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

break

fi

if [ -f /tmp/xmluxe-cimicePieDataset ]; then

## Ricavo l'elemento perché pie dataset ha sia la key che value con 1 <.>.

#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusII$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

done

break
	fi

	
	if test $leggoDotFrequency -eq 2

	then

		for LASTid in {1}

		do

			## Per i category dataset document class, e piedataset document class---Non
		        ## ho ancora permesso di inserire Value, Key singolarmente; possono essere inseriti solo
			## attraverso l'inserimento di Series e Item.
			## Lascio il ciclo lastID, nel caso in futuro volessi usare --ins anche per altre document class
			## oltre a data-seven.

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusIII$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

done

break
	fi


	if test $leggoDotFrequency -eq 3

	then

		for LASTid in {1}

		do

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusIV$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusIV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusIV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

	break

fi

done

break
	fi


	if test $leggoDotFrequency -eq 4

	then

		for LASTid in {1}

		do

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusV$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusV="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusV -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"
	
	break
fi

done

break

	fi


	if test $leggoDotFrequency -eq 5

	then

		for LASTid in {1}

		do

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusVI$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVI="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVI -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

	break

fi

done

break
	fi

	if test $leggoDotFrequency -eq 6

	then

		for LASTid in {1}

		do

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi

if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

	## devo ricavare l'elemento perché ai brief e matter, puoi cambiare il nome degli elementi
#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

grep " $element$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

break

fi


if [ -f /tmp/xmluxe-cimiceData-seven ]; then

grep "gradusVII$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" | tail -n1 > /tmp/insXmluxe-lastID

lastIDGradusVII="$(cat /tmp/insXmluxe-lastID)"

grep -n "<!-- end $lastIDGradusVII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-nLineLastIdGradus

leggoLastIdGradusLine=$(cat /tmp/insXmluxe-nLineLastIdGradus)

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

	break

fi

done

break
	fi
done

## Per gli Items delle category dataset01 il discorso è differente,
# ma il metodo per ricavare  $newID è uguale sia per  category dataset01 che per category dataset02
if [ -f /tmp/xmluxe-cimiceCategoryDataset01 ]; then

## I if A
if [ ! -f /tmp/xmluxe-cimiceCategoryDataset01-items ]; then

## I if sub A
if [ -f /tmp/xmluxe-cimiceDotFrequencyZero ]; then

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi


newID="$radix$subIdL"

#read -p "
#testing 1074
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

else

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

## I fi sub A
		fi

		## I fi A
fi

fi


## Per gli Items delle category dataset02 il discorso è differente
if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

## I if A
if [ ! -f /tmp/xmluxe-cimiceCategoryDataset02-items ]; then

## I if sub A
if [ -f /tmp/xmluxe-cimiceDotFrequencyZero ]; then

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

## I if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

## I fi sub sub A
fi


newID="$radix$subIdL"

#read -p "
#testing 1074
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

else

cat /tmp/insXmluxe-lastID | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-lastIDPrefix

#read -p "
#testing 1163
#cat /tmp/insXmluxe-lastID = $(cat /tmp/insXmluxe-lastID)
#" EnterNull

prefix="$(cat /tmp/insXmluxe-lastIDPrefix)"

cat /tmp/insXmluxe-lastID | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

subId=$(echo $lastSubId + 1 | bc)


### II if sub sub A
if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

### II if sub sub A
fi


newID="$prefix.$subIdL"

## I fi sub A
		fi

		## I fi A
fi

fi

echo "$newID" > /tmp/insXmluxe-newID

for documentClass in {1}

do

	############### metodo alternativo, a quello più veloce e migliore perché posso
	#### inserire anche il contenuto interattivamente
#### Brief Article
#if [ -f /tmp/xmluxe-cimiceBrief-article ]; then
#
#	sed 's/[^.]//g' /tmp/insXmluxe-newID | awk '{ print length }' > /tmp/xmluxe-dotFrequency
#
#	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)
#
#	for frequency in {1}
#
#	do
#
#	if test $leggoDotFrequency -eq 0
#
#	then
#echo ""
#echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertSection.java
#
#section=$(cat /tmp/xmluxe-insertSection)
#
#### $element = section
#			echo "
#<$element ID=\"$newID\">$section
#
#</$element>
#<!-- end $newID -->" > /tmp/insXmluxe-toInject
#
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#
#vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione
#
#
#cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione
#
#cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx
#
#break
#
#fi
#
#done
#
#break
#
#fi
#
#
#### Brief Book
#if [ -f /tmp/xmluxe-cimiceBrief-book ]; then
#
#	sed 's/[^.]//g' /tmp/insXmluxe-newID | awk '{ print length }' > /tmp/xmluxe-dotFrequency
#
#	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)
#
#	for frequency in {1}
#
#	do
#
#	if test $leggoDotFrequency -eq 0
#
#	then
#echo ""
#echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertPart.java
#
#part=$(cat /tmp/xmluxe-insertPart)
#
### element = part
#			echo "
#<$element ID=\"$newID\">$part
#
#</$element>
#<!-- end $newID -->" > /tmp/insXmluxe-toInject
#
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#
#vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione
#
#
#cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione
#
#cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx
#
#break
#
#fi
#
#done
#
#break
#
#fi
#
#### Matter Article
#if [ -f /tmp/xmluxe-cimiceMatter-article ]; then
#
#	sed 's/[^.]//g' /tmp/insXmluxe-newID | awk '{ print length }' > /tmp/xmluxe-dotFrequency
#
#	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)
#
#		for frequency in {1}
#
#	do
#
#	if test $leggoDotFrequency -eq 0
#
#	then
#echo ""
#echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertSection.java
#
#section=$(cat /tmp/xmluxe-insertSection)
#
### element = section
#			echo "
#<$element ID=\"$newID\">$section
#
#</$element>
#<!-- end $newID -->" > /tmp/insXmluxe-toInject
#
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#
#vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione
#
#
#cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione
#
#cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx
#
#break
#
#fi
#
#done
#
#break
#
#fi
#
#
#### Matter Book
#if [ -f /tmp/xmluxe-cimiceMatter-book ]; then
#
#	sed 's/[^.]//g' /tmp/insXmluxe-newID | awk '{ print length }' > /tmp/xmluxe-dotFrequency
#
#	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)
#
#	for frequency in {1}
#
#	do
#
#	if test $leggoDotFrequency -eq 0
#
#	then
#echo ""
#echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertPart.java
#
#part=$(cat /tmp/xmluxe-insertPart)
#
### $element = part
#			echo "
#<$element ID=\"$newID\">$part
#
#</$element>
#<!-- end $newID -->" > /tmp/insXmluxe-toInject
#
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#
#vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione
#
#cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione
#
#cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx
#
#break
#
#fi
#
#done
#
#break
#
#fi

if [ -f /tmp/xmluxe-cimiceBrief-article ]; then

grep "^-name$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertName

stat --format %s /tmp/xmluxse-insertName > /tmp/xmluxse-insertNameBytes

leggoBytesOptionName=$(cat /tmp/xmluxse-insertNameBytes)

## I if
if test $leggoBytesOptionName -gt 0

then

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

name=$(cat /tmp/xmluxe-insertName)


grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

## I if
if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" name=\"$name\">$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

else

echo "
<$element ID=\"$newID\" name=\"$name\">

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


else

grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" >$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject


else

echo "
<$element ID=\"$newID\" >

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

#read -p "
#testing 1404
#
#sed -n '1,'\$leggoLastIdGradusLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#
#
#sed -n ''\$leggoLastIdGradusLine',\$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#
#" EnterNull


sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

fi

break

fi


if [ -f /tmp/xmluxe-cimiceBrief-book ]; then

grep "^-name$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertName

stat --format %s /tmp/xmluxse-insertName > /tmp/xmluxse-insertNameBytes

leggoBytesOptionName=$(cat /tmp/xmluxse-insertNameBytes)

## I if
if test $leggoBytesOptionName -gt 0

then

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

name=$(cat /tmp/xmluxe-insertName)


grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

## I if
if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" name=\"$name\">$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

else

echo "
<$element ID=\"$newID\" name=\"$name\">

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


else

grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" >$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject


else

echo "
<$element ID=\"$newID\" >

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

#read -p "
#testing 1404

#sed -n '1,'\$leggoLastIdGradusLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione


#sed -n ''\$leggoLastIdGradusLine',\$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#" EnterNull


sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

fi

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-article ]; then

grep "^-name$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertName

stat --format %s /tmp/xmluxse-insertName > /tmp/xmluxse-insertNameBytes

leggoBytesOptionName=$(cat /tmp/xmluxse-insertNameBytes)

## I if
if test $leggoBytesOptionName -gt 0

then

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

name=$(cat /tmp/xmluxe-insertName)


grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

## I if
if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" name=\"$name\">$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

else

echo "
<$element ID=\"$newID\" name=\"$name\">

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


else

grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" >$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject


else

echo "
<$element ID=\"$newID\" >

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

#read -p "
#testing 1404

#sed -n '1,'\$leggoLastIdGradusLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione


#sed -n ''\$leggoLastIdGradusLine',\$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#" EnterNull


sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

fi

break

fi


if [ -f /tmp/xmluxe-cimiceMatter-book ]; then

grep "^-name$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertName

stat --format %s /tmp/xmluxse-insertName > /tmp/xmluxse-insertNameBytes

leggoBytesOptionName=$(cat /tmp/xmluxse-insertNameBytes)

## I if
if test $leggoBytesOptionName -gt 0

then

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

name=$(cat /tmp/xmluxe-insertName)


grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

## I if
if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" name=\"$name\">$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

else

echo "
<$element ID=\"$newID\" name=\"$name\">

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


else

grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" >$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject


else

echo "
<$element ID=\"$newID\" >

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

fi

#read -p "
#testing 1404

#sed -n '1,'\$leggoLastIdGradusLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

#sed -n ''\$leggoLastIdGradusLine',\$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#" EnterNull


sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

fi

break

fi


if [ -f /tmp/xmluxe-cimiceCategoryDataset01 ]; then

	## Per i category dataset02 si possono inserire o Series (dotFrequency = 0)
	## o Items (dotFrequency = 1); non avrebbe senso inserire Keys o Values direttamente, ma
	## ha senso solo inserire Keys e Values all'interno di Series o Items.
	if [ -f /tmp/xmluxe-cimiceCategoryDataset01-series ]; then 	

	leggoDotFrequency=0

else

	leggoDotFrequency=1

	fi


	for frequency in {1}

	do

if test $leggoDotFrequency -eq 0

then

echo ""
echo ""

#grep "Series$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastSeries

lastID=$(cat /tmp/insXmluxe-lastID)

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

fi

newID="$radix$subIdL"

rm -fr newTempProject
## non posso creare direttamente newTempProject nella posizione corrente
## altrimenti avrei l'errore di impossibilità nel copiare una cartella all'interno
## di sé stessa.

mkdir /tmp/xmluxe-newTempProject

cp -r * /tmp/xmluxe-newTempProject

cp -r /tmp/xmluxe-newTempProject newTempProject

cd newTempProject

xmluxe --move=$lastID -a1 --f=$targetFile

grep -n "<Series ID=\"$newID\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-beginNewIDLine

beginNewIDLine=$(cat /tmp/insXmluxe-beginNewIDLine)

#read -p "
#testing 2068
#newID=\"\$radix\$subIdL\"
#newID=\"$radix$subIdL\"

#beginNewIDLine $beginNewIDLine

#" EnterNull


grep -n "<!-- end $newID -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endNewIDLine


endNewIDLine=$(cat /tmp/insXmluxe-endNewIDLine)

#read -p "
#endNewIDLine = $endNewIDLine
#testing 2128
#" EnterNull

#break

#fi

#done

cat $targetFile.lmx | sed -n ''$beginNewIDLine','$endNewIDLine'p' > /tmp/insXmluxe-newSeries

cd ..

## In questo modo eliminerei i "titoli" di ogni elemento
# e.g. 
# <Series ID="a04" name="limite superiore">limite superiore
# diventerebbe
# <Series ID="a04" name="limite superiore">
#
#cat /tmp/insXmluxe-newSeries | sed 's/>.*/>/g'



## In questo modo otterei i "titoli" e i valori di ogni elemento
# e.g.
# limite superiore
# gennaio
# 7
#
# maggio
# 7
#
#cat /tmp/insXmluxe-newSeries | sed 's/.*>//g' | sed -r '/^\s*$/d' > /tmp/insXmluxe-Series_Keys_Value


	grep "^<Series" /tmp/insXmluxe-newSeries > /tmp/insXmluxe-stringaSeriesResp

	cat /tmp/insXmluxe-stringaSeriesResp | sed 's/.*ID="//g' | sed 's/".*//g' > /tmp/insXmluxe-idSeries

idSeries=$(cat /tmp/insXmluxe-idSeries)

	cat /tmp/insXmluxe-stringaSeriesResp | sed 's/.*>//g' > /tmp/insXmluxe-pastSeries

pastSeries=$(cat /tmp/insXmluxe-pastSeries)

#cat /tmp/insXmluxe-newSeries | sed 's/>.*/>/g' | sed 's/name=".*>/name="">/g'
cat /tmp/insXmluxe-stringaSeriesResp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglio

dettaglio=$(cat /tmp/insXmluxe-stringaDettaglio)

mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"la Series\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglio\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Directory | echo pezzo4 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-insertSeries

series=$(cat /tmp/xmluxe-insertSeries)


####### Da terminale va bene, ma da script no perché sed non accetta $series aventi lo spazio.
###### con vim risolvo il problema.
#read -p "
#testing 2200
#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'\$leggoSost'$/name=\"'\$series'\">'\$series'/g' > /tmp/insXmluxe-newSeries-01
#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name=\"'$series'\">'$series'/g' > /tmp/insXmluxe-newSeries-01

#" EnterNull

#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name="'$series'">'$series'/g' > /tmp/insXmluxe-newSeries-01

#cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries

#######

vim -c "%s/<Series ID=\"$idSeries\" name.*>$pastSeries$/<Series ID=\"$idSeries\" name=\"$series\">$series/g" /tmp/insXmluxe-newSeries -c :w -c :q

#read -p "
#testing 2319
#Series aggiornata
#" EnterNull


### Aggiorno gli Item

rm -fr /tmp/insXmluxe-upgradeItems

mkdir /tmp/insXmluxe-upgradeItems

grep "^<Item ID" /tmp/insXmluxe-newSeries > /tmp/insXmluxe-allItemsToUpgrade

split -l1 /tmp/insXmluxe-allItemsToUpgrade /tmp/insXmluxe-upgradeItems/

for allItemsToUp in $(ls /tmp/insXmluxe-upgradeItems)

do
	leggoItemToUp=$(cat /tmp/insXmluxe-upgradeItems/$allItemsToUp)

cat /tmp/insXmluxe-upgradeItems/$allItemsToUp | sed 's/.*ID="//g' | sed 's/".*//g' > /tmp/insXmluxe-idItem

idItem=$(cat /tmp/insXmluxe-idItem)

pastSeries=$(cat /tmp/insXmluxe-pastSeries)

#cat /tmp/insXmluxe-newSeries | sed 's/>.*/>/g' | sed 's/name=".*>/name="">/g'
cat /tmp/insXmluxe-upgradeItems/$allItemsToUp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglio

dettaglio=$(cat /tmp/insXmluxe-stringaDettaglio)

mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"l Item\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglio\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Directory | echo pezzo4 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-insertSeries

item=$(cat /tmp/xmluxe-insertItem)

vim -c "%s/<Item ID=\"$idItem\" name.*>$pastItem/<Item ID=\"$idItem\" name=\"ITEM $item\">$item/g" /tmp/insXmluxe-newSeries -c :w -c :q


	grep "^<Key ID=\"$idItem.01\"" /tmp/insXmluxe-newSeries > /tmp/insXmluxe-stringaKeyResp

cat /tmp/insXmluxe-stringaKeyResp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglio

dettaglio=$(cat /tmp/insXmluxe-stringaDettaglio)

cat /tmp/insXmluxe-stringaKeyResp | sed 's/.*>//g' > /tmp/insXmluxe-pastKey

pastKey=$(cat /tmp/insXmluxe-pastKey)


mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"la Key\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglio\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Directory | echo pezzo4 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-insertKey

key=$(cat /tmp/xmluxe-insertKey)

#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name="KEY '$key'">'$key'/g' > /tmp/insXmluxe-newSeries-01

#cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries

vim -c "%s/<Key ID=\"$idItem.01\" name.*>$pastKey$/<Key ID=\"$idItem.01\" name=\"KEY $key\">$key<\/Key>/g" /tmp/insXmluxe-newSeries -c :w -c :q

## Aggiornamento dei valori per ogni Key

#cat /tmp/insXmluxe-stringaDettaglio | sed 's/.*ID="//g' | sed 's/".*//g' > /tmp/insXmluxe-idKey

#idKey=$(cat /tmp/insXmluxe-idKey)

grep "<Value ID=\"$idItem.02\" " /tmp/insXmluxe-newSeries > /tmp/insXmluxe-stringaValueResp

cat /tmp/insXmluxe-stringaValueResp | sed 's/.*>//g' > /tmp/insXmluxe-pastValue

pastValue=$(cat /tmp/insXmluxe-pastValue)

cat /tmp/insXmluxe-stringaValueResp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglioValue

dettaglioValue=$(cat /tmp/insXmluxe-stringaDettaglioValue)

costantiValues() {

if [ ! -f /tmp/xmlux-valuesCostExists ]; then

vim /usr/local/lib/xmlux/documentClasses/data/categoryDataset/costanti-vim.txt

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmlux-vimInputUNIVERSAL

silent ! touch /tmp/xmlux-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"il valore (Value)\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglioValue\"
let pezzo5 = \"appartenente a\"
let pezzo6 = \"Item ID=\\\"$idItem\\\"; Series '$series'\"

let pezzo7 = \"Se il valore fosse una\"
let pezzo8 = \"costante\"
let pezzo9 = \"per più Values, segui esso con la locuzione\"
let pezzo10 = \"cost\"

let pezzo11 = \"e.g.\"
let pezzo12 = \"100 cost\"


echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Number | echo pezzo4 | echohl None
echo pezzo5
echohl Directory | echo pezzo6 | echohl None
echo interlinea
echo pezzo7
echohl Special | echo pezzo8 | echohl None
echo pezzo9
echohl operator | echo pezzo10 | echohl None
echo interlinea
echo pezzo11
echohl Type | echo pezzo12 | echohl None
echo interlinea
" > /tmp/xmlux-universalInput-01

cat /tmp/xmlux-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmlux/UNIVERSAL.vim

touch /tmp/xmlux-ruffiano

vim -c ":runtime! vimScript/xmlux/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmlux-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmlux-value

value=$(cat /tmp/xmlux-value)


grep " cost" /tmp/xmlux-value > /tmp/xmlux-valueRespGrep

stat --format %s /tmp/xmlux-valueRespGrep > /tmp/xmlux-valueRespGrepBytes

bytesCostItems=$(cat /tmp/xmlux-valueRespGrepBytes)

## II if sub A
if test $bytesCostItems -gt 0

then

## non è un errore $varKey.

cat /tmp/xmlux-value | sed 's/ cost//g' > /tmp/xmlux-Value

value=$(cat /tmp/xmlux-Value)

	mkdir costanti 2> /dev/null

	cronoAggiornamento=$(date +"%Y-%m-%d-%H-%M-%S")
	
echo "varKey upgrade $cronoAggiornamento
value $(cat /tmp/xmlux-Value)
idKey $idKey
idValue $idValue
idItem $idItem
idSeries $idSeries" > costanti/$idSeries



echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxVim

echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxPublicVim

touch /tmp/xmlux-valuesCostExists

## <datalux-> non è un errore, è un file che serve a $ull/datalux/upData/
echo "$series: $value" >> /tmp/datalux-costantiToPrint

#read -p "
#testing 171
#creato 
#/tmp/xmlux-elements/valuesCostExists
#" EnterNull

else

#read -p "
#testing  179
#Valori di Keys senza costanti
#" EnterNull

## Se il valore non fosse stato espresso come costante, 
## senza allungare con condizionali che rasentano la ridondanza,
## non occorre nemmeno il condizionale di esistenza grazie ai break di prima.

#if [ ! -f /tmp/xmlux-elements/values/$varKey ]; then
echo $value > /tmp/xmlux-Value
#fi

value=$(cat /tmp/xmlux-value)


fi

else

	## scritto dalla precedente immessione di Value come costante
value=$(cat /tmp/xmlux-Value)

echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxVim

echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxPublicVim

fi

## idValue è successivo a idKey, e idKey ha come ultima cifra <01>.
## quindi:
idValue="$idItem.02"

nameValue="$value"

}

costantiValues


#
##cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name="VALUE '$value'">'$value'/g' > /tmp/insXmluxe-newSeries-01
#
##cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries
#
vim -c "%s/Value ID=\"$idItem.02\" name.*>$pastValue$/Value ID=\"$idItem.02\" name=\"VALUE $value\">$value<\/Value>/g" /tmp/insXmluxe-newSeries -c :w -c :q

done

#read -p "
#testing 2562
#Items, Keys, Value aggiornati
#" EnterNull

cat $targetFile.lmx | sed '/<\/CategoryDataset>/d' > /tmp/xmluxe-delChiusura

echo "Gdd
ZZ

"> /tmp/xmluxe-commandDelLastLine

vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-delChiusura

cp /tmp/xmluxe-delChiusura $targetFile.lmx

cat /tmp/insXmluxe-newSeries >> $targetFile.lmx

echo "</CategoryDataset>" >> $targetFile.lmx

#read -p "
#testing 2569
#concatenazione effettuata
#" EnterNull

rm -r newTempProject

break

fi



if test $leggoDotFrequency -eq 1

then

	### Per i category dataset02, devo inserire tanti Item quanti
	## sono già presenti nelle precedenti Series

	####### La Key va espressa prima del ciclo perché deve essere in comune
	###### con tutti gli Item, cambieranno solo i valori delle Key per ogni Item.
#echo ""
#echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertKey.java

mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"la Key\"
let pezzo3 = \"che avrà ogni Item per ogni relativa Series\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-key

key=$(cat /tmp/xmluxe-key)

rm -fr /tmp/insXmluxe-IDsItemsCateg02Split

mkdir /tmp/insXmluxe-IDsItemsCateg02Split
	
split -l1 /tmp/insXmluxe-IDs /tmp/insXmluxe-IDsItemsCateg02Split/

declare -i varEveryItem=0

## Devo leggere al contrario
for everyItem in $(ls /tmp/insXmluxe-IDsItemsCateg02Split/)

do

varEveryItem=varEveryItem+1

IDGradusII=$(cat /tmp/insXmluxe-IDsItemsCateg02Split/$everyItem)

cat /tmp/insXmluxe-IDsItemsCateg02Split/$everyItem | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-IDPrefix

prefix="$(cat /tmp/insXmluxe-IDPrefix)"

cat /tmp/insXmluxe-IDsItemsCateg02Split/$everyItem | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-SubId

SubId=$(cat /tmp/insXmluxe-SubId)

subId=$(echo $SubId + 1 | bc)

if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

fi

newIDTest="$prefix.$subIdL"

grep "^$newIDTest$" $targetFile-lmxv/kin/$targetFile-ids.lmxv > /tmp/insXmluxe-idExistence

stat --format %s /tmp/insXmluxe-idExistence > /tmp/insXmluxe-idExistenceBytes

leggoBytes=$(cat /tmp/insXmluxe-idExistenceBytes)

if ! test $leggoBytes -gt 0

then

newID="$prefix.$subIdL"

grep -n "<Item ID=\"$IDGradusII\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-beginAnteIDLine

beginAnteIDLine=$(cat /tmp/insXmluxe-beginAnteIDLine)

#read -p "
#testing 2209
#newID=\"\$prefix.\$subIdL\"
#newID=\"$prefix.$subIdL\"

#anteID=\"\$prefix.\$anteSubId\"
#anteID=\"$prefix.$anteSubId\"

#ID selezionato attuale:
#IDGradusII = $IDGradusII

#beginAnteIDLine = $beginAnteIDLine
#" EnterNull


grep -n "<!-- end $IDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endAnteIDLine

#read -p "
#grep -n \"<!-- end \$anteID -->\" \$targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endAnteIDLine
#grep -n \"<!-- end $anteID -->\" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endAnteIDLine
#testing 2128
#" EnterNull

endAnteIDLine=$(cat /tmp/insXmluxe-endAnteIDLine)

#break

#fi

#done

echo "$newID" > /tmp/insXmluxe-newID


mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"l Item\"
let pezzo3 = \"che avrà\"
let pezzo4 = \"ID=\\\"$newID\\\"\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Number | echo pezzo4 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-insertSeries

item=$(cat /tmp/xmluxe-insertItem)


cat $targetFile.lmx | sed -n ''$beginAnteIDLine','$endAnteIDLine'p' > /tmp/insXmluxe-innerItem

### La Key precedente <ante>
#grep "<Key" /tmp/insXmluxe-innerItem | sed 's/.*">//g' | sed 's/<.*//g' > /tmp/insXmluxe-key

#key=$(cat /tmp/insXmluxe-key)

#read -p "
#testing 2273
#key = $key
#" EnterNull

echo ""
echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertNameItem.java

#nameItem=$(cat /tmp/xmluxe-insertNameItem)


if [ -d costanti ]; then

	## $prefix corrisponde alla Series delle costanti
	grep "idSeries $prefix" -r costanti > /tmp/insXmluxe-respCostanti

stat --format %s /tmp/insXmluxe-respCostanti > /tmp/insXmluxe-respCostantiBytes

bytesCostanti=$(cat /tmp/insXmluxe-respCostantiBytes)

if test $bytesCostanti -gt 0

then

### Il Value precedente <ante>
grep "<Value" /tmp/insXmluxe-innerItem | sed 's/.*">//g' | sed 's/<.*//g' > /tmp/insXmluxe-value

value=$(cat /tmp/insXmluxe-value)

#read -p "
#testing 2247
#costante
#value = $value
#" EnterNull

else

echo ""
echo ""

#java /usr/local/lib/xmlux/java/xmluxe/insert/insertValue.java

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"il valore (Value)\"
let pezzo3 = \"della key\"
let pezzo4 = \"$key\"
let pezzo5 = \"del nuovo\"
let pezzo6 = \"<Item ID=\\\"$newID\\\" ...>$item\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Number | echo pezzo4 | echohl None
echo pezzo5
echohl Directory | echo pezzo6 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-value

value=$(cat /tmp/xmluxe-value)


fi

fi

echo "
<Item ID=\"$newID\" name=\"Item $newID\">$item

<Key ID=\"$newID.01\" name=\"KEY $newID.01\">$key</Key>
<!-- end $newID.01 -->

<Value ID=\"$newID.02\" name=\"VALUE $newID.02\">$value</Value>
<!-- end $newID.02 -->

</Item>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

#		read -p "
#testing 2196
	
#sed -n '1,'\$endAnteIDLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$endAnteIDLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

#sed -n ''\$endAnteIDLine',\$p' \$targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$endAnteIDLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#" EnterNull

sed -n '1,'$endAnteIDLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$endAnteIDLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#read -p "
#testing
#2212
#" EnterNull

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


fi

done

break

fi

done

break

fi

if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

	## Per i category dataset02 si possono inserire o Series (dotFrequency = 0)
	## o Items (dotFrequency = 1); non avrebbe senso inserire Keys o Values direttamente, ma
	## ha senso solo inserire Keys e Values all'interno di Series o Items.
	if [ -f /tmp/xmluxe-cimiceCategoryDataset02-series ]; then 	

	leggoDotFrequency=0

else

	leggoDotFrequency=1

	fi


	for frequency in {1}

	do

if test $leggoDotFrequency -eq 0

then

echo ""
echo ""

#grep "Series$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastSeries

lastID=$(cat /tmp/insXmluxe-lastID)

#read -p "
#testing 2916
#lastID = $lastID
#" EnterNull

cat /tmp/insXmluxe-lastID | sed 's/^.//g' > /tmp/insXmluxe-lastSubId

lastSubId=$(cat /tmp/insXmluxe-lastSubId)

cat /tmp/insXmluxe-lastID | sed 's/'$lastSubId'//g' > /tmp/insXmluxe-radix

radix=$(cat /tmp/insXmluxe-radix)

subId=$(echo $lastSubId + 1 | bc)

if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

fi

newID="$radix$subIdL"

rm -fr newTempProject
## non posso creare direttamente newTempProject nella posizione corrente
## altrimenti avrei l'errore di impossibilità nel copiare una cartella all'interno
## di sé stessa.

mkdir /tmp/xmluxe-newTempProject

cp -r * /tmp/xmluxe-newTempProject

cp -r /tmp/xmluxe-newTempProject newTempProject

cd newTempProject

xmluxe --move=$lastID -a1 --f=$targetFile

grep -n "<Series ID=\"$newID\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-beginNewIDLine

beginNewIDLine=$(cat /tmp/insXmluxe-beginNewIDLine)

#read -p "
#testing 2068
#newID=\"\$radix\$subIdL\"
#newID=\"$radix$subIdL\"

#beginNewIDLine $beginNewIDLine

#" EnterNull


grep -n "<!-- end $newID -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endNewIDLine


endNewIDLine=$(cat /tmp/insXmluxe-endNewIDLine)

#read -p "
#endNewIDLine = $endNewIDLine
#testing 2128
#" EnterNull

#break

#fi

#done

cat $targetFile.lmx | sed -n ''$beginNewIDLine','$endNewIDLine'p' > /tmp/insXmluxe-newSeries

cd ..

## In questo modo eliminerei i "titoli" di ogni elemento
# e.g. 
# <Series ID="a04" name="limite superiore">limite superiore
# diventerebbe
# <Series ID="a04" name="limite superiore">
#
#cat /tmp/insXmluxe-newSeries | sed 's/>.*/>/g'



## In questo modo otterei i "titoli" e i valori di ogni elemento
# e.g.
# limite superiore
# gennaio
# 7
#
# maggio
# 7
#
#cat /tmp/insXmluxe-newSeries | sed 's/.*>//g' | sed -r '/^\s*$/d' > /tmp/insXmluxe-Series_Keys_Value


	grep "^<Series" /tmp/insXmluxe-newSeries > /tmp/insXmluxe-stringaSeriesResp

	cat /tmp/insXmluxe-stringaSeriesResp | sed 's/.*ID="//g' | sed 's/".*//g' > /tmp/insXmluxe-idSeries

idSeries=$(cat /tmp/insXmluxe-idSeries)

	cat /tmp/insXmluxe-stringaSeriesResp | sed 's/.*>//g' > /tmp/insXmluxe-pastSeries

pastSeries=$(cat /tmp/insXmluxe-pastSeries)

#cat /tmp/insXmluxe-newSeries | sed 's/>.*/>/g' | sed 's/name=".*>/name="">/g'
cat /tmp/insXmluxe-stringaSeriesResp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglio

dettaglio=$(cat /tmp/insXmluxe-stringaDettaglio)

mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"la Series\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglio\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Directory | echo pezzo4 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-insertSeries

series=$(cat /tmp/xmluxe-insertSeries)


####### Da terminale va bene, ma da script no perché sed non accetta $series aventi lo spazio.
###### con vim risolvo il problema.
#read -p "
#testing 2200
#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'\$leggoSost'$/name=\"'\$series'\">'\$series'/g' > /tmp/insXmluxe-newSeries-01
#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name=\"'$series'\">'$series'/g' > /tmp/insXmluxe-newSeries-01

#" EnterNull

#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name="'$series'">'$series'/g' > /tmp/insXmluxe-newSeries-01

#cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries


vim -c "%s/<Series ID=\"$idSeries\" name.*>$pastSeries$/<Series ID=\"$idSeries\" name=\"$series\">$series/g" /tmp/insXmluxe-newSeries -c :w -c :q

	## L'Item in Category Dataset02 non è individuabile con tale metodo perché non ha titolo,
	## eseguire la ricerca per name="".

#read -p "
#testing 2319
#Series aggiornata
#" EnterNull


### Aggiorno gli Item

rm -fr /tmp/insXmluxe-upgradeItems

mkdir /tmp/insXmluxe-upgradeItems

grep "^<Item ID" /tmp/insXmluxe-newSeries > /tmp/insXmluxe-allItemsToUpgrade

split -l1 /tmp/insXmluxe-allItemsToUpgrade /tmp/insXmluxe-upgradeItems/

for allItemsToUp in $(ls /tmp/insXmluxe-upgradeItems)

do
	leggoItemToUp=$(cat /tmp/insXmluxe-upgradeItems/$allItemsToUp)

cat /tmp/insXmluxe-upgradeItems/$allItemsToUp | sed 's/.*ID="//g' | sed 's/".*//g' > /tmp/insXmluxe-idItem

idItem=$(cat /tmp/insXmluxe-idItem)


#cat /tmp/insXmluxe-newSeries | sed 's/name.*>/name="ITEM '$idItem'">/g' > /tmp/insXmluxe-newSeries-01

#cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries

vim -c "%s/<Item ID=\"$idItem\" name.*>/<Item ID=\"$idItem\" name=\"ITEM $idItem\">/g" /tmp/insXmluxe-newSeries -c :w -c :q


idKey="$idItem.01"

	grep "^<Key ID=\"$idKey\"" /tmp/insXmluxe-newSeries > /tmp/insXmluxe-stringaKeyResp

cat /tmp/insXmluxe-stringaKeyResp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglio

dettaglio=$(cat /tmp/insXmluxe-stringaDettaglio)

cat /tmp/insXmluxe-stringaKeyResp | sed 's/.*>//g' > /tmp/insXmluxe-pastKey

pastKey=$(cat /tmp/insXmluxe-pastKey)


mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"la Key\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglio\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Directory | echo pezzo4 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-insertKey

key=$(cat /tmp/xmluxe-insertKey)

#cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name="KEY '$key'">'$key'/g' > /tmp/insXmluxe-newSeries-01

#cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries

### testing 
#cp /tmp/insXmluxe-newSeries /tmp/insXmluxe-newSeriesTestingKey

vim -c "%s/<Key ID=\"$idItem.01\" name.*>$pastKey$/<Key ID=\"$idItem.01\" name=\"KEY $key\">$key<\/Key>/g" /tmp/insXmluxe-newSeries -c :w -c :q

#read -p "
#testing 3103
#/tmp/insXmluxe-newSeriesTestingKey
#/tmp/insXmluxe-newSeries
#" EnterNull

## Aggiornamento dei valori per ogni Key

cat /tmp/insXmluxe-stringaDettaglio | sed 's/.*ID="//g' | sed 's/".*//g' > /tmp/insXmluxe-idKey

idKey=$(cat /tmp/insXmluxe-idItem)

grep "<Value ID=\"$idItem.02\" " /tmp/insXmluxe-newSeries > /tmp/insXmluxe-stringaValueResp

cat /tmp/insXmluxe-stringaValueResp | sed 's/.*>//g' > /tmp/insXmluxe-pastValue

pastValue=$(cat /tmp/insXmluxe-pastValue)

cat /tmp/insXmluxe-stringaValueResp | sed 's/>.*/>/g' | sed 's/ name=".*>/>/g' | sed 's/"/\\"/g' > /tmp/insXmluxe-stringaDettaglioValue

dettaglioValue=$(cat /tmp/insXmluxe-stringaDettaglioValue)

#read -p "
#testing 3118
#dettaglioValue = $dettaglioValue
#" EnterNull

costantiValues() {

if [ ! -f /tmp/xmlux-valuesCostExists ]; then

#read -p "
#testing 3127 
#/tmp/xmlux-valuesCostExists non esiste
#" EnterNull

vim /usr/local/lib/xmlux/documentClasses/data/categoryDataset/costanti-vim.txt

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmlux-vimInputUNIVERSAL

silent ! touch /tmp/xmlux-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"il valore (Value)\"
let pezzo3 = \"per\"
let pezzo4 = \"$dettaglioValue\"
let pezzo5 = \"appartenente a\"
let pezzo6 = \"Item ID=\\\"$idItem\\\"; Series '$series'\"

let pezzo7 = \"Se il valore fosse una\"
let pezzo8 = \"costante\"
let pezzo9 = \"per più Values, segui esso con la locuzione\"
let pezzo10 = \"cost\"

let pezzo11 = \"e.g.\"
let pezzo12 = \"100 cost\"


echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Number | echo pezzo4 | echohl None
echo pezzo5
echohl Directory | echo pezzo6 | echohl None
echo interlinea
echo pezzo7
echohl Special | echo pezzo8 | echohl None
echo pezzo9
echohl operator | echo pezzo10 | echohl None
echo interlinea
echo pezzo11
echohl Type | echo pezzo12 | echohl None
echo interlinea
" > /tmp/xmlux-universalInput-01

cat /tmp/xmlux-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmlux/UNIVERSAL.vim

touch /tmp/xmlux-ruffiano

vim -c ":runtime! vimScript/xmlux/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmlux-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmlux-value

value=$(cat /tmp/xmlux-value)


grep " cost" /tmp/xmlux-value > /tmp/xmlux-valueRespGrep

stat --format %s /tmp/xmlux-valueRespGrep > /tmp/xmlux-valueRespGrepBytes

bytesCostItems=$(cat /tmp/xmlux-valueRespGrepBytes)

## II if sub A
if test $bytesCostItems -gt 0

then

## non è un errore $varKey.

cat /tmp/xmlux-value | sed 's/ cost//g' > /tmp/xmlux-Value

value=$(cat /tmp/xmlux-Value)

	mkdir costanti 2> /dev/null

	cronoAggiornamento=$(date +"%Y-%m-%d-%H-%M-%S")
	
echo "varKey upgrade $cronoAggiornamento
value $(cat /tmp/xmlux-Value)
idKey $idKey
idValue $idValue
idItem $idItem
idSeries $idSeries" > costanti/$idSeries



echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxVim

echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxPublicVim

touch /tmp/xmlux-valuesCostExists

## <datalux-> non è un errore, è un file che serve a $ull/datalux/upData/
echo "$series: $value" >> /tmp/datalux-costantiToPrint

else

#read -p "
#testing  179
#Valori di Keys senza costanti
#" EnterNull

## Se il valore non fosse stato espresso come costante, 
## senza allungare con condizionali che rasentano la ridondanza,
## non occorre nemmeno il condizionale di esistenza grazie ai break di prima.

#if [ ! -f /tmp/xmlux-elements/values/$varKey ]; then
echo $value > /tmp/xmlux-Value
#fi

value=$(cat /tmp/xmlux-value)


fi

else

	## scritto dalla precedente immissione di Value come costante
value=$(cat /tmp/xmlux-Value)

echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxVim

echo ":%s/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$value/<Value ID=\"$idValue\" name=\"VALUE $nameValue\">$series/g" >> /tmp/xmlux-sostLmxPublicVim

fi

## idValue è successivo a idKey, e idKey ha come ultima cifra <01>.
## quindi:
idValue="$idItem.02"

nameValue="$value"

}

costantiValues


#
##cat /tmp/insXmluxe-newSeries | sed 's/name.*>'$leggoSost'$/name="VALUE '$value'">'$value'/g' > /tmp/insXmluxe-newSeries-01
#
##cp /tmp/insXmluxe-newSeries-01 /tmp/insXmluxe-newSeries
#

### testing
#cp /tmp/insXmluxe-newSeries /tmp/insXmluxe-newSeriesTestingValue

vim -c "%s/Value ID=\"$idItem.02\" name.*>$pastValue$/Value ID=\"$idItem.02\" name=\"VALUE $value\">$value<\/Value>/g" /tmp/insXmluxe-newSeries -c :w -c :q

#read -p "
#testing 3285
#/tmp/insXmluxe-newSeriesTestingValue
#/tmp/insXmluxe-newSeries
#" EnterNull

done

#read -p "
#testing 3328 
#Items, Keys, Value aggiornati
#" EnterNull

cat $targetFile.lmx | sed '/<\/CategoryDataset>/d' > /tmp/xmluxe-delChiusura

echo "Gdd
ZZ

"> /tmp/xmluxe-commandDelLastLine

vim -s /tmp/xmluxe-commandDelLastLine 

cp /tmp/xmluxe-delChiusura $targetFile.lmx

cat /tmp/insXmluxe-newSeries >> $targetFile.lmx

echo "</CategoryDataset>" >> $targetFile.lmx

#read -p "
#testing 3350
#concatenazione effettuata
#" EnterNull

rm -r newTempProject

break

fi



if test $leggoDotFrequency -eq 1

then

	### Per i category dataset02, devo inserire tanti Item quanti
	## sono già presenti nelle precedenti Series

	####### La Key va espressa prima del ciclo perché deve essere in comune
	###### con tutti gli Item, cambieranno solo i valori delle Key per ogni Item.
#echo ""
#echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertKey.java

mkdir -p ~/.vim/vimScript/xmluxe 2> /dev/null

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"la Key\"
let pezzo3 = \"che avrà ogni Item per ogni relativa Series\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-key

key=$(cat /tmp/xmluxe-key)

rm -fr /tmp/insXmluxe-IDsItemsCateg02Split

mkdir /tmp/insXmluxe-IDsItemsCateg02Split
	
split -l1 /tmp/insXmluxe-IDs /tmp/insXmluxe-IDsItemsCateg02Split/

declare -i varEveryItem=0

## Devo leggere al contrario
for everyItem in $(ls /tmp/insXmluxe-IDsItemsCateg02Split/)

do

varEveryItem=varEveryItem+1

IDGradusII=$(cat /tmp/insXmluxe-IDsItemsCateg02Split/$everyItem)

cat /tmp/insXmluxe-IDsItemsCateg02Split/$everyItem | sed 's/\.[^\.]*$//' > /tmp/insXmluxe-IDPrefix

prefix="$(cat /tmp/insXmluxe-IDPrefix)"

cat /tmp/insXmluxe-IDsItemsCateg02Split/$everyItem | sed 's/.*\.//' | sed '2p' > /tmp/insXmluxe-SubId

SubId=$(cat /tmp/insXmluxe-SubId)

subId=$(echo $SubId + 1 | bc)

if test $subId -lt 10

then
	subIdL="0$subId"

else

subIdL=$subId

fi

newIDTest="$prefix.$subIdL"

grep "^$newIDTest$" $targetFile-lmxv/kin/$targetFile-ids.lmxv > /tmp/insXmluxe-idExistence

stat --format %s /tmp/insXmluxe-idExistence > /tmp/insXmluxe-idExistenceBytes

leggoBytes=$(cat /tmp/insXmluxe-idExistenceBytes)

if ! test $leggoBytes -gt 0

then

newID="$prefix.$subIdL"

grep -n "<Item ID=\"$IDGradusII\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-beginAnteIDLine

beginAnteIDLine=$(cat /tmp/insXmluxe-beginAnteIDLine)

#read -p "
#testing 2209
#newID=\"\$prefix.\$subIdL\"
#newID=\"$prefix.$subIdL\"

#anteID=\"\$prefix.\$anteSubId\"
#anteID=\"$prefix.$anteSubId\"

#ID selezionato attuale:
#IDGradusII = $IDGradusII

#beginAnteIDLine = $beginAnteIDLine
#" EnterNull


grep -n "<!-- end $IDGradusII -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endAnteIDLine

#read -p "
#grep -n \"<!-- end \$anteID -->\" \$targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endAnteIDLine
#grep -n \"<!-- end $anteID -->\" $targetFile.lmx | cut -d: -f1,1 > /tmp/insXmluxe-endAnteIDLine
#testing 2128
#" EnterNull

endAnteIDLine=$(cat /tmp/insXmluxe-endAnteIDLine)

#break

#fi

#done

echo "$newID" > /tmp/insXmluxe-newID

cat $targetFile.lmx | sed -n ''$beginAnteIDLine','$endAnteIDLine'p' > /tmp/insXmluxe-innerItem

### La Key precedente <ante>
#grep "<Key" /tmp/insXmluxe-innerItem | sed 's/.*">//g' | sed 's/<.*//g' > /tmp/insXmluxe-key

#key=$(cat /tmp/insXmluxe-key)

#read -p "
#testing 3469
#/tmp/insXmluxe-innerItem
#" EnterNull

echo ""
echo ""
#java /usr/local/lib/xmlux/java/xmluxe/insert/insertNameItem.java

#nameItem=$(cat /tmp/xmluxe-insertNameItem)


if [ -d costanti ]; then

	## $prefix corrisponde alla Series delle costanti
	grep "idSeries $prefix" -r costanti > /tmp/insXmluxe-respCostanti

stat --format %s /tmp/insXmluxe-respCostanti > /tmp/insXmluxe-respCostantiBytes

bytesCostanti=$(cat /tmp/insXmluxe-respCostantiBytes)

if test $bytesCostanti -gt 0

then

### Il Value precedente <ante>
grep "<Value" /tmp/insXmluxe-innerItem | sed 's/.*">//g' | sed 's/<.*//g' > /tmp/insXmluxe-value

value=$(cat /tmp/insXmluxe-value)

#read -p "
#testing 3499
#costante
#value = $value
#" EnterNull

else

echo "fun! UNIVERSAL#UNIVERSAL()

silent ! sudo rm -f /tmp/xmluxe-vimInputUNIVERSAL

silent ! touch /tmp/xmluxe-vimInputUNIVERSAL

function! Input()

let interlinea = \"\"
  
let pezzo1 = \"Inserisci\"
let pezzo2 = \"il valore (Value)\"
let pezzo3 = \"della key\"
let pezzo4 = \"$key\"
let pezzo5 = \"del nuovo\"
let pezzo6 = \"Item $newID\"

echo pezzo1 
echohl WarningMsg | echo pezzo2 | echohl None 
echo pezzo3
echohl Number | echo pezzo4 | echohl None
echo pezzo5
echohl Number | echo pezzo6 | echohl None
echo interlinea
" > /tmp/xmluxe-universalInput-01

cat /tmp/xmluxe-universalInput-01 /usr/local/lib/xmlux/input/xmluxe/UNIVERSAL02.edr > ~/.vim/vimScript/xmluxe/UNIVERSAL.vim

touch /tmp/xmluxe-ruffiano

vim -c ":runtime! vimScript/xmluxe/UNIVERSAL.vim" -c ":cal UNIVERSAL#UNIVERSAL()" /tmp/xmluxe-ruffiano -c :q

cp /tmp/xmluxe-vimInputUNIVERSAL /tmp/xmluxe-value

value=$(cat /tmp/xmluxe-value)

#read -p "
#testing 3543 
#value = $value
#" EnterNull

fi

fi

echo "
<Item ID=\"$newID\" name=\"Item $newID Key $key\">

<Key ID=\"$newID.01\" name=\"KEY $newID.01\">$key</Key>
<!-- end $newID.01 -->

<Value ID=\"$newID.02\" name=\"VALUE $newID.02\">$value</Value>
<!-- end $newID.02 -->

</Item>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

#read -p "
#testing 3560
#value = $value
#key = $key
#" EnterNull


#		read -p "
#testing 2196
	
#sed -n '1,'\$endAnteIDLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$endAnteIDLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

#sed -n ''\$endAnteIDLine',\$p' \$targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$endAnteIDLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#" EnterNull

sed -n '1,'$endAnteIDLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$endAnteIDLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

#read -p "
#testing
#2212
#" EnterNull

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


fi

done

break

fi

done

break

fi


if [ -f /tmp/xmluxe-cimicePieDataset ]; then
	
	sed 's/[^.]//g' /tmp/insXmluxe-newID | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

		for frequency in {1}

	do

if test $leggoDotFrequency -eq 0

then

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertNamePiedataset.java

namePiedataset=$(cat /tmp/xmluxe-insertNamePiedataset)


echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertItem.java

item=$(cat /tmp/xmluxe-insertItem)

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertKey.java

key=$(cat /tmp/xmluxe-insertKey)

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertValue.java

value=$(cat /tmp/xmluxe-insertValue)

			echo "
<Item ID=\"$newID\" name=\"Item $newID\">$item

<Key ID=\"$newID.01\" name=\"KEY $newID.01.01\">$key</Key>
<!-- end $newID.01 -->

<Value ID=\"$newID.02\" name=\"VALUE $newID.01.02\">$value</Value>
<!-- end $newID.02 -->
</Item>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

break

fi

done

break

fi

##### Septem Data (seven-data)
### Opzioni 'name' (-name) e 'title' (-t)


if [ -f /tmp/xmluxe-cimiceData-seven ]; then

	## Oltre a rendere il codice più elegante e veloce, tale ciclo è strettamente
	# necessario al funzionamento del codice.
	
for options in {1}

do

grep "^-st$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertStructure

stat --format %s /tmp/xmluxse-insertStructure > /tmp/xmluxse-insertStructureBytes

leggoBytesOptionStructure=$(cat /tmp/xmluxse-insertStructureBytes)

## I if
if test $leggoBytesOptionStructure -gt 0

then

leggoIdRoot=$radix

echo "$leggoIdRoot 01" | sed 's/ //g' > /tmp/xmluxe-gradusI_structure

gradusIStructure=$(cat /tmp/xmluxe-gradusI_structure)

cp $targetFile.str /tmp/xmluxe-pre00

#cat /tmp/xmluxe-pre00 | grep -A 100000000 "<gradusI ID=\"$gradusIStructure\"" | sed '/<\/radix>/d' > /tmp/xmluxe-pre0

grep -n "<gradusI ID=\"$gradusIStructure\"" /tmp/xmluxe-pre00 | cut -d: -f1,1 > /tmp/xmluxe-structureGradusILine

structureGradusILine=$(cat /tmp/xmluxe-structureGradusILine)


grep -n "<\/radix>" /tmp/xmluxe-pre00 | cut -d: -f1,1 > /tmp/xmluxe-structureRadixLine

structureRadixLine=$(cat /tmp/xmluxe-structureRadixLine)

sed -n ''$structureGradusILine','$structureRadixLine'p' /tmp/xmluxe-pre00 > /tmp/xmluxe-pre0

cat /tmp/xmluxe-pre0 | sed 's/'$gradusIStructure'/'$newID'/g' | sed '/<\/radix>/d' >> /tmp/xmluxe-pre000

#gvim -f /tmp/xmluxe-pre000

## ok testato
#
echo "" > /tmp/xmluxe-pre0000

cat /tmp/xmluxe-pre0000 /tmp/xmluxe-pre000 > /tmp/insXmluxe-toInject

gvim -f /tmp/insXmluxe-toInject

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

break

fi


grep "^-name$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertName

stat --format %s /tmp/xmluxse-insertName > /tmp/xmluxse-insertNameBytes

leggoBytesOptionName=$(cat /tmp/xmluxse-insertNameBytes)

## I if
if test $leggoBytesOptionName -gt 0

then

echo ""
echo ""
java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

name=$(cat /tmp/xmluxe-insertName)


grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

## II if
if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" name=\"$name\">$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

else

echo "
<$element ID=\"$newID\" name=\"$name\">

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject

## II fi
fi

sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx


else

grep "^-t$" /tmp/InsXmluxe-PseudoOptions/* > /tmp/xmluxse-insertTitle

stat --format %s /tmp/xmluxse-insertTitle > /tmp/xmluxse-insertTitleBytes

leggoBytesOptionTitle=$(cat /tmp/xmluxse-insertTitleBytes)

if test $leggoBytesOptionTitle -gt 0

then

echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
of $element to insert. At the end save and exit.
" > /tmp/insXmluxe-optionW.lmx

			gvim -f /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/insXmluxe-optionW.lmx)"

			echo "
<$element ID=\"$newID\" >$leggoW
</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject


else

echo "
<$element ID=\"$newID\" >

</$element>
<!-- end $newID -->" > /tmp/insXmluxe-toInject


fi

#read -p "
#testing 1009
#
#sed -n '1,'\$leggoLastIdGradusLine'p' \$targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione
#
#
#sed -n ''\$leggoLastIdGradusLine',\$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione
#
#" EnterNull


sed -n '1,'$leggoLastIdGradusLine'p' $targetFile.lmx > /tmp/insXmluxe-IbloccoIniezione

sed -n ''$leggoLastIdGradusLine',$p' $targetFile.lmx > /tmp/insXmluxe-IIbloccoIniezione

vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/insXmluxe-IIbloccoIniezione


cat /tmp/insXmluxe-IbloccoIniezione /tmp/insXmluxe-toInject > /tmp/insXmluxe-IIIbloccoIniezione

cat /tmp/insXmluxe-IIIbloccoIniezione /tmp/insXmluxe-IIbloccoIniezione > $targetFile.lmx

break

fi

done

break

fi

done

if [ -f /tmp/xmluxseSort-cimiceOnlyInsert ]; then

	exit
fi


#### Sorting
### Rispetto all'eseguibile sorting/sorting.sh ci sono delle modifiche perché
## questo è lanciato automaticamente appunto.


for ascendingDescending in {1}

do

if [ -f /tmp/xmluxseSort-cimiceAscendingIDa-name ]; then

/usr/local/bin/xmluxe --sort-a=$idToInsert --f=$targetFile

break

fi

if [ -f /tmp/xmluxseSort-cimiceAscendingIDa-title ]; then

/usr/local/bin/xmluxe --sort-a=$idToInsert -t --f=$targetFile

break

fi

if [ -f /tmp/xmluxseSort-cimiceDescendingIDd-name ]; then

/usr/local/bin/xmluxe --sort-d=$idToInsert --f=$targetFile

break

fi

if [ -f /tmp/xmluxseSort-cimiceDescendingIDd-title ]; then


/usr/local/bin/xmluxe --sort-d=$idToInsert -t --f=$targetFile

break

fi

done


rm -fr /tmp/xmluxse*

rm -fr /tmp/insXmluxe*

exit


