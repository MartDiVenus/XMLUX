#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

######### Parse name block
grep "^--parse-name=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-name

stat --format %s /tmp/xmluxe-actionParseR-name > /tmp/xmluxe-actionParseR-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionParseR-nameBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionParseR-name | sed 's/.*=//g' > /tmp/xmluxe-idToParseR-name

	nameToParse=$(cat /tmp/xmluxe-idToParseR-name)

/usr/local/bin/xmluxv -s --find-name="$nameToParse" --f=$targetFile

grep "\"$nameToParse\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToParseR

idToParseR="$(cat /tmp/xmluxe-idToParseR)"

grep -n "ID=\"$idToParseR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseRBeginLine

nLineBeginIdToParseR=$(cat /tmp/xmluxe-idToParseRBeginLine)

grep -n "<!-- end $idToParseR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xmluxe-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xmluxe-linesToParse

linesToParseR=$(cat /tmp/xmluxe-linesToParse)

linesToParseRPlusComment=$(($linesToParseR + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToParseRPlus=$(($linesToParseR + 1))

echo  "$linesToParseRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#gview -f /tmp/xmluxe-bloccoSelezionato.lmx

cat /tmp/xmluxe-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xmluxe

echo ""
echo ""
echo "Following stdout is about parsing of 
xmluxe --parse-name=$nameToParse --f=$targetFile
you have extracted content on /tmp/parsed-xmluxe"
echo ""
echo ""

cat /tmp/parsed-xmluxe


fi





######### Parse title block
grep "^--parse-title=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-title

stat --format %s /tmp/xmluxe-actionParseR-title > /tmp/xmluxe-actionParseR-titleBytes

leggoBytes=$(cat /tmp/xmluxe-actionParseR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionParseR-title | sed 's/.*=//g' > /tmp/xmluxe-idToParseR-title

	titleToParse=$(cat /tmp/xmluxe-idToParseR-title)

/usr/local/bin/xmluxv -s --find-title="$titleToParse" --f=$targetFile

grep "$titleToParse$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToParseR

idToParseR="$(cat /tmp/xmluxe-idToParseR)"

grep -n "ID=\"$idToParseR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseRBeginLine

nLineBeginIdToParseR=$(cat /tmp/xmluxe-idToParseRBeginLine)

grep -n "<!-- end $idToParseR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xmluxe-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xmluxe-linesToParse

linesToParseR=$(cat /tmp/xmluxe-linesToParse)

linesToParseRPlusComment=$(($linesToParseR + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToParseRPlus=$(($linesToParseR + 1))

echo  "$linesToParseRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#gview -f /tmp/xmluxe-bloccoSelezionato.lmx

cat /tmp/xmluxe-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xmluxe

echo ""
echo ""
echo "Following stdout is about parsing of 
xmluxe --parse-title=$titleToParse --f=$targetFile
you have extracted content on /tmp/parsed-xmluxe"
echo ""
echo ""

cat /tmp/parsed-xmluxe


fi






######### Parse id block
grep "^--parse-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-id

stat --format %s /tmp/xmluxe-actionParseR-id > /tmp/xmluxe-actionParseR-idBytes

leggoBytes=$(cat /tmp/xmluxe-actionParseR-idBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionParseR-id | sed 's/.*=//g' > /tmp/xmluxe-idToParseR-id

	idToParse=$(cat /tmp/xmluxe-idToParseR-id)

grep -n "ID=\"$idToParse\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseBeginLine

nLineBeginIdToParseR=$(cat /tmp/xmluxe-idToParseBeginLine)

grep -n "<!-- end $idToParse -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xmluxe-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xmluxe-linesToParse

linesToParseR=$(cat /tmp/xmluxe-linesToParse)

linesToParseRPlusComment=$(($linesToParseR + 1))

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToParseRPlus=$(($linesToParseR + 1))

echo  "$linesToParseRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx


#gview -f /tmp/xmluxe-bloccoSelezionato.lmx

cat /tmp/xmluxe-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xmluxe

echo ""
echo ""
echo "Following stdout is about parsing of 
xmluxe --parse-id=$idToParse --f=$targetFile
you have extracted content on /tmp/parsed-xmluxe"
echo ""
echo ""

cat /tmp/parsed-xmluxe


fi

exit

