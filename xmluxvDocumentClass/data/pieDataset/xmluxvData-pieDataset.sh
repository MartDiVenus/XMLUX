#!/bin/bash

targetFile="$(cat /tmp/xmluxvTargetFile)"

echo $PWD > /tmp/xmluxv-posnow

posnow=$(cat /tmp/xmluxv-posnow)

## Tutti gli id che iniziano con <a>, ossia il KEYorVALUE a.
# è troppo vincolante utilizzare la chiave <a>.
#grep -o "ID=\"a*.*" $targetFile.lmx > /tmp/xmluxv-css01
# In questo modo puoi scrivere ID anche nel preambolo, perché quest'ultimo escluso.

cat $targetFile.lmx | sed -n '/<!-- begin radix/,$p' > /tmp/xmluxv-css0000

## mi serve la coerenza di numero di righe tra il file lmx in cui effettuerò le iniezioni
## e il file selezionato in cui ho escluso il preambolo.
grep -n "<!-- begin radix" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxv-nLineaBeginRadix

leggoNBeginRadix=$(cat /tmp/xmluxv-nLineaBeginRadix)

righeEsatte=$(($leggoNBeginRadix - 1))

touch /tmp/xmluxv-IpezzoCoerenzaBeginRadixLmx

declare -i var=0

while ((k++ <$righeEsatte))
  do
  var=$var+1
  echo "riga per coerenza con il file lmx n. $var" >> /tmp/xmluxv-IpezzoCoerenzaBeginRadixLmx
done 

cat /tmp/xmluxv-IpezzoCoerenzaBeginRadixLmx /tmp/xmluxv-css0000 > /tmp/xmluxv-css000

## Il I ID è sempre quello del root, io non specifico nulla nel preambolo xml. 
grep "ID=*" /tmp/xmluxv-css000 | head -n 1 > /tmp/xmluxv-css00

## leggo il valore di root
cat /tmp/xmluxv-css00 | cut -d= -f2,2 | sed 's/"//g' | sed 's/>/ /' | awk '$1 > 0 {print $1}' > /tmp/xmluxv-idRoot

leggoIdRoot="$(cat /tmp/xmluxv-idRoot)"

## ora posso selezionare tutti gli ID appartenenti al root
grep "ID=\"$leggoIdRoot" /tmp/xmluxv-css000 | awk '$1 > 0 {print $2}' > /tmp/xmluxv-css01

cat /tmp/xmluxv-css01 | sort > /tmp/xmluxv-css02

cat /tmp/xmluxv-css02 | uniq > /tmp/xmluxv-css03

## tutti i capitoli e sottostanti elementi
grep "\." /tmp/xmluxv-css03 > /tmp/xmluxv-css04

cat /tmp/xmluxv-css04 | sort > /tmp/xmluxv-css05

## solo i capitoli, ossia gli a* senza .
comm -3 /tmp/xmluxv-css03 /tmp/xmluxv-css05 > /tmp/xmluxv-css06

## Nei valori degli elementi non possono esserci caratteri speciali, quali e.g. *, #, &.
# perché grep non leggerebbe la stringa e quindi non producendo file *.dtd, *.css perfetti.

################ INIZIO ROOT 

rm -fr  /tmp/xmluxv-cssRoot

mkdir /tmp/xmluxv-cssRoot

split -l1 /tmp/xmluxv-css01 /tmp/xmluxv-cssRoot/


for c in $(ls /tmp/xmluxv-cssRoot)
do
	leggoC="$(cat /tmp/xmluxv-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxv-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxv-element

	leggoElement="$(cat /tmp/xmluxv-element)"

	cat /tmp/xmluxv-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxv-id0

	cat /tmp/xmluxv-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxv-id

	leggoID="$(cat /tmp/xmluxv-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxv-title

	leggoTitle="$(cat /tmp/xmluxv-title)"

	## Vale solo se ho come ultimo attributo name="", e.g.
	# <gradusI ID="a01" name="I grado Iblocco">GradusI a01

#	grep "ID=\"$leggoID\"" $targetFile.lmx > /tmp/xmluxv-id-line
#
#	cat /tmp/xmluxv-id-line | sed 's/.*name=//g' | sed 's/>.*//g' > /tmp/xmluxv-name
	
	grep "ID=\"$leggoID\"" $targetFile.lmx | grep "name=\"" | sed 's/.*name=//g' | sed 's/>.*//g' > /tmp/xmluxv-name

	stat --format %s /tmp/xmluxv-name > /tmp/xmluxv-nameBytes

	nameBytes=$(cat /tmp/xmluxv-nameBytes)

	if test $nameBytes -gt 0

	then

	leggoName=$(cat /tmp/xmluxv-name)

	echo "$leggoName" >> /tmp/xmluxv-names

	fi

	leggoIdRoot="$(cat /tmp/xmluxv-idRoot)"

	if test $leggoIdRoot == $leggoID

	then
	
	  echo "$leggoID" >> /tmp/xmluxv-allIDs

	  echo "$leggoElement" >> /tmp/xmluxv-allElements

	  echo "$leggoTitle" >> /tmp/xmluxv-allTitles

          echo "$leggoElement $leggoIdRoot" >> /tmp/xmluxv-elementsEtIDs

	  echo "$leggoElement $leggoID $leggoTitle" >> /tmp/xmluxv-elementsEtIDsEtTitles

	  echo "$leggoID $leggoTitle" >> /tmp/xmluxv-IDsEtTitles

	  echo "$leggoElement $leggoTitle" >> /tmp/xmluxv-elementsEtTitles

	  echo "$leggoElement" > /tmp/xmluxv-elementRoot

	  if test $nameBytes -gt 0

	  then
	  
	  echo "$leggoName" >> /tmp/xmluxv-allNames
	  
	  echo "$leggoID $leggoName" >> /tmp/xmluxv-IDsEtNames

	  echo "$leggoElement $leggoID $leggoName" >> /tmp/xmluxv-elementsEtIDsEtNames

	  echo "$leggoElement $leggoID $leggoName $leggoTitle" >> /tmp/xmluxv-elementsEtIDsEtNamesEtTitles

	  echo "$leggoID $leggoName $leggoTitle" >> /tmp/xmluxv-IDsEtNamesEtTitles

	  fi

