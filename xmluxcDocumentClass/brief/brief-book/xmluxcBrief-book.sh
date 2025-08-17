#!/bin/bash

targetFile="$(cat /tmp/xmluxcTargetFile)"

leggoBytesMarginTrue=$(cat /tmp/xmluxcMarginTrueBytes)

## tutti i capitoli e sottostanti elementi
grep "\." /tmp/xmluxc-css03 > /tmp/xmluxc-css04

cat /tmp/xmluxc-css04 | sort > /tmp/xmluxc-css05

## solo i capitoli, ossia gli a* senza .
comm -3 /tmp/xmluxc-css03 /tmp/xmluxc-css05 > /tmp/xmluxc-css06

## Nei valori degli elementi non possono esserci caratteri speciali, quali e.g. *, #, &.
# perché grep non leggerebbe la stringa e quindi non producendo file *.dtd, *.css perfetti.

################ INIZIO ROOT = TITLE = TITULUS = radix CSS, DTD

rm -fr  /tmp/xmluxc-cssRoot

mkdir /tmp/xmluxc-cssRoot

split -l1 /tmp/xmluxc-css01 /tmp/xmluxc-cssRoot/


for c in $(ls /tmp/xmluxc-cssRoot)
do
	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item


	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id

	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

	if test $leggoIdRoot == $leggoID

	then

		grep "ID=\"$leggoIdRoot\"" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

		leggoItem="$(cat /tmp/xmluxc-item)"

## Root non ha zeri ma  sempre e.g. <a>.
          echo "/* Root = $leggoIdRoot = radix = titulus */
$leggoItem { background-color: rgb(54,69,79); color: rgb(170,170,170); text-align: center; font-size: 43pt; font-weight: bold;
font-family: Arial, "Arial", serif }" >> $targetFile.css

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoIdRoot" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles
#
#echo "$leggoItem" > /tmp/xmluxc-itemRoot
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

	  echo "<!-- Root = $leggoIdRoot= titulus = title = radix = $leggoItem $leggoIdRoot -->
<!ELEMENT $leggoItem ANY>" >> $targetFile.dtd

## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

rm -f /tmp/xmluxc-cssRoot/$c

	fi


done
################ FINE ROOT CSS, DTD


################ INIZIO SINOSSI CSS


for c in $(ls /tmp/xmluxc-cssRoot)

do
	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id

	leggoID="$(cat /tmp/xmluxc-id)"

	leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

	echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxc-sinossi

	idSinossi="$(cat /tmp/xmluxc-sinossi)"

	## sinossi: un solo numero (un solo zero)
	if test "$leggoID" == "$idSinossi"

	then
	
	if test $leggoBytesMarginTrue -gt 0

		then

		echo "/* Synopsis $leggoID */
$leggoItem { display: block; font-size: 30pt; font-weight: bold;
font-family: Arial, \"Arial\", serif; margin-left: 270px; margin-right: 300px; text-align: left; 
margin-top: 10ex; margin-bottom: 10ex; padding-top: 4ex; padding-bottom: 4ex; padding-left: 2ex; padding-right: 2ex; 
border-bottom: 2px solid rgb(25, 25, 50); border-top: 2px solid rgb(25, 25, 50); 
border-left: 2px solid rgb(25, 25, 50); border-right: 2px solid rgb(25, 25, 50); width: 10.65in }" >> $targetFile.css

		else

		echo "/* Synopsis $leggoID */
$leggoItem { display: block; font-size: 30pt; font-weight: bold;
font-family: Arial, \"Arial\", serif; margin-left: 270px; margin-right: 300px; text-align: left; 
margin-top: 10ex; margin-bottom: 10ex; padding-top: 4ex; padding-bottom: 4ex; padding-left: 2ex; padding-right: 2ex; 
border-bottom: 2px solid rgb(25, 25, 50); border-top: 2px solid rgb(25, 25, 50); width: 10.65in }" >> $targetFile.css

fi

        fi

done

################ FINE SYNOPSIS CSS

rm -fr /tmp/xmluxc-toc

touch /tmp/xmluxc-toc
################ INIZIO  PART CSS

for c in $(ls /tmp/xmluxc-cssRoot)

do
	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id

	leggoID="$(cat /tmp/xmluxc-id)"

	leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 0

	then

		if test ! "$leggoID" == "$idSinossi"

		then

		echo "/* 'part' = $leggoItem  $leggoID */
$leggoItem { display: block; 
font-size: 33pt; font-weight: bold; font-family: Arial, \"Arial\", serif; 
margin-left: 270px; margin-right: 300px; text-align: left }" >> $targetFile.css

	break

	        fi

	fi

done
################ FINE PART CSS

### Per scrivere una volta solo un elemento nel file css, e nel file dtd per dichiararlo:
## basta individuarlo una volta sola, ecco perché uso i cicli con break.
## Ma poi uso gli stessi cicli ma senza break, per scrivere tutti gli elementi come log, 
## in dtd commentati, e per il futuro quando implementerò in xnlux xslt e xml schema.

################ INIZIO CHAPTER CSS
for c in $(ls /tmp/xmluxc-cssRoot)

do
	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	## Inizio parte 01 08 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 1

	then

	leggoBytesMarginTrue=$(cat /tmp/xmluxcMarginTrueBytes)

	if test $leggoBytesMarginTrue -gt 0

		then

		echo "/** 'chapter' = $leggoItem $leggoID*/
$leggoItem { display: block; font-size: 33pt; font-weight: bold; font-family: Arial, \"Arial\", serif; 
padding-top: 4ex; padding-bottom: 4ex; padding-left: 2ex; padding-right: 2ex; border-bottom: 2px solid rgb(25, 25, 50);
border-top: 2px solid rgb(25, 25, 50);  border-left: 2px solid rgb(25, 25, 50); border-right: 2px solid rgb(25, 25, 50); width: 10.65in }" >> $targetFile.css

		else ## del margin=true

		echo "/** 'chapter' = $leggoItem $leggoID*/
$leggoItem { display: block; font-size: 33pt; font-weight: bold; font-family: Arial, \"Arial\", serif; 
padding-top: 3ex; padding-bottom: 3ex; padding-left: 2ex; padding-right: 2ex }" >> $targetFile.css

	fi

	echo $leggoItem >> /tmp/xmluxc-toc

	break
	
	fi
	
done
############## FINE CHAPTERS CSS


################ INIZIO SECTION -> CSS

leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

grep "ID=\"$leggoIdRoot" /tmp/xmluxc-css05 > /tmp/xmlux-sectionAnd

rm -fr /tmp/xmluxc-css05Split

mkdir /tmp/xmluxc-css05Split

split -l1 /tmp/xmlux-sectionAnd  /tmp/xmluxc-css05Split/



for d in $(ls /tmp/xmluxc-css05Split)

do
	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 2

	then

		## è una sezione perché ha 1 pto.
## qui va il css per le sezioni

echo "/* section $leggoItem $leggoID */
$leggoItem { display: block; font-size: 95%; font-weight: bold; font-family: Arial, \"Arial\", serif;
padding-top: 2ex; padding-bottom: 2ex; border-bottom: 2px solid rgb(25, 25, 50); border-top: 2px solid rgb(25, 25, 50); width: 10.65in }" >> $targetFile.css
		
	break

	fi
done

################ FINE SECTION -> CSS

################ INIZIO SUBSECTION -> CSS

for d in $(ls /tmp/xmluxc-css05Split)

do
	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 3

	then
		## è una sottosezione perché ha 2 pti.
## qui va il css per le sottosezioni

echo "/* subsection $leggoItem $leggoID */
$leggoItem { display: block; font-size: 90%; font-weight: bold; font-family: Arial, \"Arial\", serif;
padding-top: 1ex; padding-bottom: 1ex }" >> $targetFile.css
	
break
	
	fi

done

################ FINE SUBSECTION -> CSS

################ INIZIO SUBSUBSECTION -> CSS
for d in $(ls /tmp/xmluxc-css05Split)

do
	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 4

	then
		## è una sottosottosezione perché ha 3 pti.
## qui va il css per le sottosottosezioni

echo "/* subsubsection $leggoItem $leggoID */
$leggoItem {display: block; font-size: 90%; font-weight: bold; font-family: Arial, \"Arial\", serif;
padding-top: 1ex; padding-bottom: 1ex }" >> $targetFile.css

	break

	fi

done

################ FINE SUBSUBSECTION -> CSS

################ INIZIO PARAPGRAPH -> CSS

for d in $(ls /tmp/xmluxc-css05Split)

do
	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 5

	then
		## è un paragafo perché ha 4 pto.
## qui va il css per i paragrafi

echo "/* paragraph $leggoItem $leggoID */
$leggoItem {display: block; font-size: 90%; font-weight: bold; font-family: Arial, \"Arial\", serif;
padding-top: 1ex; padding-bottom: 1ex }" >> $targetFile.css

	break
	
	fi

