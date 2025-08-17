#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

######### Select id block in write mode

grep "^--selectW-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW

stat --format %s /tmp/xmluxe-actionSelectW > /tmp/xmluxe-actionSelectWBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectWBytes)

if test $leggoBytes -gt 0

then

	cat /tmp/xmluxe-actionSelectW | sed 's/.*=//g' > /tmp/xmluxe-idToSelectW

	idToSelectW="$(cat /tmp/xmluxe-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xmluxe-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWEndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xmluxe-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xmluxe-linesToSelect

linesToSelectW=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

### inizio modifica rispetto a remove
cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectWPlus=$(($linesToSelectW + 1))

echo  "$linesToSelectWPlus GdG
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



######### Select name block in write mode
grep "^--selectW-name=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW-name

stat --format %s /tmp/xmluxe-actionSelectW-name > /tmp/xmluxe-actionSelectW-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectW-nameBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectW-name | sed 's/.*=//g' > /tmp/xmluxe-idToSelectW-name
	nameToSelect=$(cat /tmp/xmluxe-idToSelectW-name)

/usr/local/bin/xmluxv --find-name="$nameToSelect" --f=$targetFile

grep "\"$nameToSelect\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToSelectW

idToSelectW="$(cat /tmp/xmluxe-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xmluxe-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWEndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xmluxe-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xmluxe-linesToSelect

linesToSelectW=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
## Modifica 2024.09.24

#echo  "$linesToSelectW GdG
#ZZ

#" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato

linesToSelectWPlus=$(($linesToSelectW + 1))

echo  "$linesToSelectWPlus GdG
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
$(date +"%Y-%m-%d-%H-%M")	ID=$idToSelectW alias name=$nameToSelect selected in write mode" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe


fi



######### Select title block in read-only mode
grep "^--selectW-title=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW-title

stat --format %s /tmp/xmluxe-actionSelectW-title > /tmp/xmluxe-actionSelectW-titleBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectW-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectW-title | sed 's/.*=//g' > /tmp/xmluxe-idToSelectW-title
	titleToSelect=$(cat /tmp/xmluxe-idToSelectW-title)

/usr/local/bin/xmluxv --find-title="$titleToSelect" --f=$targetFile

grep "$titleToSelect$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToSelectW

idToSelectW="$(cat /tmp/xmluxe-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xmluxe-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectWEndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xmluxe-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xmluxe-linesToSelect

linesToSelectW=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectWPlus=$(($linesToSelectW + 1))

echo  "$linesToSelectWPlus GdG
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
$(date +"%Y-%m-%d-%H-%M")	ID=$idToSelectW alias title=$titleToSelect selected in write mode" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe


fi

exit