rm -f /tmp/xmluxv-cssRoot/$c

	fi


done
################ FINE ROOT 

################ INIZIO  ITEM

mkdir /tmp/xmluxv-ITEM

for c in $(ls /tmp/xmluxv-cssRoot)

do
	leggoC="$(cat /tmp/xmluxv-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxv-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxv-element

	leggoElement="$(cat /tmp/xmluxv-element)"

	cat /tmp/xmluxv-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxv-id0

	cat /tmp/xmluxv-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxv-id

	leggoID="$(cat /tmp/xmluxv-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxv-title

	leggoTitle="$(cat /tmp/xmluxv-title)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | grep "name=\"" | sed 's/.*name=//g' | sed 's/>.*//g' > /tmp/xmluxv-name

	stat --format %s /tmp/xmluxv-name > /tmp/xmluxv-nameBytes

	nameBytes=$(cat /tmp/xmluxv-nameBytes)

	if test $nameBytes -gt 0

	then

	leggoName=$(cat /tmp/xmluxv-name)

	echo "$leggoName" >> /tmp/xmluxv-names

	fi

	sed 's/[^.]//g' /tmp/xmluxv-id | awk '{ print length }' > /tmp/xmluxv-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxv-dotFrequency)


	#### ITEM, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

		cp /tmp/xmluxv-cssRoot/$c /tmp/xmluxv-ITEM

		cp /tmp/xmluxv-element /tmp/xmluxv-elementITEM

	  echo "$leggoID" >> /tmp/xmluxv-allIDs

	  echo "$leggoElement" >> /tmp/xmluxv-allElements

	  echo "$leggoTitle" >> /tmp/xmluxv-allTitles

          echo "$leggoElement $leggoID" >> /tmp/xmluxv-elementsEtIDs

	  echo "$leggoElement $leggoID $leggoTitle" >> /tmp/xmluxv-elementsEtIDsEtTitles

	  echo "$leggoID $leggoTitle" >> /tmp/xmluxv-IDsEtTitles

	  echo "$leggoElement $leggoTitle" >> /tmp/xmluxv-elementsEtTitles

	  echo "$leggoElement" > /tmp/xmluxv-elementRoot

	  if test $nameBytes -gt 0

	  then
	  
	  echo "$leggoName" >> /tmp/xmluxv-allNames
	  
	  echo "$leggoID $leggoName" >> /tmp/xmluxv-IDsEtNames

	  echo "$leggoElement $leggoID $leggoName" >> /tmp/xmluxv-elementsEtIDsEtNames

	  echo "$leggoElement $leggoID $leggoName $leggoTitle" >> /tmp/xmluxv-elementsEtIDsEtNamesEtTitles

	  echo "$leggoID $leggoName $leggoTitle" >> /tmp/xmluxv-IDsEtNamesEtTitles

	  fi

rm -f /tmp/xmluxv-cssRoot/$c

	fi


done
################ FINE ITEM

############## INIZIO KEYorVALUE
mkdir /tmp/xmluxv-KEYorVALUE

for c in $(ls /tmp/xmluxv-cssRoot)