done
################ FINE PARAGRAPH -> CSS

################ INIZIO SUBPARAGRAPH -> CSS

for d in $(ls /tmp/xmluxc-css05Split)

do
	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 6

	then

echo "/* subparagraph $leggoItem $leggoID */
$leggoItem {display: block; font-size: 90%; font-weight: bold; font-family: Arial, \"Arial\", serif;
padding-top: 1ex; padding-bottom: 1ex }" >> $targetFile.css

	break

	fi
done
################ FINE SUBPARAGRAPH -> CSS

rm -fr /tmp/xmluxc-whiteSpace

mkdir /tmp/xmluxc-whiteSpace


############# INIZIO SINOSSI LOG, DTD, XSLT, XML SCHEMA
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

for c in $(ls /tmp/xmluxc-cssRoot)

do

rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata


	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id

	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

	echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxc-sinossi

	idSinossi="$(cat /tmp/xmluxc-sinossi)"

	## sinossi: un solo numero (un solo zero)
	if test "$leggoID" == "$idSinossi"

	then

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<\/'$leggoItem'/q' > /tmp/xmluxc-linesDtdElements
	
	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "</$leggoItem" > /tmp/xmluxc-linesDtdElements

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtdElements

	vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxc-linesDtdElements

	## i <! li rimuovo all'inizio del codice 
#	cat /tmp/xmluxc-linesDtdElements | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtd00

	cat /tmp/xmluxc-linesDtdElements |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtd00

	grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata
echo "p" > /tmp/xmluxc-whiteSpace/p


fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep -oh "\w*<\w*" /tmp/xmluxc-linesDtd00 | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata

cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr 

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-pcdataTr | sort | uniq > /tmp/xmluxc-pcdataTr1 

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr1)"

echo "<!-- All that is under \"synopsis\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"synopsis\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles

	rm -f /tmp/xmluxc-cssRoot/$c
        
	fi

done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

############# FINE SINOSSI LOG, DTD (b), XSLT, XML SCHEMA 

################ INIZIO  PART  DTD, LOG, XML SCHEMA, XSL
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

for c in $(ls /tmp/xmluxc-cssRoot)

do
	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id

	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)


	#### Part, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

	leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

	## A differenza della sinossi non posso più usare un'unica istanza del tipo grep -A, grep -B, grep -B perché
	## a differenza della sinossi e di part, posso avere più capitoli in un file *.lmx.	

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<\/'$leggoItem'/q' > /tmp/xmluxc-linesDtdPre01

#	cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "</$leggoItem" > /tmp/xmluxc-linesDtdPre01

	grep "<$leggoItem" /tmp/xmluxc-linesDtdPre01 > /tmp/xmluxc-linesDtdPre02

	awk '{ nlines++;  print nlines }' /tmp/xmluxc-linesDtdPre02 | tail -n1 > /tmp/xmluxc-numeroLines

	leggoLines=$(cat /tmp/xmluxc-numeroLines)

	if test $leggoLines -gt 1
    
	then
   
	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<\/'$leggoItem'/q' | sed '/<'$leggoItem'/q' > /tmp/xmluxc-linesDtd

	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "</$leggoItem" | grep -B 100000000 "<$leggoItem" > /tmp/xmluxc-linesDtd

else

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<\/'$leggoItem'/q' > /tmp/xmluxc-linesDtd

#	cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "</$leggoItem" > /tmp/xmluxc-linesDtd

	fi

	vim -s /usr/local/lib/xmlux/command-delLastLine  /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine  /tmp/xmluxc-linesDtd

#	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements

	cat /tmp/xmluxc-linesDtd | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements

	cat /tmp/xmluxc-linesDtd  |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements
	grep "ID=\"$leggoIdRoot" /tmp/xmluxc-linesDtdElements | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat  /tmp/xmluxc-ElementDtd | sort | uniq > /tmp/xmluxc-ElementSU 

cat /tmp/xmluxc-ElementSU | tr -d '\n' > /tmp/xmluxc-ElementSUTr 

stat --format %s /tmp/xmluxc-ElementSUTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPartElements="$(cat /tmp/xmluxc-ElementSUTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento part può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## chapter+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento part può contenere zero o più sotto-elementi <chapter>, dovrei scrivere:
## chapter*
##
echo "<!-- All that is under \"part\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPartElements)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"part\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
		

rm -f /tmp/xmluxc-cssRoot/$c

	fi


done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE PART CSS, DTD, LOG, XML SCHEMA, XSLT


############## INIZIO CHAPTERS LOG, DTD (b), XSLT, XML SCHEMA
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

rm -f /tmp/xmluxc-ElementDtd

touch /tmp/xmluxc-ElementDtd

for c in $(ls /tmp/xmluxc-cssRoot)

do

rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata

	leggoC="$(cat /tmp/xmluxc-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)


	#### Capitolo: il capitolo ha un punto

	if test $leggoDotFrequency -eq 1

	then

	## A iniziare dai capitoli non posso più usare un'unica istanza del tipo grep -A, grep -B, grep -B perché
	## a differenza della sinossi, posso avere più capitoli in un file *.lmx.	

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<!-- end '$leggoID' -->/q' > /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine  /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine  /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine  /tmp/xmluxc-linesDtd

	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements0

	cat /tmp/xmluxc-linesDtdElements0 | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements
	## Devo restringere l'individuazione dei pcdata solo nell'elemento corrente, e non nei suoi children.

	## pre 21 ottobre
	cat /tmp/xmluxc-linesDtdElements | grep "ID=\"$leggoIdRoot" > /tmp/xmluxc-linesDtd001

	## questo mi seleziona anche se sono presenti ID di immagini all'interno di tutto il capitolo
	#cat /tmp/xmluxc-linesDtdElements | grep -o "ID=\"$leggoIdRoot*.*" > /tmp/xmluxc-linesDtd001

	stat --format %s /tmp/xmluxc-linesDtd001 > /tmp/xmluxc-linesDtd001Bytes

	leggoBytesDtd001=$(cat /tmp/xmluxc-linesDtd001Bytes)

	## il capitolo ha children o meno
	if test $leggoBytesDtd001 -gt 0

	then
## ha children 
	cat /tmp/xmluxc-linesDtd001 | head -n1 | awk '$1 > 0 {print $2}' | sed 's/>/ /g' | cut -d= -f2,2 | sed 's/"//g' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idPCDATA

	leggoIdPCDATA="$(cat /tmp/xmluxc-idPCDATA)"

	cat /tmp/xmluxc-linesDtdElements | sed '/ID="'$leggoIdPCDATA'"/q' > /tmp/xmluxc-linesDtd00
#	cat /tmp/xmluxc-linesDtdElements | grep -B 100000000 "ID=\"$leggoIdPCDATA\"" > /tmp/xmluxc-linesDtd00


	else

	cp /tmp/xmluxc-linesDtdElements /tmp/xmluxc-linesDtd00


	fi

grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

## center

grep "<center>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#center="center"

echo "center+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<center>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/center>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


## code
grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

# images in pcdata

grep "<img" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#img="img"

cat /tmp/xmluxc-elementPCDATA | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imgPCDATAElement

rm -fr /tmp/xmluxc-splitImgPCDATA

mkdir /tmp/xmluxc-splitImgPCDATA

split -l1 /tmp/xmluxc-imgPCDATAElement /tmp/xmluxc-splitImgPCDATA/

for i in $(ls /tmp/xmluxc-splitImgPCDATA)

do
	leggoI="$(cat /tmp/xmluxc-splitImgPCDATA/$i)"

	echo "$leggoI ," | sed 's/ //g' > /tmp/xmluxc-imgPCDATAElementComposto 

leggoImgPCDATAElement="$(cat /tmp/xmluxc-imgPCDATAElementComposto)"

echo "$leggoImgPCDATAElement " >> /tmp/xmluxc-pcdata

done

fi

sed -r '/<img/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/img/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep -oh "\w*<\w*" /tmp/xmluxc-linesDtdElements | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata

cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr 

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento chapter può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## section+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento chapter può contenere zero o più sotto-elementi <section>, dovrei scrivere:
## section*
##
echo "<!-- All that is under \"chapter\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"chapter\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd
fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles

rm -f /tmp/xmluxc-cssRoot/$c

	fi
	
done

## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE CHAPTERS LOG, DTD (b), XSLT, XML SCHEMA

#### ok 12 ottobre 10:23 fare anche part prima, e poi tutto ciò che viene dopo chapter

################ INIZIO SECTION -> DTD, LOGS, XSLT, XML SCHEMA

if [ ! -f /tmp/xmluxc-escapeDtd ]; then

rm -f /tmp/xmluxc-ElementDtd

touch /tmp/xmluxc-ElementDtd


leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

grep "ID=\"$leggoIdRoot" /tmp/xmluxc-css05 > /tmp/xmlux-sectionAnd


