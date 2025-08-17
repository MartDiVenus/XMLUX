#!/bin/bash


targetFile=$(cat /tmp/xmluxeTargetFile)

for parse in {1}

do

######### Parse name block in read-only mode
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

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

grep "^-all$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-All

stat --format %s /tmp/xmluxe-actionParseR-All > /tmp/xmluxe-actionParseR-AllBytes

leggoBytesAll=$(cat /tmp/xmluxe-actionParseR-AllBytes)

if test $leggoBytesAll -gt 0

then

grep -n "<!-- end $idToParse -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xmluxe-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xmluxe-linesToParse

linesToParseR=$(cat /tmp/xmluxe-linesToParse)

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

else
	########## solo il valore dell'id selezionato, quindi senza children

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx


## Rimuovo dall'inizio dell'elemento successivo a quello del mio ID, alla fine
grep "^<" /tmp/xmluxe-bloccoSelezionato.lmx | head -n2 | sed 's/>.*//g' | awk '$1 > 0 {print $2}' | tail -n1 > /tmp/xmluxe-nextID

nextID=$(cat /tmp/xmluxe-nextID)

grep -n "$nextID" /tmp/xmluxe-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xmluxe-idToEndParse

linesToEndParse=$(cat /tmp/xmluxe-idToEndParse)

echo  "$linesToEndParse GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#gview -f /tmp/xmluxe-bloccoSelezionato.lmx

fi

cat /tmp/xmluxe-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xmluxe

cat -s /tmp/parsed-xmluxe > /tmp/parsed-xmluxeCats

cp /tmp/parsed-xmluxeCats /tmp/parsed-xmluxe

echo "
$(date +"%Y-%m-%d-%H-%M")	ID=\"$idToParseR\" alias name=$nameToParse parsed" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

echo ""
echo ""
echo "Following stdout is about parsing of 
xmluxe --parse-name=$nameToParse --f=$targetFile
you have extracted content on /tmp/parsed-xmluxe"
echo ""
echo ""

cat /tmp/parsed-xmluxe


break

fi





######### Parse title block in read-only mode
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


cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

grep "^-all$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-All

stat --format %s /tmp/xmluxe-actionParseR-All > /tmp/xmluxe-actionParseR-AllBytes

leggoBytesAll=$(cat /tmp/xmluxe-actionParseR-AllBytes)

if test $leggoBytesAll -gt 0

then

grep -n "<!-- end $idToParse -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xmluxe-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xmluxe-linesToParse

linesToParseR=$(cat /tmp/xmluxe-linesToParse)

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

else
	########## solo il valore dell'id selezionato, quindi senza children

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx


## Rimuovo dall'inizio dell'elemento successivo a quello del mio ID, alla fine
grep "^<" /tmp/xmluxe-bloccoSelezionato.lmx | head -n2 | sed 's/>.*//g' | awk '$1 > 0 {print $2}' | tail -n1 > /tmp/xmluxe-nextID

nextID=$(cat /tmp/xmluxe-nextID)

grep -n "$nextID" /tmp/xmluxe-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xmluxe-idToEndParse

linesToEndParse=$(cat /tmp/xmluxe-idToEndParse)

echo  "$linesToEndParse GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#gview -f /tmp/xmluxe-bloccoSelezionato.lmx

fi


cat /tmp/xmluxe-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xmluxe

cat -s /tmp/parsed-xmluxe > /tmp/parsed-xmluxeCats

cp /tmp/parsed-xmluxeCats /tmp/parsed-xmluxe

echo "
$(date +"%Y-%m-%d-%H-%M")	ID=\"$idToParseR\" alias title=$titleToParse parsed" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

echo ""
echo ""
echo "Following stdout is about parsing of 
xmluxe --parse-title=$titleToParse --f=$targetFile
you have extracted content on /tmp/parsed-xmluxe"
echo ""
echo ""

cat /tmp/parsed-xmluxe


break

fi



######### Parse id block in read-only mode
grep "^--parse-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-id

stat --format %s /tmp/xmluxe-actionParseR-id > /tmp/xmluxe-actionParseR-idBytes

leggoBytes=$(cat /tmp/xmluxe-actionParseR-idBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionParseR-id | sed 's/.*=//g' > /tmp/xmluxe-idToParseR-id

	idToParse=$(cat /tmp/xmluxe-idToParseR-id)

grep -n "ID=\"$idToParse\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseBeginLine

nLineBeginIdToParseR=$(cat /tmp/xmluxe-idToParseBeginLine)

cp $targetFile.lmx /tmp/xmluxe-bloccoSelezionato.lmx

grep "^-all$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-All

stat --format %s /tmp/xmluxe-actionParseR-All > /tmp/xmluxe-actionParseR-AllBytes

leggoBytesAll=$(cat /tmp/xmluxe-actionParseR-AllBytes)

if test $leggoBytesAll -gt 0

then

grep -n "<!-- end $idToParse -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xmluxe-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xmluxe-linesToParse

linesToParseR=$(cat /tmp/xmluxe-linesToParse)

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

else
	########## solo il valore dell'id selezionato, quindi senza children

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato


vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx


## Rimuovo dall'inizio dell'elemento successivo a quello del mio ID, alla fine
grep "^<" /tmp/xmluxe-bloccoSelezionato.lmx | head -n2 | sed 's/>.*//g' | awk '$1 > 0 {print $2}' | tail -n1 > /tmp/xmluxe-nextID

nextID=$(cat /tmp/xmluxe-nextID)

grep -n "$nextID" /tmp/xmluxe-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xmluxe-idToEndParse

linesToEndParse=$(cat /tmp/xmluxe-idToEndParse)

echo  "$linesToEndParse GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato.lmx

#gview -f /tmp/xmluxe-bloccoSelezionato.lmx

fi


cat /tmp/xmluxe-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xmluxe

cat -s /tmp/parsed-xmluxe > /tmp/parsed-xmluxeCats

cp /tmp/parsed-xmluxeCats /tmp/parsed-xmluxe

echo "
$(date +"%Y-%m-%d-%H-%M")	ID=\"$idToParseR\" parsed" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

echo ""
echo ""
echo "Following stdout is about parsing of 
xmluxe --parse-id=$idToParse --f=$targetFile
you have extracted content on /tmp/parsed-xmluxe"
echo ""
echo ""

cat /tmp/parsed-xmluxe

break

fi

done

exit