do

	leggoC="$(cat /tmp/xmluxv-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxv-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxv-element

	leggoElement="$(cat /tmp/xmluxv-element)"

	cat /tmp/xmluxv-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxv-id0

	cat /tmp/xmluxv-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxv-id
	
	leggoID="$(cat /tmp/xmluxv-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*"//g' | sed 's/>//g' | sed 's/<.*//g' > /tmp/xmluxv-title

	leggoTitle="$(cat /tmp/xmluxv-title)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | grep "name=\"" | sed 's/.*name=//g' | sed 's/>.*//g' > /tmp/xmluxv-name

	stat --format %s /tmp/xmluxv-name > /tmp/xmluxv-nameBytes

	nameBytes=$(cat /tmp/xmluxv-nameBytes)

	if test $nameBytes -gt 0

	then

	leggoName=$(cat /tmp/xmluxv-name)

	echo "$leggoName" >> /tmp/xmluxv-names

	fi

	sed 's/[^.]//g' /tmp/xmluxv-id | awk '{ print length }' > /tmp/xmluxv-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxv-dotFrequency)

	#### GradusII: il KEYorVALUE, insieme a part, non ha mai punti nell'ID; ma ITEM lo risolvo diversamente.

	if test $leggoDotFrequency -eq 1

	then

	  echo "$leggoID" >> /tmp/xmluxv-allIDs

	  echo "$leggoElement" >> /tmp/xmluxv-allElements

	  echo "$leggoTitle" >> /tmp/xmluxv-allTitles

          echo "$leggoElement $leggoID" >> /tmp/xmluxv-elementsEtIDs

	  echo "$leggoElement $leggoID $leggoTitle" >> /tmp/xmluxv-elementsEtIDsEtTitles

	  echo "$leggoID $leggoTitle" >> /tmp/xmluxv-IDsEtTitles

	  echo "$leggoElement $leggoTitle" >> /tmp/xmluxv-elementsEtTitles

	  echo "$leggoElement" > /tmp/xmluxv-elementRoot

	  if test $nameBytes -gt 0

	  then
	  
	  echo "$leggoName" >> /tmp/xmluxv-allNames
	  
	  echo "$leggoID $leggoName" >> /tmp/xmluxv-IDsEtNames

	  echo "$leggoElement $leggoID $leggoName" >> /tmp/xmluxv-elementsEtIDsEtNames

	  echo "$leggoElement $leggoID $leggoName $leggoTitle" >> /tmp/xmluxv-elementsEtIDsEtNamesEtTitles

	  echo "$leggoID $leggoName $leggoTitle" >> /tmp/xmluxv-IDsEtNamesEtTitles

	  fi

cp /tmp/xmluxv-cssRoot/$c /tmp/xmluxv-KEYorVALUE

cp /tmp/xmluxv-element /tmp/xmluxv-elementKEYorVALUE

rm -f /tmp/xmluxv-cssRoot/$c

	fi
	
done
################ FINE KEYorVALUE 

rm -f $targetFile.lmxv

touch $targetFile.lmxv

##################################### non nella struttura familiare (NOT KIN)
rm -fr $targetFile-lmxv_backup

cp -r $targetFile-lmxv $targetFile-lmxv_backup 2> /dev/null

rm -fr $targetFile-lmxv

mkdir $targetFile-lmxv

mkdir $targetFile-lmxv/notKin

cd $targetFile-lmxv/notKin

## full: $targetFile-full.lmxv

echo " " >> $targetFile-notKin_full.lmxv

echo "NOT KIN" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) IDs tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-allIDs)" >> $targetFile-notKin_full.lmxv

echo "end IDs tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!--(not kin) Elements tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-allElements)" >> $targetFile-notKin_full.lmxv

echo "end elements tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) Titles tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-allTitles)" >> $targetFile-notKin_full.lmxv

echo "end titles tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) IDs and elements tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDs)" >> $targetFile-notKin_full.lmxv

echo "end IDs and elements tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) IDs and titles tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtTitles)" >> $targetFile-notKin_full.lmxv

echo "end IDs and titles tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) Elements and titles tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-elementsEtTitles)" >> $targetFile-notKin_full.lmxv

echo "end elements and titles tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) Elements, IDs and titles tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDsEtTitles)" >> $targetFile-notKin_full.lmxv

echo "end elements, IDs and titles tree (not kin) -->" >> $targetFile-notKin_full.lmxv


if [ -f /tmp/xmluxv-names ]; then

echo " " >> $targetFile-notKin_full.lmxv

echo "<!--(not kin) Names tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-allNames)" >> $targetFile-notKin_full.lmxv

echo "end names tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) IDs and names tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNames)" >> $targetFile-notKin_full.lmxv

echo "end IDs and names tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) Elements, IDs and names tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDsEtNames)" >> $targetFile-notKin_full.lmxv

echo "end Elements, IDs and names tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) Elements, IDs, names and titles tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDsEtNamesEtTitles)" >> $targetFile-notKin_full.lmxv

echo "end Elements, IDs, names and titles tree (not kin) -->" >> $targetFile-notKin_full.lmxv


echo " " >> $targetFile-notKin_full.lmxv

echo "<!-- (not kin) IDs, names and titles tree" >> $targetFile-notKin_full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNamesEtTitles)" >> $targetFile-notKin_full.lmxv

echo "end IDs, names and titles tree (not kin) -->" >> $targetFile-notKin_full.lmxv

fi

cp $targetFile-notKin_full.lmxv $posnow/$targetFile.lmxv


## parziali: $targetFile.lmxv

echo "<!-- (not kin) IDs tree" >> $targetFile-notKin_ids.lmxv

echo "$(cat /tmp/xmluxv-allIDs)" >> $targetFile-notKin_ids.lmxv

echo "end IDs tree (not kin) -->" >> $targetFile-notKin_ids.lmxv


echo "<!--(not kin) Elements tree" >> $targetFile-notKin_elements.lmxv

echo "$(cat /tmp/xmluxv-allElements)" >> $targetFile-notKin_elements.lmxv

echo "end elements tree (not kin) -->" >> $targetFile-notKin_elements.lmxv


echo "<!-- (not kin) Titles tree" >> $targetFile-notKin_titles.lmxv

echo "$(cat /tmp/xmluxv-allTitles)" >> $targetFile-notKin_titles.lmxv

