#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

######### Select id block in read-only mode
grep "^--selectR-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR

stat --format %s /tmp/xmluxe-actionSelectR > /tmp/xmluxe-actionSelectRBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectR | sed 's/.*=//g' > /tmp/xmluxe-idToSelectR
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
linesToSelectRPlus=$(($linesToSelectR + 1))

echo  "$linesToSelectRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

gview -f /tmp/xmluxe-bloccoSelezionato.lmx


	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToSelectR selected in read-only mode" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe


fi






######### Select name block in read-only mode
grep "^--selectR-name=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR-name

stat --format %s /tmp/xmluxe-actionSelectR-name > /tmp/xmluxe-actionSelectR-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectR-nameBytes)

if test $leggoBytes -gt 0

then
	cat  /tmp/xmluxe-actionSelectR-name | sed 's/.*=//g' > /tmp/xmluxe-idToSelectR-name
	nameToSelect=$(cat /tmp/xmluxe-idToSelectR-name)

/usr/local/bin/xmluxv --find-name="$nameToSelect" --f=$targetFile

grep "\"$nameToSelect\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToSelectR

idToSelectR="$(cat /tmp/xmluxe-idToSelectR)"

grep -n "ID=\"$idToSelectR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectRBeginLine

nLineBeginIdToSelectR=$(cat /tmp/xmluxe-idToSelectRBeginLine)

grep -n "<!-- end $idToSelectR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectR=$(cat /tmp/xmluxe-idToSelectREndLine)

echo $nLineEndIdToSelectR - $nLineBeginIdToSelectR | bc > /tmp/xmluxe-linesToSelect

linesToSelectR=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectRPlusComment=$(($linesToSelectR + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectRPlus=$(($linesToSelectR + 1))

echo  "$linesToSelectRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato

vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

gview -f /tmp/xmluxe-bloccoSelezionato.lmx

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToSelectR alias name=$nameToSelect selected in read-only mode" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

fi





######### Select title block in read-only mode
grep "^--selectR-title=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR-title

stat --format %s /tmp/xmluxe-actionSelectR-title > /tmp/xmluxe-actionSelectR-titleBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionSelectR-title | sed 's/.*=//g' > /tmp/xmluxe-idToSelectR-title
	titleToSelect=$(cat /tmp/xmluxe-idToSelectR-title)

/usr/local/bin/xmluxv --find-title="$titleToSelect" --f=$targetFile

grep "$titleToSelect$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToSelectR

idToSelectR="$(cat /tmp/xmluxe-idToSelectR)"

grep -n "ID=\"$idToSelectR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectRBeginLine

nLineBeginIdToSelectR=$(cat /tmp/xmluxe-idToSelectRBeginLine)

grep -n "<!-- end $idToSelectR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToSelectREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectR=$(cat /tmp/xmluxe-idToSelectREndLine)

echo $nLineEndIdToSelectR - $nLineBeginIdToSelectR | bc > /tmp/xmluxe-linesToSelect

linesToSelectR=$(cat /tmp/xmluxe-linesToSelect)

linesToSelectRPlusComment=$(($linesToSelectR + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectRPlus=$(($linesToSelectR + 1))

echo  "$linesToSelectRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato

vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

gview -f /tmp/xmluxe-bloccoSelezionato.lmx

echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToSelectR alias title=$titleToSelect selected in read-only mode" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

fi

exit