rm -fr /tmp/xmluxc-css05Split

mkdir /tmp/xmluxc-css05Split

split -l1 /tmp/xmlux-sectionAnd  /tmp/xmluxc-css05Split/

for d in $(ls /tmp/xmluxc-css05Split)

do

rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata

	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 2

	then

		## è una sezione perché ha 2 pti.
## qui va il css per le sezioni

	## A iniziare dai capitoli non posso più usare un'unica istanza del tipo grep -A, grep -B, grep -B perché
	## a differenza della sinossi e di part, posso avere più capitoli in un file *.lmx.

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<!-- end '$leggoID' -->/q' > /tmp/xmluxc-linesDtd

	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "<!-- end $leggoID -->" > /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxc-linesDtd

	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements0

	cat /tmp/xmluxc-linesDtdElements0 | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements

		## Devo restringere l'individuazione dei pcdata solo nell'elemento corrente, e non nei suoi children.

	## pre 21 ottobre
	cat /tmp/xmluxc-linesDtdElements | grep "ID=\"$leggoIdRoot" > /tmp/xmluxc-linesDtd001

	## questo mi seleziona anche se sono presenti ID di immagini all'interno di tutto il sezione
	#cat /tmp/xmluxc-linesDtdElements | grep -o "ID=\"$leggoIdRoot*.*" > /tmp/xmluxc-linesDtd001

	stat --format %s /tmp/xmluxc-linesDtd001 > /tmp/xmluxc-linesDtd001Bytes

	leggoBytesDtd001=$(cat /tmp/xmluxc-linesDtd001Bytes)

	## la sezione ha children o meno
	if test $leggoBytesDtd001 -gt 0

	then
## ha children 
	cat /tmp/xmluxc-linesDtd001 | head -n1 | awk '$1 > 0 {print $2}' | sed 's/>/ /g' | cut -d= -f2,2 | sed 's/"//g' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idPCDATA

	leggoIdPCDATA="$(cat /tmp/xmluxc-idPCDATA)"

	cat /tmp/xmluxc-linesDtdElements | sed '/ID="'$leggoIdPCDATA'"/q' > /tmp/xmluxc-linesDtd00

	#cat /tmp/xmluxc-linesDtdElements | grep -B 100000000 "ID=\"$leggoIdPCDATA\"" > /tmp/xmluxc-linesDtd00

	else

	cp /tmp/xmluxc-linesDtdElements /tmp/xmluxc-linesDtd00

	fi

grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

## center

grep "<center>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#center="center"

echo "center+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<center>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/center>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

# images in pcdata

grep "<img" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#img="img"
cat /tmp/xmluxc-elementPCDATA | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imgPCDATAElement

rm -fr /tmp/xmluxc-splitImgPCDATA

mkdir /tmp/xmluxc-splitImgPCDATA

split -l1 /tmp/xmluxc-imgPCDATAElement /tmp/xmluxc-splitImgPCDATA/

for i in $(ls /tmp/xmluxc-splitImgPCDATA)

do
	leggoI="$(cat /tmp/xmluxc-splitImgPCDATA/$i)"

	echo "$leggoI ," | sed 's/ //g' > /tmp/xmluxc-imgPCDATAElementComposto 

leggoImgPCDATAElement="$(cat /tmp/xmluxc-imgPCDATAElementComposto)"

echo "$leggoImgPCDATAElement " >> /tmp/xmluxc-pcdata

done

fi

sed -r '/<img/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/img/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep -oh "\w*<\w*" /tmp/xmluxc-linesDtdElements | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata

cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr 

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento section può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## section+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento section può contenere zero o più sotto-elementi <section>, dovrei scrivere:
## section*
##
echo "<!-- All that is under \"section\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"section\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles
#
rm -f /tmp/xmluxc-css05Split/$d

fi

done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE SECTION -> DTD, LOGS, XSLT, XML SCHEMA

################ INIZIO SUBSECTION -> DTD
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

rm -f /tmp/xmluxc-ElementDtd

touch /tmp/xmluxc-ElementDtd

for d in $(ls /tmp/xmluxc-css05Split)

do

rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata


	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 3

	then
	## è una sottosezione perché ha 3 pti.

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<!-- end '$leggoID' -->/q' > /tmp/xmluxc-linesDtd

	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "<!-- end $leggoID -->" > /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxc-linesDtd

	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements0

	cat /tmp/xmluxc-linesDtdElements0 | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements

	## Devo restringere l'individuazione dei pcdata solo nell'elemento corrente, e non nei suoi children.

	## pre 21 ottobre
	cat /tmp/xmluxc-linesDtdElements | grep "ID=\"$leggoIdRoot" > /tmp/xmluxc-linesDtd001

	## questo mi seleziona anche se sono presenti ID di immagini all'interno di tutto il sottosezione
	#cat /tmp/xmluxc-linesDtdElements | grep -o "ID=\"$leggoIdRoot*.*" > /tmp/xmluxc-linesDtd001

	stat --format %s /tmp/xmluxc-linesDtd001 > /tmp/xmluxc-linesDtd001Bytes

	leggoBytesDtd001=$(cat /tmp/xmluxc-linesDtd001Bytes)

	## la sottosezione ha children o meno
	if test $leggoBytesDtd001 -gt 0

	then
## ha children 
	cat /tmp/xmluxc-linesDtd001 | head -n1 | awk '$1 > 0 {print $2}' | sed 's/>/ /g' | cut -d= -f2,2 | sed 's/"//g' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idPCDATA

	leggoIdPCDATA="$(cat /tmp/xmluxc-idPCDATA)"

	cat /tmp/xmluxc-linesDtdElements | sed '/ID="'$leggoIdPCDATA'"/q' > /tmp/xmluxc-linesDtd00

#	cat /tmp/xmluxc-linesDtdElements | grep -B 100000000 "ID=\"$leggoIdPCDATA\"" > /tmp/xmluxc-linesDtd00

	else

	cp /tmp/xmluxc-linesDtdElements /tmp/xmluxc-linesDtd00

	fi

grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

## center

grep "<center>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#center="center"

echo "center+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<center>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/center>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

# images in pcdata

grep "<img" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#img="img"
cat /tmp/xmluxc-elementPCDATA | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imgPCDATAElement

rm -fr /tmp/xmluxc-splitImgPCDATA

mkdir /tmp/xmluxc-splitImgPCDATA

split -l1 /tmp/xmluxc-imgPCDATAElement /tmp/xmluxc-splitImgPCDATA/

for i in $(ls /tmp/xmluxc-splitImgPCDATA)

do
	leggoI="$(cat /tmp/xmluxc-splitImgPCDATA/$i)"

	echo "$leggoI ," | sed 's/ //g' > /tmp/xmluxc-imgPCDATAElementComposto 

leggoImgPCDATAElement="$(cat /tmp/xmluxc-imgPCDATAElementComposto)"

echo "$leggoImgPCDATAElement " >> /tmp/xmluxc-pcdata

done

fi

sed -r '/<img/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/img/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep -oh "\w*<\w*" /tmp/xmluxc-linesDtdElements | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata

cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento subsection può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## section+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento subsection può contenere zero o più sotto-elementi <section>, dovrei scrivere:
## section*
##
echo "<!-- All that is under \"subsection\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"subsection\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles

        rm -f /tmp/xmluxc-css05Split/$d
	
	fi

done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE SUBSECTION -> DTD, LOGS, XSLT, XML SCHEMA

################ INIZIO SUBSUBSECTION -> DTD, LOGS, XSLT, XML SCHEMA
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

rm -f /tmp/xmluxc-ElementDtd

touch /tmp/xmluxc-ElementDtd

for d in $(ls /tmp/xmluxc-css05Split)

do

rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata

	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 4

	then
		## è una sottosottosezione perché ha 3 pti.
	## A iniziare dai capitoli non posso più usare un'unica istanza del tipo grep -A, grep -B, grep -B perché
	## a differenza della sinossi e di part, posso avere più capitoli in un file *.lmx.

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<!-- end '$leggoID' -->/q' > /tmp/xmluxc-linesDtd
	
	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "<!-- end $leggoID -->" > /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine  /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine  /tmp/xmluxc-linesDtd

	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements0

	cat /tmp/xmluxc-linesDtdElements0 | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements
	
	## Devo restringere l'individuazione dei pcdata solo nell'elemento corrente, e non nei suoi children.

	## pre 21 ottobre
	cat /tmp/xmluxc-linesDtdElements | grep "ID=\"$leggoIdRoot" > /tmp/xmluxc-linesDtd001

	## questo mi seleziona anche se sono presenti ID di immagini all'interno di tutto il sottosottosezione
	#cat /tmp/xmluxc-linesDtdElements | grep -o "ID=\"$leggoIdRoot*.*" > /tmp/xmluxc-linesDtd001

	stat --format %s /tmp/xmluxc-linesDtd001 > /tmp/xmluxc-linesDtd001Bytes

	leggoBytesDtd001=$(cat /tmp/xmluxc-linesDtd001Bytes)

	## la sottosottosezione ha children o meno
	if test $leggoBytesDtd001 -gt 0

	then