echo "end titles tree (not kin) -->" >> $targetFile-notKin_titles.lmxv


echo "<!-- (not kin) Elements and IDs tree" >> $targetFile-notKin_elements-ids.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDs)" >> $targetFile-notKin_elements-ids.lmxv

echo "end elements and IDs tree (not kin) -->" >> $targetFile-notKin_elements-ids.lmxv


echo "<!-- (not kin) IDs and titles tree" >> $targetFile-notKin_ids-titles.lmxv

echo "$(cat /tmp/xmluxv-IDsEtTitles)" >> $targetFile-notKin_ids-titles.lmxv

echo "end IDs and titles tree (not kin) -->" >> $targetFile-notKin_ids-titles.lmxv


echo "<!-- (not kin) Elements and titles tree" >> $targetFile-notKin_elements-titles.lmxv

echo "$(cat /tmp/xmluxv-elementsEtTitles)" >> $targetFile-notKin_elements-titles.lmxv

echo "end elements and titles tree (not kin) -->" >> $targetFile-notKin_elements-titles.lmxv


echo "<!-- (not kin) Elements, IDs and titles tree" >> $targetFile-notKin_elements-ids-titles.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDsEtTitles)" >> $targetFile-notKin_elements-ids-titles.lmxv

echo "end elements, IDs and titles tree (not kin) -->" >> $targetFile-notKin_elements-ids-titles.lmxv


if [ -f /tmp/xmluxv-names ]; then

echo "<!--(not kin) Names tree" >> $targetFile-notKin_names.lmxv

echo "$(cat /tmp/xmluxv-allNames)" >> $targetFile-notKin_names.lmxv

echo "end names tree (not kin) -->" >> $targetFile-notKin_names.lmxv


echo "<!-- (not kin) IDs and names tree" >> $targetFile-notKin_ids-names.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNames)" >> $targetFile-notKin_ids-names.lmxv

echo "end IDs and names tree (not kin) -->" >> $targetFile-notKin_ids-names.lmxv


echo "<!-- (not kin) Elements, IDs and names tree" >> $targetFile-notKin_elements-ids-names.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDsEtNames)" >> $targetFile-notKin_elements-ids-names.lmxv

echo "end Elements, IDs and names tree (not kin) -->" >> $targetFile-notKin_elements-ids-names.lmxv


echo "<!-- (not kin) Elements, IDs, names and titles tree" >> $targetFile-notKin_elements-ids-names-titles.lmxv

echo "$(cat /tmp/xmluxv-elementsEtIDsEtNamesEtTitles)" >> $targetFile-notKin_elements-ids-names-titles.lmxv

echo "end Elements, IDs, names and titles tree (not kin) -->" >> $targetFile-notKin_elements-ids-names-titles.lmxv


echo "<!-- (not kin) IDs, names and titles tree" >> $targetFile-notKin_ids-names-titles.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNamesEtTitles)" >> $targetFile-notKin_ids-names-titles.lmxv

echo "end IDs, names and titles tree (not kin) -->" >> $targetFile-notKin_ids-names-titles.lmxv

fi

cd $posnow



##################################### secondo la struttura familiare (KIN)

cat /tmp/xmluxv-allIDs | sort > /tmp/xmluxv-allIDsRec

mkdir /tmp/xmluxv-allIDsRecSplit

split -l1 /tmp/xmluxv-allIDsRec /tmp/xmluxv-allIDsRecSplit/

for a in $(ls /tmp/xmluxv-allIDsRecSplit/)

do

leggoIDRec="$(cat /tmp/xmluxv-allIDsRecSplit/$a)"

echo $leggoIDRec > /tmp/xmluxv-allIDRec

## lascia lo spazio dopo ^$leggoIDRec, è voluto.
grep "^$leggoIDRec " /tmp/xmluxv-IDsEtTitles | awk '{for(i=2;i<=NF;i++) print " " $i}' | tr -d '\n' | sed 's/^.//g' > /tmp/xmluxv-titleRecB00

leggoTitle00="$(cat /tmp/xmluxv-titleRecB00)"

## Mi serve echo perché mi dà un "carriage return"
echo "$leggoTitle00" > /tmp/xmluxv-titleRecB

cat /tmp/xmluxv-titleRecB >> /tmp/xmluxv-allTitlesRec

leggoTitleRecB="$(cat /tmp/xmluxv-titleRecB)"



if [ -f /tmp/xmluxv-names ]; then

## lascia lo spazio dopo ^$leggoIDRec, è voluto.
grep "^$leggoIDRec " /tmp/xmluxv-IDsEtNames | awk '{for(i=2;i<=NF;i++) print " " $i}' | tr -d '\n' | sed 's/^.//g' > /tmp/xmluxv-nameRecB00

leggoName00="$(cat /tmp/xmluxv-nameRecB00)"

## Mi serve echo perché mi dà un "carriage return"
echo "$leggoName00" > /tmp/xmluxv-nameRecB

cat /tmp/xmluxv-nameRecB >> /tmp/xmluxv-allNamesRec

leggoNameRecB="$(cat /tmp/xmluxv-nameRecB)"
	
fi

## lascia lo spazio prima e dopo ^$leggoIDRec, è voluto.
grep " $leggoIDRec " /tmp/xmluxv-elementsEtIDsEtTitles | awk '$1 > 0 {print $1}' > /tmp/xmluxv-elementsRecB

cat /tmp/xmluxv-elementsRecB >> /tmp/xmluxv-allElementsRec

leggoAllElementsRecB="$(cat /tmp/xmluxv-elementsRecB)"


echo "$leggoIDRec $leggoAllElementsRecB $leggoTitleRecB" >> /tmp/xmluxv-IDsEtElementsEtTitlesRec

echo "$leggoIDRec $leggoTitleRecB" >> /tmp/xmluxv-IDsEtTitlesRec

echo "$leggoAllElementsRecB  $leggoTitleRecB" >> /tmp/xmluxv-elementsEtTitlesRec

echo "$leggoIDRec $leggoAllElementsRecB" >> /tmp/xmluxv-IDsEtElementsRec

if [ -f /tmp/xmluxv-names ]; then

echo "$leggoIDRec $leggoNameRecB" >> /tmp/xmluxv-IDsEtNamesRec

echo "$leggoIDRec $leggoNameRecB $leggoTitleRecB" >> /tmp/xmluxv-IDsEtNamesEtTitlesRec

echo "$leggoIDRec $leggoAllElementsRecB $leggoNameRecB" >> /tmp/xmluxv-IDsEtElementsEtNamesRec

echo "$leggoIDRec $leggoAllElementsRecB $leggoNameRecB $leggoTitleRecB" >> /tmp/xmluxv-IDsEtElementsEtNamesEtTitlesRec

fi

done

### KIN full
mkdir $targetFile-lmxv/kin

cd $targetFile-lmxv/kin


echo "KIN" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-allIDsRec)" >> $targetFile-full.lmxv

echo "end IDs tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv
 
echo "<!-- Elements tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-allElementsRec)" >> $targetFile-full.lmxv

echo "end elements tree -->" >> $targetFile-full.lmxv



echo " " >> $targetFile-full.lmxv

echo "<!-- Titles tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-allTitlesRec)" >> $targetFile-full.lmxv

echo "end titles tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs and elements tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsRec)" >> $targetFile-full.lmxv

echo "end IDs and elements tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs and titles tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtTitlesRec)" >> $targetFile-full.lmxv

echo "end IDs and titles tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- Elements and titles tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-elementsEtTitlesRec)" >> $targetFile-full.lmxv

echo "end elements and titles tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs, elements and titles tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsEtTitlesRec)" >> $targetFile-full.lmxv

echo "end IDs, elements and titles tree -->" >> $targetFile-full.lmxv


if [ -f /tmp/xmluxv-names ]; then

echo " " >> $targetFile-full.lmxv

echo "<!-- Names tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-allNamesRec)" >> $targetFile-full.lmxv

echo "end names tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs and names tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNamesRec)" >> $targetFile-full.lmxv

echo "end IDs and names tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs, elements and names tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsEtNamesRec)" >> $targetFile-full.lmxv

echo "end IDs, elements and names tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs, elements, names and titles tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsEtNamesEtTitlesRec)" >> $targetFile-full.lmxv

echo "end IDs, elements, names and titles tree -->" >> $targetFile-full.lmxv


echo " " >> $targetFile-full.lmxv

echo "<!-- IDs, names and titles tree" >> $targetFile-full.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNamesEtTitlesRec)" >> $targetFile-full.lmxv

echo "end IDs, names and titles tree -->" >> $targetFile-full.lmxv

fi

echo " " >> $targetFile-full.lmxv

echo " " >> $posnow/$targetFile.lmxv
echo " " >> $posnow/$targetFile.lmxv
echo " " >> $posnow/$targetFile.lmxv
echo " " >> $posnow/$targetFile.lmxv

cat $targetFile-full.lmxv >> $posnow/$targetFile.lmxv


## KIN parziali

echo "<!-- IDs tree" >> $targetFile-ids.lmxv

echo "$(cat /tmp/xmluxv-allIDsRec)" >> $targetFile-ids.lmxv

echo "end IDs tree -->" >> $targetFile-ids.lmxv

 
echo "<!-- Elements tree" >> $targetFile-elements.lmxv

echo "$(cat /tmp/xmluxv-allElementsRec)" >> $targetFile-elements.lmxv

echo "end elements tree -->" >> $targetFile-elements.lmxv


echo "<!-- Titles tree" >> $targetFile-titles.lmxv

echo "$(cat /tmp/xmluxv-allTitlesRec)" >> $targetFile-titles.lmxv

echo "end titles tree -->" >> $targetFile-titles.lmxv


echo "<!-- IDs and elements tree" >> $targetFile-ids-elements.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsRec)" >> $targetFile-ids-elements.lmxv

echo "end IDs and elements tree -->" >> $targetFile-ids-elements.lmxv


echo "<!-- IDs and titles tree" >> $targetFile-ids-titles.lmxv

echo "$(cat /tmp/xmluxv-IDsEtTitlesRec)" >> $targetFile-ids-titles.lmxv

echo "end IDs and titles tree -->" >> $targetFile-ids-titles.lmxv


echo "<!-- Elements and titles tree" >> $targetFile-elements-titles.lmxv