## ha children 
	cat /tmp/xmluxc-linesDtd001 | head -n1 | awk '$1 > 0 {print $2}' | sed 's/>/ /g' | cut -d= -f2,2 | sed 's/"//g' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idPCDATA

	leggoIdPCDATA="$(cat /tmp/xmluxc-idPCDATA)"

	cat /tmp/xmluxc-linesDtdElements | sed '/ID="'$leggoIdPCDATA'"/q' > /tmp/xmluxc-linesDtd00

#	cat /tmp/xmluxc-linesDtdElements | grep -B 100000000 "ID=\"$leggoIdPCDATA\"" > /tmp/xmluxc-linesDtd00

	else

	cp /tmp/xmluxc-linesDtdElements /tmp/xmluxc-linesDtd00

	fi

grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

## center

grep "<center>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#center="center"

echo "center+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<center>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/center>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

# images in pcdata

grep "<img" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#img="img"

cat /tmp/xmluxc-elementPCDATA | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imgPCDATAElement

rm -fr /tmp/xmluxc-splitImgPCDATA

mkdir /tmp/xmluxc-splitImgPCDATA

split -l1 /tmp/xmluxc-imgPCDATAElement /tmp/xmluxc-splitImgPCDATA/

for i in $(ls /tmp/xmluxc-splitImgPCDATA)

do
	leggoI="$(cat /tmp/xmluxc-splitImgPCDATA/$i)"

	echo "$leggoI ," | sed 's/ //g' > /tmp/xmluxc-imgPCDATAElementComposto 

leggoImgPCDATAElement="$(cat /tmp/xmluxc-imgPCDATAElementComposto)"

echo "$leggoImgPCDATAElement " >> /tmp/xmluxc-pcdata

done

fi

sed -r '/<img/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/img/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep -oh "\w*<\w*" /tmp/xmluxc-linesDtdElements | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata


cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr 

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento subsubsection può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## section+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento subsubsection può contenere zero o più sotto-elementi <section>, dovrei scrivere:
## section*
##
echo "<!-- All that is under \"subsubsection\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"subsubsection\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles

	rm -f /tmp/xmluxc-css05Split/$d

	fi

done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE SUBSUBSECTION -> DTD, LOGS, XSLT, XML SCHEMA

################ INIZIO PARAPGRAPH -> DTD, LOGS, XSLT, XML SCHEMA
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

rm -f /tmp/xmluxc-ElementDtd

touch /tmp/xmluxc-ElementDtd

for d in $(ls /tmp/xmluxc-css05Split)

do

rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata

	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 5

	then
		## è un paragrafo perché ha 5 pti.
	## A iniziare dai capitoli non posso più usare un'unica istanza del tipo grep -A, grep -B, grep -B perché
	## a differenza della sinossi e di part, posso avere più capitoli in un file *.lmx.

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<!-- end '$leggoID' -->/q' > /tmp/xmluxc-linesDtd
	
	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "<!-- end $leggoID -->" > /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine  /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine  /tmp/xmluxc-linesDtd

	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements0

	cat /tmp/xmluxc-linesDtdElements0 | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements
	
	## Devo restringere l'individuazione dei pcdata solo nell'elemento corrente, e non nei suoi children.

	## pre 21 ottobre
	cat /tmp/xmluxc-linesDtdElements | grep "ID=\"$leggoIdRoot" > /tmp/xmluxc-linesDtd001

	## questo mi seleziona anche se sono presenti ID di immagini all'interno di tutto il paragraph
	#cat /tmp/xmluxc-linesDtdElements | grep -o "ID=\"$leggoIdRoot*.*" > /tmp/xmluxc-linesDtd001

	stat --format %s /tmp/xmluxc-linesDtd001 > /tmp/xmluxc-linesDtd001Bytes

	leggoBytesDtd001=$(cat /tmp/xmluxc-linesDtd001Bytes)

	## la paragraph ha children o meno
	if test $leggoBytesDtd001 -gt 0

	then
## ha children 
	cat /tmp/xmluxc-linesDtd001 | head -n1 | awk '$1 > 0 {print $2}' | sed 's/>/ /g' | cut -d= -f2,2 | sed 's/"//g' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idPCDATA

	leggoIdPCDATA="$(cat /tmp/xmluxc-idPCDATA)"

	cat /tmp/xmluxc-linesDtdElements | sed '/ID="'$leggoIdPCDATA'"/q' > /tmp/xmluxc-linesDtd00

#	cat /tmp/xmluxc-linesDtdElements | grep -B 100000000 "ID=\"$leggoIdPCDATA\"" > /tmp/xmluxc-linesDtd00

	else

	cp /tmp/xmluxc-linesDtdElements /tmp/xmluxc-linesDtd00

	fi

grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

## center

grep "<center>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#center="center"

echo "center+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<center>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/center>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

# images in pcdata

grep "<img" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#img="img"

cat /tmp/xmluxc-elementPCDATA | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imgPCDATAElement

rm -fr /tmp/xmluxc-splitImgPCDATA

mkdir /tmp/xmluxc-splitImgPCDATA

split -l1 /tmp/xmluxc-imgPCDATAElement /tmp/xmluxc-splitImgPCDATA/

for i in $(ls /tmp/xmluxc-splitImgPCDATA)

do
	leggoI="$(cat /tmp/xmluxc-splitImgPCDATA/$i)"

	echo "$leggoI ," | sed 's/ //g' > /tmp/xmluxc-imgPCDATAElementComposto 

leggoImgPCDATAElement="$(cat /tmp/xmluxc-imgPCDATAElementComposto)"

echo "$leggoImgPCDATAElement " >> /tmp/xmluxc-pcdata

done

fi

sed -r '/<img/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/img/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep -oh "\w*<\w*" /tmp/xmluxc-linesDtdElements | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata


cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr 

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento paragraph può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## section+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento paragraph può contenere zero o più sotto-elementi <section>, dovrei scrivere:
## section*
##
echo "<!-- All that is under \"paragraph\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"paragraph\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles

	rm -f /tmp/xmluxc-css05Split/$d

	fi

done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE PARAGRAPH -> DTD, LOGS, XSLT, XML SCHEMA

################ INIZIO SUBPARAGRAPH -> DTD, LOGS, XSLT, XML SCHEMA
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

rm -f /tmp/xmluxc-ElementDtd

touch /tmp/xmluxc-ElementDtd


for d in $(ls /tmp/xmluxc-css05Split)

do
	
rm -f /tmp/xmluxc-pcdata

touch /tmp/xmluxc-pcdata

	leggoD="$(cat /tmp/xmluxc-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxc-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-item

	leggoItem="$(cat /tmp/xmluxc-item)"

	cat /tmp/xmluxc-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxc-id0

	cat /tmp/xmluxc-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxc-id
	
	leggoID="$(cat /tmp/xmluxc-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxc-title

	leggoTitle="$(cat /tmp/xmluxc-title)"

	## Inizio parte 01 10 ottobre

	sed 's/[^.]//g' /tmp/xmluxc-id | awk '{ print length }' > /tmp/xmluxc-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxc-dotFrequency)

	if test $leggoDotFrequency -eq 6

	then

	## A iniziare dai capitoli non posso più usare un'unica istanza del tipo grep -A, grep -B, grep -B perché
	## a differenza della sinossi e di part, posso avere più capitoli in un file *.lmx.

	cat /tmp/xmluxc-css000 | sed -n '/<'$leggoItem' ID="'$leggoID'"/,$p' | sed '/<!-- end '$leggoID' -->/q' > /tmp/xmluxc-linesDtd
	
	#cat /tmp/xmluxc-css000 | grep -A 100000000 "<$leggoItem ID=\"$leggoID\"" | grep -B 100000000 "<!-- end $leggoID -->" > /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delLastLine  /tmp/xmluxc-linesDtd

	vim -s /usr/local/lib/xmlux/command-delFirstLine  /tmp/xmluxc-linesDtd

	cat /tmp/xmluxc-linesDtd | sed '/^<!/d' |  sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements0

	cat /tmp/xmluxc-linesDtdElements0 | sed '/^<\//d' | sed -r '/^\s*$/d' > /tmp/xmluxc-linesDtdElements
	
	## Devo restringere l'individuazione dei pcdata solo nell'elemento corrente, e non nei suoi children.

	## pre 21 ottobre
	cat /tmp/xmluxc-linesDtdElements | grep "ID=\"$leggoIdRoot" > /tmp/xmluxc-linesDtd001

	## questo mi seleziona anche se sono presenti ID di immagini all'interno di tutto il paragraph
	#cat /tmp/xmluxc-linesDtdElements | grep -o "ID=\"$leggoIdRoot*.*" > /tmp/xmluxc-linesDtd001

	stat --format %s /tmp/xmluxc-linesDtd001 > /tmp/xmluxc-linesDtd001Bytes

	leggoBytesDtd001=$(cat /tmp/xmluxc-linesDtd001Bytes)

	## la paragraph ha children o meno
	if test $leggoBytesDtd001 -gt 0

	then