echo "$(cat /tmp/xmluxv-elementsEtTitlesRec)" >> $targetFile-elements-titles.lmxv

echo "end elements and titles tree -->" >> $targetFile-elements-titles.lmxv


echo "<!-- IDs, elements and titles tree" >> $targetFile-ids-elements-titles.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsEtTitlesRec)" >> $targetFile-ids-elements-titles.lmxv

echo "end IDs, elements and titles tree -->" >> $targetFile-ids-elements-titles.lmxv


if [ -f /tmp/xmluxv-names ]; then

echo "<!-- Names tree" >> $targetFile-names.lmxv

echo "$(cat /tmp/xmluxv-allNamesRec)" >> $targetFile-names.lmxv

echo "end names tree -->" >> $targetFile-names.lmxv


echo "<!-- IDs and names tree" >> $targetFile-ids-names.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNamesRec)" >> $targetFile-ids-names.lmxv

echo "end IDs and names tree -->" >> $targetFile-ids-names.lmxv


echo "<!-- IDs, elements and names tree" >> $targetFile-ids-elements-names.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsEtNamesRec)" >> $targetFile-ids-elements-names.lmxv

echo "end IDs, elements and names tree -->" >> $targetFile-ids-elements-names.lmxv


echo "<!-- IDs, elements, names and titles tree" >> $targetFile-ids-elements-names-titles.lmxv

echo "$(cat /tmp/xmluxv-IDsEtElementsEtNamesEtTitlesRec)" >> $targetFile-ids-elements-names-titles.lmxv

echo "end IDs, elements, names and titles tree -->" >> $targetFile-ids-elements-names-titles.lmxv


echo "<!-- IDs, names and titles tree" >> $targetFile-ids-names-titles.lmxv

echo "$(cat /tmp/xmluxv-IDsEtNamesEtTitlesRec)" >> $targetFile-ids-names-titles.lmxv

echo "end IDs, names and titles tree -->" >> $targetFile-ids-names-titles.lmxv

fi


cd $posnow

############################# opzioni

for opzioni in {1}

do

grep "^-id$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi



grep "^-e$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- Elements tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end elements tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- Elements tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi

grep "^-t$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- Titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- Titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi

grep "^-ie$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs and elements tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs and elements tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs and elements tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi


grep "^-it$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs and titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs and titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs and titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi


grep "^-et$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- Elements and titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end elements and titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- Elements and titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi



grep "^-iet$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs, elements and titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs, elements and titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs, elements and titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi


grep "^-all$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then

if [ -f /tmp/xmluxv-names ]; then

	grep -n "<!-- IDs, elements, names and titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs, elements, names and titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs, elements, names and titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

else

	grep -n "<!-- IDs, elements and titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs, elements and titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs, elements and titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

fi

## /tmp/xmluxev-blockToView serve agli script esterni
cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi


if [ -f /tmp/xmluxv-names ]; then

grep "^-n$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- Names tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end names tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- Names tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi

grep "^-in$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs and names tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs and names tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs and names tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi

grep "^-ien$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs, elements and names tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs, elements and names tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs, elements and names tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi

grep "^-int$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then
	grep -n "<!-- IDs, names and titles tree"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineBegin

	begin=$(cat /tmp/xmluxv-nLineBegin)

	grep -n "end IDs, names and titles tree -->"  $targetFile.lmxv | cut -d: -f1,1 > /tmp/xmluxv-nLineEnd

	end=$(cat /tmp/xmluxv-nLineEnd)

	blocco=$(($end - $begin))

grep -A $blocco "<!-- IDs, names and titles tree" $targetFile.lmxv > /tmp/xmluxv-blockToView

cp /tmp/xmluxv-blockToView /tmp/xmluxev-blockToView

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckS

stat --format %s /tmp/xmluxv-optionCheckS > /tmp/xmluxv-optionCheckSBytes

leggoBytesOptionCheckS=$(cat /tmp/xmluxv-optionCheckSBytes)

if test ! $leggoBytesOptionCheckS -gt 0

then

gview -f -geometry 70x70 /tmp/xmluxv-blockToView

fi

break

fi

fi

done

for optionFind in {1}

do

grep "^--find-name=" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then

	cat /tmp/xmluxv-optionCheck | sed 's/--find-name=//g' | cut -d: -f2,2 > /tmp/xmluxv-chiaveFindName

	chiaveFindName=$(cat /tmp/xmluxv-chiaveFindName)

	grep "\"$chiaveFindName\"" -r $targetFile-lmxv/kin | sed '/'$targetFile'-full.lmxv/d' > $targetFile-lmxv/$targetFile-lmxv_find.txt

	cp $targetFile-lmxv/$targetFile-lmxv_find.txt $targetFile-lmxv/$targetFile-lmxv_find-paths.txt
	
	echo " "
	echo " "

# per l'output senza prova-lmxv/kin/ devo seguire una procedura più lunga,
# perché se avessi una / all'interno del nome o del titolo, verrebbe eliminata
#	cat $targetFile-lmxv_find.txt | cut -d/ -f3,2
vim -c ":%s/\// dirin /" $targetFile-lmxv/$targetFile-lmxv_find.txt -c :w -c :q

cat $targetFile-lmxv/$targetFile-lmxv_find.txt | sed 's/.*dirin//g' > /tmp/xmluxv-findLessDirin

vim -c ":%s/ //" /tmp/xmluxv-findLessDirin -c :w -c :q

vim -c ":%s/\// dirin /" /tmp/xmluxv-findLessDirin -c :w -c :q

cat /tmp/xmluxv-findLessDirin | sed 's/.*dirin//g' > /tmp/xmluxv-findLessDirin02

vim -c ":%s/ //" /tmp/xmluxv-findLessDirin02 -c :w -c :q

cp /tmp/xmluxv-findLessDirin02 $targetFile-lmxv/$targetFile-lmxv_find.txt

## Sostituisco <:> con < : > in modo da separare il percorso (a sx) dal contenuto (a dx)
## non inserendo <g> alla fine del comando, evidenzio solo i primi <:>; in questo modo non vengono
## evidenziati eventuali <:> all'interno di names o di titoli.
vim -c ":%s/:/ : /" $targetFile-lmxv/$targetFile-lmxv_find.txt -c :w -c :q

## evidenzio con il verde su nero, i <:>, in modo da separare il percorso (a sx) dal contenuto (a dx)
## non inserendo <g> alla fine del comando, evidenzio solo i primi <:>; in questo modo non vengono
## evidenziati eventuali <:> all'interno di names o di titoli.
cp $targetFile-lmxv/$targetFile-lmxv_find.txt $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt

vim -c ":%s/:/\\\033\[32;40;5m\\\033\[1m:\\\033\[0m/" $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt -c :w -c :q

## Esegue lo stesso discorso, ma con viola su nero, per mettere a sx il nome del file
vim -c ":%s/-/\\\033\[35;40;5m\\\033\[1m-\\\033\[0m" $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt -c :w -c :q


grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckSilent

stat --format %s /tmp/xmluxv-optionCheckSilent > /tmp/xmluxv-optionCheckBytesSilent

leggoBytesOptionCheckSilent=$(cat /tmp/xmluxv-optionCheckBytesSilent)

if ! test $leggoBytesOptionCheckSilent -gt 0

then

echo -e "$(cat $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt)"
echo " "
echo " "
echo "--find-name=\"$chiaveFindName\"
printed on 
$targetFile-lmxv/$targetFile-lmxv_find.txt
	
and with coloured <:> separator on
$targetFile-lmxv/$targetFile-lmxv_find-coloured.txt
to print executing:
echo -e \"\$(cat $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt)\"

You have 
$targetFile-lmxv/$targetFile-lmxv_find-paths.txt
too.
"

fi
	break
fi

grep "^--find-id=" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then

	cat /tmp/xmluxv-optionCheck | sed 's/--find-id=//g' | cut -d: -f2,2 > /tmp/xmluxv-chiaveFindId

	chiaveFindId=$(cat /tmp/xmluxv-chiaveFindId)

	grep "$chiaveFindId$" -r $targetFile-lmxv/kin | sed '/'$targetFile'-full.lmxv/d' > $targetFile-lmxv/$targetFile-lmxv_find.txt

	cp $targetFile-lmxv/$targetFile-lmxv_find.txt $targetFile-lmxv/$targetFile-lmxv_find-paths.txt
	
	echo " "
	echo " "
	
# per l'output senza prova-lmxv/kin/ devo seguire una procedura più lunga,
# perché se avessi una / all'interno del nome o del titolo, verrebbe eliminata
#	cat $targetFile-lmxv_find.txt | cut -d/ -f3,2
vim -c ":%s/\// dirin /" $targetFile-lmxv/$targetFile-lmxv_find.txt -c :w -c :q

cat $targetFile-lmxv/$targetFile-lmxv_find.txt | sed 's/.*dirin//g' > /tmp/xmluxv-findLessDirin

vim -c ":%s/ //" /tmp/xmluxv-findLessDirin -c :w -c :q

vim -c ":%s/\// dirin /" /tmp/xmluxv-findLessDirin -c :w -c :q

cat /tmp/xmluxv-findLessDirin | sed 's/.*dirin//g' > /tmp/xmluxv-findLessDirin02

vim -c ":%s/ //" /tmp/xmluxv-findLessDirin02 -c :w -c :q

cp /tmp/xmluxv-findLessDirin02 $targetFile-lmxv/$targetFile-lmxv_find.txt

## Sostituisco <:> con < : > in modo da separare il percorso (a sx) dal contenuto (a dx)
## non inserendo <g> alla fine del comando, evidenzio solo i primi <:>; in questo modo non vengono
## evidenziati eventuali <:> all'interno di ids o di titoli.
vim -c ":%s/:/ : /" $targetFile-lmxv/$targetFile-lmxv_find.txt -c :w -c :q

## evidenzio con il verde su nero, i <:>, in modo da separare il percorso (a sx) dal contenuto (a dx)
## non inserendo <g> alla fine del comando, evidenzio solo i primi <:>; in questo modo non vengono
## evidenziati eventuali <:> all'interno di ids o di titoli.
cp $targetFile-lmxv/$targetFile-lmxv_find.txt $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt

vim -c ":%s/:/\\\033\[32;40;5m\\\033\[1m:\\\033\[0m/" $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt -c :w -c :q