## ha children 
	cat /tmp/xmluxc-linesDtd001 | head -n1 | awk '$1 > 0 {print $2}' | sed 's/>/ /g' | cut -d= -f2,2 | sed 's/"//g' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idPCDATA

	leggoIdPCDATA="$(cat /tmp/xmluxc-idPCDATA)"

	cat /tmp/xmluxc-linesDtdElements | sed '/ID="'$leggoIdPCDATA'"/q' > /tmp/xmluxc-linesDtd00

#	cat /tmp/xmluxc-linesDtdElements | grep -B 100000000 "ID=\"$leggoIdPCDATA\"" > /tmp/xmluxc-linesDtd00

	else

	cp /tmp/xmluxc-linesDtdElements /tmp/xmluxc-linesDtd00

	fi

grep "<p>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#p="p"

echo "p+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<p>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/p>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<pg>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pg="pg"

echo "pg+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<pg>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pg>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

## center

grep "<center>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#center="center"

echo "center+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<center>/d'  /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/center>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<code>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#code="code"

echo "code+, " >> /tmp/xmluxc-pcdata
echo "code" > /tmp/xmluxc-whiteSpace/code

fi

sed -r '/<code>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/code>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements



grep "<CODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#CODE="CODE"

echo "CODE+, " >> /tmp/xmluxc-pcdata

echo "CODE" > /tmp/xmluxc-whiteSpace/CODE

fi

sed -r '/<CODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/CODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<PCODE>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

PCODE="PCODE"

echo "PCODE+, " >> /tmp/xmluxc-pcdata

echo "PCODE" > /tmp/xmluxc-whiteSpace/PCODE

fi

sed -r '/<PCODE>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/PCODE>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements


grep "<pcode>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#pcode="pcode"

echo "pcode+, " >> /tmp/xmluxc-pcdata

echo "pcode" > /tmp/xmluxc-whiteSpace/pcode

fi

sed -r '/<pcode>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/pcode>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<snip>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#snip="snip"

echo "snip+, " >> /tmp/xmluxc-pcdata

echo "snip" > /tmp/xmluxc-whiteSpace/snip

fi

sed -r '/<snip>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/snip>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<SNIP>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#SNIP="SNIP"

echo "SNIP+, " >> /tmp/xmluxc-pcdata

echo "SNIP" > /tmp/xmluxc-whiteSpace/SNIP

fi

sed -r '/<SNIP>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/SNIP>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<output>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#output="output"

echo "output+, " >> /tmp/xmluxc-pcdata

echo "output" > /tmp/xmluxc-whiteSpace/output

fi

sed -r '/<output>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/output>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<OUTPUT>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#OUTPUT="OUTPUT"

echo "OUTPUT+, " >> /tmp/xmluxc-pcdata

echo "OUTPUT" > /tmp/xmluxc-whiteSpace/OUTPUT

fi

sed -r '/<OUTPUT>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/OUTPUT>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<it>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#it="it"

echo "it+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<it>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/it>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<sl>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#sl="sl"

echo "sl+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<sl>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/sl>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<bf>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#bf="bf"

echo "bf+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<bf>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/bf>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<light>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#light="light"

echo "light+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<light>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/light>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<em>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#em="em"

echo "em+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<em>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/em>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<scaps>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#scaps="scaps"

echo "scaps+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<scaps>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/scaps>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<under>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#under="under"

echo "under+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<under>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/under>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<lthr>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#lthr="lthr"
echo "lthr+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<lthr>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/lthr>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<url>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#url="url"

echo "url+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<url>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/url>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<description>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#description="description"

echo "description+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<description>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/description>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<enumerate>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#enumerate="enumerate"

echo "enumerate+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<enumerate>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/enumerate>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<task>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#task="task"

echo "task+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<task>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/task>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<roman>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#roman="roman"

echo "roman+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<roman>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/roman>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<ROMAN>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#ROMAN="ROMAN"

echo "ROMAN+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<ROMAN>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/ROMAN>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<square>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#square="square"

echo "square+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<square>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/square>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<itemize>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#itemize="itemize"

echo "itemize+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<itemize>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/itemize>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#large="large"

echo "large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<Large>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#Large="Large"

echo "Large+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<Large>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/Large>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<small>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#small="small"

echo "small+, " >> /tmp/xmluxc-pcdata

fi

sed -r '/<small>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/small>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

# images in pcdata

grep "<img" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#img="img"

cat /tmp/xmluxc-elementPCDATA | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imgPCDATAElement

rm -fr /tmp/xmluxc-splitImgPCDATA

mkdir /tmp/xmluxc-splitImgPCDATA

split -l1 /tmp/xmluxc-imgPCDATAElement /tmp/xmluxc-splitImgPCDATA/

for i in $(ls /tmp/xmluxc-splitImgPCDATA)

do
	leggoI="$(cat /tmp/xmluxc-splitImgPCDATA/$i)"

	echo "$leggoI ," | sed 's/ //g' > /tmp/xmluxc-imgPCDATAElementComposto 

leggoImgPCDATAElement="$(cat /tmp/xmluxc-imgPCDATAElementComposto)"

echo "$leggoImgPCDATAElement " >> /tmp/xmluxc-pcdata

done

fi

sed -r '/<img/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/img/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep "<tiny>" /tmp/xmluxc-linesDtd00 > /tmp/xmluxc-elementPCDATA

stat --format %s /tmp/xmluxc-elementPCDATA > /tmp/xmluxc-Bytes

leggoBytes=$(cat /tmp/xmluxc-Bytes)

if test $leggoBytes -gt 0
then

#tiny="tiny"

echo "tiny" >> /tmp/xmluxc-pcdata

fi

sed -r '/<tiny>/d' /tmp/xmluxc-linesDtdElements > /tmp/xmluxc-linesDtd01

sed -r '/<\/tiny>/d' /tmp/xmluxc-linesDtd01 > /tmp/xmluxc-linesDtdElements

grep -oh "\w*<\w*" /tmp/xmluxc-linesDtdElements | sed 's/.*<//g' | sed -r '/^\s*$/d' | sort | uniq | awk '$1 > 0 {print $1}' | sed 's/<//g' | sed 's/>.*//g' | sed 's/$/+, /' > /tmp/xmluxc-ElementDtd

cat /tmp/xmluxc-ElementDtd /tmp/xmluxc-pcdata > /tmp/xmluxc-ElementEtPcdata

cat /tmp/xmluxc-ElementEtPcdata | sort | uniq > /tmp/xmluxc-ElementEtPcdataSU 

cat /tmp/xmluxc-ElementEtPcdataSU | tr -d '\n' > /tmp/xmluxc-pcdataTr 

stat --format %s /tmp/xmluxc-pcdataTr > /tmp/xmluxc-pcdataTrBytes

leggoBytes=$(cat /tmp/xmluxc-pcdataTrBytes)

if test $leggoBytes -gt 0

then

leggoPcdataList="$(cat /tmp/xmluxc-pcdataTr)"

### Se non volessi riportare esattamente tutti i sotto-elementi, potrei usare:
## <+> per esprimere <one or more> 
## e.g. tale elemento subparagraph può contenere uno o più sotto-elementi <section>, dovrei scrivere:
## section+
##
## <*> per esprimere <zero or more>
## e.g. tale elemento subparagraph può contenere zero o più sotto-elementi <section>, dovrei scrivere:
## section*
##
echo "<!-- All that is under \"subparagraph\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem ($leggoPcdataList)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

else