## Esegue lo stesso discorso, ma con il viola su nero, per mettere a sx il nome del file
vim -c ":%s/-/\\\033\[35;40;5m\\\033\[1m-\\\033\[0m" $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt -c :w -c :q

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckSilent

stat --format %s /tmp/xmluxv-optionCheckSilent > /tmp/xmluxv-optionCheckBytesSilent

leggoBytesOptionCheckSilent=$(cat /tmp/xmluxv-optionCheckBytesSilent)

if ! test $leggoBytesOptionCheckSilent -gt 0

then

echo -e "$(cat $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt)"
echo " "
echo " "
echo "--find-id=\"$chiaveFindId\"
printed on 
$targetFile-lmxv/$targetFile-lmxv_find.txt
	
and with coloured <:> separator on
$targetFile-lmxv/$targetFile-lmxv_find-coloured.txt
to print executing:
echo -e \"\$(cat $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt)\"

You have 
$targetFile-lmxv/$targetFile-lmxv_find-paths.txt
too.
"

	break

fi

fi


grep "^--find-title=" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheck

stat --format %s /tmp/xmluxv-optionCheck > /tmp/xmluxv-optionCheckBytes

leggoBytesOptionCheck=$(cat /tmp/xmluxv-optionCheckBytes)

if test $leggoBytesOptionCheck -gt 0

then

	cat /tmp/xmluxv-optionCheck | sed 's/--find-title=//g' | cut -d: -f2,2 > /tmp/xmluxv-chiaveFindTitle

	chiaveFindTitle=$(cat /tmp/xmluxv-chiaveFindTitle)

	grep "$chiaveFindTitle" -r $targetFile-lmxv/kin | sed '/'$targetFile'-full.lmxv/d' > $targetFile-lmxv/$targetFile-lmxv_find.txt

	cp $targetFile-lmxv/$targetFile-lmxv_find.txt $targetFile-lmxv/$targetFile-lmxv_find-paths.txt
	
	echo " "
	echo " "
	
# per l'output senza prova-lmxv/kin/ devo seguire una procedura più lunga,
# perché se avessi una / all'interno del nome o del titolo, verrebbe eliminata
#	cat $targetFile-lmxv_find.txt | cut -d/ -f3,2
vim -c ":%s/\// dirin /" $targetFile-lmxv/$targetFile-lmxv_find.txt -c :w -c :q

cat $targetFile-lmxv/$targetFile-lmxv_find.txt | sed 's/.*dirin//g' > /tmp/xmluxv-findLessDirin

vim -c ":%s/ //" /tmp/xmluxv-findLessDirin -c :w -c :q

vim -c ":%s/\// dirin /" /tmp/xmluxv-findLessDirin -c :w -c :q

cat /tmp/xmluxv-findLessDirin | sed 's/.*dirin//g' > /tmp/xmluxv-findLessDirin02

vim -c ":%s/ //" /tmp/xmluxv-findLessDirin02 -c :w -c :q

cp /tmp/xmluxv-findLessDirin02 $targetFile-lmxv/$targetFile-lmxv_find.txt

## Sostituisco <:> con < : > in modo da separare il percorso (a sx) dal contenuto (a dx)
## non inserendo <g> alla fine del comando, evtitleenzio solo i primi <:>; in questo modo non vengono
## evtitleenziati eventuali <:> all'interno di titles o di titoli.
vim -c ":%s/:/ : /" $targetFile-lmxv/$targetFile-lmxv_find.txt -c :w -c :q

## evtitleenzio con il verde su nero, i <:>, in modo da separare il percorso (a sx) dal contenuto (a dx)
## non inserendo <g> alla fine del comando, evtitleenzio solo i primi <:>; in questo modo non vengono
## evtitleenziati eventuali <:> all'interno di titles o di titoli.
cp $targetFile-lmxv/$targetFile-lmxv_find.txt $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt

vim -c ":%s/:/\\\033\[32;40;5m\\\033\[1m:\\\033\[0m/" $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt -c :w -c :q

## Esegue lo stesso discorso, ma con il viola su nero, per mettere a sx il nome del file
vim -c ":%s/-/\\\033\[35;40;5m\\\033\[1m-\\\033\[0m" $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt -c :w -c :q

grep "^-s$" /tmp/xmluxvPseudoOptions/* > /tmp/xmluxv-optionCheckSilent

stat --format %s /tmp/xmluxv-optionCheckSilent > /tmp/xmluxv-optionCheckBytesSilent

leggoBytesOptionCheckSilent=$(cat /tmp/xmluxv-optionCheckBytesSilent)

if ! test $leggoBytesOptionCheckSilent -gt 0

then

echo -e "$(cat $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt)"
echo " "
echo " "
echo "--find-title=\"$chiaveFindTitle\"
printed on 
$targetFile-lmxv/$targetFile-lmxv_find.txt
	
and with coloured <:> separator on
$targetFile-lmxv/$targetFile-lmxv_find-coloured.txt
to print executing:
echo -e \"\$(cat $targetFile-lmxv/$targetFile-lmxv_find-coloured.txt)\"

You have 
$targetFile-lmxv/$targetFile-lmxv_find-paths.txt
too.
"

	break
fi

fi

done

rm -rf /tmp/xmluxv*

exit