echo "<!-- All that is in \"subparagraph\" = $leggoItem = $leggoID -->
<!ELEMENT $leggoItem (#PCDATA)>
<!ATTLIST $leggoItem ID CDATA \"$leggoID\">" > /tmp/xmluxc-preDtd

fi

cat /tmp/xmluxc-preDtd | sed 's/, )/)/g' > /tmp/xmluxc-preDtd1

cat /tmp/xmluxc-preDtd1 >> $targetFile.dtd

#echo "$leggoID" >> /tmp/xmluxc-allIDs
#
#echo "$leggoItem" >> /tmp/xmluxc-allElements
#
#echo "$leggoTitle" >> /tmp/xmluxc-allTitles
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxc-itemsEtIDs
#
#echo "$leggoItem $leggoID $leggoTitle" >> /tmp/xmluxc-itemsEtIDsEtTitles
#
#echo "$leggoID $leggoTitle" >> /tmp/xmluxc-IDsEtTitles
#
#echo "$leggoItem $leggoTitle" >> /tmp/xmluxc-itemsEtTitles

	rm -f /tmp/xmluxc-css05Split/$d

	fi
done
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

################ FINE SUBPARAGRAPH -> DTD, LOGS, XSLT, XML SCHEMA

################ PCDATA in *.css
echo "/* PARAGRAPH ENV */
p { display: block; font-size: 20pt; font-weight: normal; font-style: normal;
font-family: Arial, \"Arial\", serif; white-space: pre; line-break: loose }
pg { display: block; font-size: 20pt; font-weight: normal; font-style: normal;
font-family: Arial, \"Arial\", serif; width: 1050px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word }
center { display: block; font-size: 20pt; font-weight: normal; font-family: Arial, \"Arial\", serif; text-align: center }
/* FONTS */
/** style **/
it { font-size: 20pt; font-weight: normal; font-style: italic; font-family: Arial, \"Arial\", serif; white-space: pre }
sl { font-size: 20pt; font-weight: normal; font-style: oblique; font-family: Arial, \"Arial\", serif; white-space: pre }
/** weight, weight/style **/
bf { font-size: 20pt; font-weight: bold; font-family: Arial, \"Arial\", serif; white-space: pre }
em { font-size: 20pt; font-style: oblique; font-weight: bold; font-family: Arial, \"Arial\", serif; white-space: pre }
/** variant **/
scaps { font-size: 20pt; font-weight: normal; font-style: normal; font-variant: small-caps; font-family: Arial, \"Arial\", serif; white-space: pre }
/* DECORATION */
under { font-size: 20pt; font-weight: normal; font-family: Arial, \"Arial\", serif; white-space: pre; text-decoration: underline }
lthr { font-size: 20pt; font-weight: normal; font-family: Arial, \"Arial\", serif; white-space: pre; text-decoration: line-through }
/* PATH, URL ENV */
url { background-color: rgb(54,69,79); color: rgb(0,191,255);
white-space: pre; font-size: 12pt; font-weight: normal; font-family: arial }
/* PROGR  ENV */
CODE { background-color: rgb(150,150,150); color: rgb(20,20,20);
display: block; white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
code { background-color: rgb(150,150,150); color: rgb(20,20,20);
white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
/* Snippet in blocco*/
SNIP { background-color: rgb(51,54,70); color: rgb(230,220,210);
display: block; white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
/* snippet in linea*/
snip { background-color: rgb(51,54,70); color: rgb(230,220,210);
white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
/* OUTPUT in blocco*/
OUTPUT { background-color: rgb(43,43,43); color: rgb(230,220,210);
display: block; white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
/* output in linea*/
output { background-color: rgb(43,43,43); color: rgb(230,220,210);
white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
/* Frammenti di codice e.g. comandi, in linea ovviamente  altrimenti se fosse in blocco
 * sarebbe uno SNIPPET */
pcode { background-color: rgb(70,43,70); color: rgb(240,220,240);
white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
PCODE { display: block; background-color: rgb(70,43,70); color: rgb(240,220,240);
white-space: pre; font-size: 15pt; font-weight: normal; font-family: monospace }
/* LIST ENV */
description { display: list-item; list-style-type: none }
enumerate { display: list-item; list-style-type: decimal }
task { display: list-item; list-style-type: lower-alpha }
roman { display: list-item; list-style-type: lower-roman }
ROMAN { display: list-item; list-style-type: upper-roman }
square { display: list-item; list-style-type: square }
itemize { display: list-item; list-style-type: disc }
/* SIZE ENV */
large  { font-size: 25pt; font-weight: normal; font-family: Arial, \"Arial\", serif }
Large  { font-size: 28pt; font-weight: normal; font-family: Arial, \"Arial\", serif }
small  { font-size: 15pt; font-weight: normal; font-family: Arial, \"Arial\", serif }
tiny { font-size: 12pt; font-weight: normal; font-family: Arial, \"Arial\", serif }" >> $targetFile.css

################## ENDPCDATA IN CSS


##################################### non nella struttura familiare
## the ID tree
#echo " " >> $targetFile.dtd
#
#echo "<!-- NOT KIN -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- (not kin) IDs tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-allIDs)" >> $targetFile.dtd
#
#echo "end IDs tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
# 
#echo "<!--(not kin) Elements tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-allElements)" >> $targetFile.dtd
#
#echo "end elements tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- (not kin) Titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-allTitles)" >> $targetFile.dtd
#
#echo "end titles tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- (not kin) IDs and relative elements tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-itemsEtIDs)" >> $targetFile.dtd
#
#echo "end IDs and relative elements tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- (not kin) IDs and relative titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-IDsEtTitles)" >> $targetFile.dtd
#
#echo "end IDs and relative titles tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- (not kin) Elements and relative titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-itemsEtTitles)" >> $targetFile.dtd
#
#echo "end elements and relative titles tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- (not kin) Elements, relative IDs and titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-itemsEtIDsEtTitles)" >> $targetFile.dtd
#
#echo "end elements, relative IDs and titles tree (not kin) -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
###################################### secondo la struttura familiare
#
#cat /tmp/xmluxc-allIDs | sort > /tmp/xmluxc-allIDsRec
#
#mkdir /tmp/xmluxc-allIDsRecSplit
#
#split -l1 /tmp/xmluxc-allIDsRec /tmp/xmluxc-allIDsRecSplit/
#
#for a in $(ls /tmp/xmluxc-allIDsRecSplit/)
#
#do
#	leggoAllIDsRecB="$(cat /tmp/xmluxc-allIDsRecSplit/$a)"
#
#grep "$leggoAllIDsRecB " /tmp/xmluxc-IDsEtTitles | sed 's/'$leggoAllIDsRecB'//g' > /tmp/xmluxc-titleRecB
#
#cat /tmp/xmluxc-titleRecB >> /tmp/xmluxc-allTitlesRec
#
#leggoTitleRecB="$(cat /tmp/xmluxc-titleRecB)"
#
#grep " $leggoAllIDsRecB " /tmp/xmluxc-itemsEtIDsEtTitles | awk '$1 > 0 {print $1}' > /tmp/xmluxc-elementsRecB
#
#cat /tmp/xmluxc-elementsRecB >> /tmp/xmluxc-allElementsRec
#
#leggoAllElementsRecB="$(cat /tmp/xmluxc-elementsRecB)"
#
#echo "$leggoAllElementsRecB $leggoAllIDsRecB" >> /tmp/xmluxc-itemsEtIDsRec
#
#echo "$leggoAllIDsRecB $leggoTitleRecB" >>/tmp/xmluxc-IDsEtTitlesRec
#
#echo "$leggoAllElementsRecB  $leggoTitleRecB" >> /tmp/xmluxc-itemsEtTitlesRec
#
#echo "$leggoAllElementsRecB $leggoAllIDsRecB $leggoTitleRecB" >> /tmp/xmluxc-itemsEtIDsEtTitlesRec
#
#done
#
#echo " " >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- KIN -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- IDs tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-allIDsRec)" >> $targetFile.dtd
#
#echo "end IDs tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
# 
#echo "<!-- Elements tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-allElementsRec)" >> $targetFile.dtd
#
#echo "end elements tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- Titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-allTitlesRec)" >> $targetFile.dtd
#
#echo "end titles tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- IDs and relative elements tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-itemsEtIDsRec)" >> $targetFile.dtd
#
#echo "end IDs and relative elements tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- IDs and relative titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-IDsEtTitlesRec)" >> $targetFile.dtd
#
#echo "end IDs and relative titles tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- Elements and relative titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-itemsEtTitlesRec)" >> $targetFile.dtd
#
#echo "end elements and relative titles tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd
#
#echo "<!-- Elements, relative IDs and titles tree" >> $targetFile.dtd
#
#echo "$(cat /tmp/xmluxc-itemsEtIDsEtTitlesRec)" >> $targetFile.dtd
#
#echo "end elements, relative IDs and titles tree -->" >> $targetFile.dtd
#
#echo " " >> $targetFile.dtd


### Costanti
if [ ! -f /tmp/xmluxc-escapeDtd ]; then

echo " " >> $targetFile.dtd

echo "<!-- Constants -->" >> $targetFile.dtd

rm -f /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

## <p>
grep "<p>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ p+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else
echo "<!ELEMENT p (img*, it+, sl+, bf+, light+, em+, scaps+, under+, lthr+, url+, CODE+, code+, SNIP+, snip+, OUTPUT+, output+, pcode+, PCODE+, description+, enumerate+, task+, roman+, ROMAN+, square+, itemize+, large+, Large+, small+, tiny+)>" >> $targetFile.dtd

fi

## <pg>
grep "<pg>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ pg+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

echo "<!ELEMENT pg (img*, it+, sl+, bf+, light+, em+, scaps+, under+, lthr+, url+, CODE+, code+, SNIP+, snip+, OUTPUT+, output+, pcode+, PCODE+, description+, enumerate+, task+, roman+, ROMAN+, square+, itemize+, large+, Large+, small+, tiny+)>" >> $targetFile.dtd

fi

## <img>
echo " " >> $targetFile.dtd
echo " " >> $targetFile.dtd

grep "\w*<img\w*" /tmp/xmluxc-css000 > /tmp/xmluxc-images0

stat --format %s /tmp/xmluxc-images0 >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/img\*, //g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "Esiste almeno un'immagine" > /tmp/xmluxc-imageExists

echo "<!ELEMENT img (#PCDATA)> >> $targetFile.dtd
<!ATTLIST img ID CDATA #REQUIRED>
<!ATTLIST img SOURCE CDATA #REQUIRED>
<!ATTLIST img ALT CDATA #REQUIRED>
<!ATTLIST img WIDTH CDATA #REQUIRED>
<!ATTLIST img HEIGHT CDATA #REQUIRED>" >> $targetFile.dtd

echo " " >> $targetFile.dtd

fi

## pulizia del file *.dtd nel caso in cui ci siano PCDATA, CDATA elements non utilizzati;
## e costanti.
## E` importante che sia rispettato l'ordine, ho scelto <<img\*,>> come I elemento all'interno di <p> e <pg>;
## ho scelto << tiny>> come ultimo elemento all'interno di <p> e <pg>. Quindi <img,> e < tiny> vanno
## inseriti in tale sezione [per costruire lo script di VIM] con tale precisa formattazione:
## <<img\*,>> -> senza spazio prima [a differenza di tutti i successivim env];
## << tiny>> -> con spazio prima e senza <,> dopo [senza virgola dopo a differenza di tutti i precedenti env.>.
### qua 30 ottobre
## <center>
grep "<center>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ center+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else
echo "<!ELEMENT center (#PCDATA)>" >> $targetFile.dtd

fi


## <url>
grep "<url>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ url+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT url (#PCDATA)>" >> $targetFile.dtd

fi


## <code>
grep "<code>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ code+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT code (#PCDATA)>
<!ATTLIST code xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi


## <CODE>
grep "<CODE>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ CODE+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT CODE (#PCDATA)>
<!ATTLIST CODE xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd


fi


## <pcode>
grep "<pcode>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ pcode+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT pcode (#PCDATA)>
<!ATTLIST pcode xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi


## <PCODE>
grep "<PCODE>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ PCODE+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT PCODE (#PCDATA)>
<!ATTLIST PCODE xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi

## <output>
grep "<output>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ output+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT output (#PCDATA)>
<!ATTLIST output xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi

## <OUTPUT>
grep "<OUTPUT>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ OUTPUT+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT OUTPUT (#PCDATA)>
<!ATTLIST OUTPUT xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi

## <snip>
grep "<snip>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ snip+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT snip (#PCDATA)>
<!ATTLIST snip xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi


## <SNIP>
grep "<SNIP>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ SNIP+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT SNIP (#PCDATA)>
<!ATTLIST SNIP xml:space (default|preserve) 'preserve'>" >> $targetFile.dtd

fi


## <it>
grep "<it>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ it+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT it (#PCDATA)>" >> $targetFile.dtd

fi


## <sl>
grep "<sl>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ sl+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT sl (#PCDATA)>" >> $targetFile.dtd

fi


## <bf>
grep "<bf>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ bf+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT bf (#PCDATA)>" >> $targetFile.dtd

fi


## <light>
grep "<light>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ light+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT light (#PCDATA)>" >> $targetFile.dtd

fi

## <em>
grep "<em>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ em+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT em (#PCDATA)>" >> $targetFile.dtd

fi

## <scaps>
grep "<scaps>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ scaps+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT scaps (#PCDATA)>" >> $targetFile.dtd

fi

## <under>
grep "<under>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ under+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT under (#PCDATA)>" >> $targetFile.dtd

fi

## <lthr>
grep "<lthr>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ lthr+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT lthr (#PCDATA)>" >> $targetFile.dtd

fi

## <description>
grep "<description>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ description+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT description (#PCDATA)>" >> $targetFile.dtd

fi

## <enumerate>
grep "<enumerate>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ enumerate+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT enumerate (#PCDATA)>" >> $targetFile.dtd

fi


## <task>
grep "<task>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ task+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT task (#PCDATA)>" >> $targetFile.dtd

fi

## <roman>
grep "<roman>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ roman+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT roman (#PCDATA)>" >> $targetFile.dtd

fi


## <ROMAN>
grep "<ROMAN>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ ROMAN+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT ROMAN (#PCDATA)>" >> $targetFile.dtd

fi

## <square>
grep "<square>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ square+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT square (#PCDATA)>" >> $targetFile.dtd

fi

## <itemize>
grep "<itemize>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ itemize+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT itemize (#PCDATA)>" >> $targetFile.dtd

fi

## <large>
grep "<large>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ large+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT large (#PCDATA)>" >> $targetFile.dtd

fi

## <Large>
grep "<Large>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ Large+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT Large (#PCDATA)>" >> $targetFile.dtd

fi

## <small>
grep "<small>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ small+,//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else

	echo "<!ELEMENT small (#PCDATA)>" >> $targetFile.dtd

fi
## <tiny>
grep "<tiny>" /tmp/xmluxc-css000 > /tmp/xmluxc-ifDtd

stat --format %s /tmp/xmluxc-ifDtd >  /tmp/xmluxc-ifDtdBytes

leggoBytes=$(cat /tmp/xmluxc-ifDtdBytes)

if test ! $leggoBytes -gt 0

then

echo ":silent! %s/ tiny+//g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

else
	echo "<!ELEMENT tiny (#PCDATA)>" >> $targetFile.dtd


fi

echo "<!-- begin blocco ruffiano
 center+,
 url+,
 code+,
 CODE+,
 pcode+,
 PCODE+,
 output+,
 OUTPUT+,
 snip+,
 SNIP+,
 it+,
 sl+,
 bf+,
 light+,
 em+,
 scaps+,
 under+,
 lthr+,
 description+,
 enumerate+,
 task+,
 roman+,
 ROMAN+,
 square+,
 itemize+,
 large+,
 Large+,
 small+,
 tiny+
( 
,) 
 p+, 
 pg+,
end blocco ruffiano -->" >> $targetFile.dtd

## Dopo la pulizia è necessario togliere lo spazio dopo la prima parentesi, e la <,> prima dell'ultima parentesi, e;
## nel caso in cui siano assenti <img\*> e <tiny>
echo ":silent! %s/( /(/g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo ":silent! %s/,)/)/g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

## Inoltre bisogna togliere il doppio spazio che si crea [dopo la pulizia] 
## dopo <p> dagli elementi che vanno daa section a subparagraph
echo ":silent! %s/p+,  /p+, /g" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

vim -c ":runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" $targetFile.dtd -c :w -c :q 

## pulizia del blocco ruffiano

grep -n "<!-- begin blocco ruffiano"  $targetFile.dtd | cut -d: -f1 > /tmp/xmluxc-beginBloccoRuffianoNLine

grep -n "end blocco ruffiano -->"  $targetFile.dtd | cut -d: -f1 > /tmp/xmluxc-endBloccoRuffianoNLine

inizioRigaBloccoRuffiano=$(cat /tmp/xmluxc-beginBloccoRuffianoNLine)

fineRigaBloccoRuffiano=$(cat /tmp/xmluxc-endBloccoRuffianoNLine)

passoRigheRuffiano=$(($fineRigaBloccoRuffiano - $inizioRigaBloccoRuffiano))

echo "$inizioRigaBloccoRuffiano Gd$passoRigheRuffiano
ZZ

" | sed 's/ //g' > /tmp/xmluxc-bloccoRuffianoCommand


vim -s /tmp/xmluxc-bloccoRuffianoCommand $targetFile.dtd

### Images
if [ -f /tmp/xmluxc-imageExists ]; then

## esiste almeno un'immagine

## images in *.dtd

echo " " >> $targetFile.dtd

echo "<!-- Begin images details" >> $targetFile.dtd

## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi


## images in *.css

echo "/* IMAGES */" >> $targetFile.css

rm -fr /tmp/xmluxc-images1

mkdir /tmp/xmluxc-images1

split -l1 /tmp/xmluxc-images0 /tmp/xmluxc-images1/

for e in $(ls /tmp/xmluxc-images1/)

do
	rm -fr /tmp/xmluxc-images2

	mkdir /tmp/xmluxc-images2

	split -l 1 /tmp/xmluxc-images1/$e /tmp/xmluxc-images2/

	for f in $(ls /tmp/xmluxc-images2/)

	do
	        cat /tmp/xmluxc-images2/$f | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxc-imageElement

	
		grep "ID" /tmp/xmluxc-images2/$f > /tmp/xmluxc-images3

		stat --format %s /tmp/xmluxc-images3 > /tmp/xmluxc-images4

		leggoBytes=$(cat /tmp/xmluxc-images4)

		if test $leggoBytes -gt 0

		then
		  cat /tmp/xmluxc-images3 | cut -d= -f2,1 | sed 's/"//g' > /tmp/xmluxc-imageID0
		  cat /tmp/xmluxc-imageID0 | sed  's/ID/\/ID/g' | sed 's/.*\///g' > /tmp/xmluxc-imageID1 
		  cat /tmp/xmluxc-imageID1 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 > /tmp/xmluxc-imageID

		fi


		grep "SOURCE" /tmp/xmluxc-images2/$f > /tmp/xmluxc-images3

		stat --format %s /tmp/xmluxc-images3 > /tmp/xmluxc-images4

		leggoBytes=$(cat /tmp/xmluxc-images4)

		if test $leggoBytes -gt 0

		then
			cat /tmp/xmluxc-images3 | sed 's/"//g' | awk '$1 > 0 {print $3}' | cut -d= -f2,2 > /tmp/xmluxc-imageSOURCE
			
		fi

                grep "ALT" /tmp/xmluxc-images2/$f > /tmp/xmluxc-images3

		stat --format %s /tmp/xmluxc-images3 > /tmp/xmluxc-images4

		leggoBytes=$(cat /tmp/xmluxc-images4)

		if test $leggoBytes -gt 0

		then
			cat /tmp/xmluxc-images3 | awk '$1 > 0 {print $4}' | sed 's/"//g' | cut -d= -f2,2 > /tmp/xmluxc-imageALT

		fi

                grep "WIDTH" /tmp/xmluxc-images2/$f > /tmp/xmluxc-images3

		stat --format %s /tmp/xmluxc-images3 > /tmp/xmluxc-images4

		leggoBytes=$(cat /tmp/xmluxc-images4)

		if test $leggoBytes -gt 0

		then
			cat /tmp/xmluxc-images3 | awk '$1 > 0 {print $5}' | sed 's/"//g' | cut -d= -f2,2 > /tmp/xmluxc-imageWIDTH 

		fi

                grep "HEIGHT" /tmp/xmluxc-images2/$f > /tmp/xmluxc-images3

		stat --format %s /tmp/xmluxc-images3 > /tmp/xmluxc-images4

		leggoBytes=$(cat /tmp/xmluxc-images4)

		if test $leggoBytes -gt 0

		then
			cat /tmp/xmluxc-images3 | awk '$1 > 0 {print $6}' | sed 's/"//g' | cut -d= -f2,2 > /tmp/xmluxc-imageHEIGHT 

		fi

                grep "FLOAT" /tmp/xmluxc-images2/$f > /tmp/xmluxc-images3

		stat --format %s /tmp/xmluxc-images3 > /tmp/xmluxc-images4

		leggoBytes=$(cat /tmp/xmluxc-images4)

		if test $leggoBytes -gt 0

		then
			cat /tmp/xmluxc-images3 | awk '$1 > 0 {print $7}' | sed 's/"//g' | cut -d= -f2,2 > /tmp/xmluxc-imageFLOAT0

			cat /tmp/xmluxc-imageFLOAT0 | sed 's/>.*//g' > /tmp/xmluxc-imageFLOAT	

		fi


		leggoImageID="$(cat /tmp/xmluxc-imageID)"

		leggoImageElement="$(cat /tmp/xmluxc-imageElement)"

		leggoImageALT="$(cat /tmp/xmluxc-imageALT)"

		leggoImageSOURCE="$(cat /tmp/xmluxc-imageSOURCE)"

		leggoImageWIDTH="$(cat /tmp/xmluxc-imageWIDTH)"

		leggoImageHEIGHT="$(cat /tmp/xmluxc-imageHEIGHT)"

		leggoImageFLOAT="$(cat /tmp/xmluxc-imageFLOAT)"

if [ ! -f /tmp/xmluxc-escapeDtd ]; then
		
		echo "<!-- Image $leggoImageElement ID=\"$leggoImageID\" -->
<!ELEMENT $leggoImageElement EMPTY>
<!ATTLIST $leggoImageElement ID CDATA \"$leggoImageID\" #REQUIRED>
<!ATTLIST $leggoImageElement SOURCE CDATA \"$leggoImageSOURCE\" #REQUIRED>
<!ATTLIST $leggoImageElement ALT CDATA \"$leggoImageALT\" #REQUIRED>
<!ATTLIST $leggoImageElement WIDTH CDATA \"$leggoImageWIDTH\" #REQUIRED>
<!ATTLIST $leggoImageElement HEIGHT CDATA \"$leggoImageHEIGHT\" #REQUIRED>" >> $targetFile.dtd

## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

		cat /tmp/xmluxc-imageWIDTH | sed 's/px//g' > /tmp/xmluxc-imageWIDTHlessPx

		leggoImageWIDTHlessPx="$(cat /tmp/xmluxc-imageWIDTHlessPx)"

                if test $leggoImageWIDTHlessPx -eq 700
		
		then

                        marginLeftPx="120pt"

		else


		  if test $leggoImageWIDTHlessPx -gt 700
		   
		   then

			if test $leggoImageWIDTHlessPx -eq 800
				
				then
				
					marginLeftPx="$((120 - 37*1))pt"
				#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*1" | bc)pt"




	   	        fi

	                if test $leggoImageWIDTHlessPx -eq 900
				
				then
				
					marginLeftPx="$((120 - 37*2))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*2" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 1000
				
				then
				
					marginLeftPx="$((120 - 37*3))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*3" | bc)pt"


	   	        fi

                        if test $leggoImageWIDTHlessPx -eq 1100
				
				then
				
					marginLeftPx="$((120 - 37*4))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*4" | bc)pt"

	   	        fi

                        if test $leggoImageWIDTHlessPx -eq 1200
				
				then
				
					marginLeftPx="$((120 - 37*5))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*5" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 1300
				
				then
				
					marginLeftPx="$((120 - 37*6))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*6" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 1400
				
				then
				
					marginLeftPx="$((120 - 37*7))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*7" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 1500
				
				then
				
					marginLeftPx="$((120 - 37*8))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*8" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 1600
				
				then
					marginLeftPx="$((120 - 37*9))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*9" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 1700
				
				then
				
					marginLeftPx="$((120 - 37*10))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 - 37.000*10" | bc)pt"

	   	        fi

		  fi



	          if test $leggoImageWIDTHlessPx -lt 700

		   then
		
	#	        c=$(echo "scale=3; $leggoImageWIDTHlessPx/700" | bc)

	#		num=$(echo "scale=3; $leggoImageWIDTHlessPx/2" | bc) 

	#		a=$(echo "scale=3; 2.314-(1-$c)" | bc)

	#		b=$(echo "scale=3; $a-1" | bc)

	#		d=$(echo "scale=3; 1/$b" | bc)

        #               marginLeftPx="$(echo "scale=3; $num/$d" | bc)px"

               	        if test $leggoImageWIDTHlessPx -eq 600
				
				then
				
					marginLeftPx="$((120 + 37*1))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 + 37.000*1" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 500
				
				then
				
					marginLeftPx="$((120 + 37*2))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 + 37.000*2" | bc)pt"

	   	        fi

                        if test $leggoImageWIDTHlessPx -eq 400
				
				then
				
					marginLeftPx="$((120 + 37*3))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 + 37.000*3" | bc)pt"

	   	        fi

			if test $leggoImageWIDTHlessPx -eq 300
				
				then
				
					marginLeftPx="$((120 + 37*4))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 + 37.000*4" | bc)pt"
	   	        fi

                        if test $leggoImageWIDTHlessPx -eq 100
				
				then
					marginLeftPx="$((120 + 37*5))pt"
					#marginLeftPx="$(echo "scale=3; 120.000 + 37.000*5" | bc)pt"

	   	        fi

		  fi
		
		fi

			
		echo "/* $leggoImageElement $leggoImageID $leggoImageALT */" >> $targetFile.css

		echo "$leggoImageElement { display: block; background: url($leggoImageSOURCE) no-repeat center center; 
width: $leggoImageWIDTH;
height: $leggoImageHEIGHT;
margin-left: $marginLeftPx }" >> $targetFile.css

## images dtd *.dtd
## Potrei esprimere ogni immagine nel file *.dtd, ma per file *.xml importanti il file
## *.dtd diventerebbe molto grosso; le immagini le esprimo in *.dtd fuori dal ciclo perché
## basta esprimerne una solo con la wildcard *: img*. Proprio come ho fatto in precedenza,
## quando ho appurato che esiste almeno un'immagine.

	done


done

if [ ! -f /tmp/xmluxc-escapeDtd ]; then

echo "<!-- End images details -->" >> $targetFile.dtd

echo " " >> $targetFile.dtd
## chiusura di if [ ! -f /tmp/xmluxc-escapeDtd ]; then
#
fi

fi


cp $targetFile.lmx.back $targetFile.lmx

rm $targetFile.lmx.back



exit

