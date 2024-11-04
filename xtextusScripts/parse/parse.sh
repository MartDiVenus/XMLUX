#!/bin/bash


targetFile=$(cat /tmp/xtextusTargetFile)

for parse in {1}

do

######### Parse name block in read-only mode
grep "^--parse-name=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParseR-name

stat --format %s /tmp/xtextus-actionParseR-name > /tmp/xtextus-actionParseR-nameBytes

leggoBytes=$(cat /tmp/xtextus-actionParseR-nameBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionParseR-name | sed 's/.*=//g' > /tmp/xtextus-idToParseR-name

	nameToParse=$(cat /tmp/xtextus-idToParseR-name)

/usr/local/bin/xmluxv -s --find-name="$nameToParse" --f=$targetFile

grep "\"$nameToParse\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToParseR

idToParseR="$(cat /tmp/xtextus-idToParseR)"

grep -n "ID=\"$idToParseR\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToParseRBeginLine

nLineBeginIdToParseR=$(cat /tmp/xtextus-idToParseRBeginLine)

cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

grep "^-all$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParseR-All

stat --format %s /tmp/xtextus-actionParseR-All > /tmp/xtextus-actionParseR-AllBytes

leggoBytesAll=$(cat /tmp/xtextus-actionParseR-AllBytes)

if test $leggoBytesAll -gt 0

then

grep -n "<!-- end $idToParse -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xtextus-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xtextus-linesToParse

linesToParseR=$(cat /tmp/xtextus-linesToParse)

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToParseRPlus=$(($linesToParseR + 1))

echo  "$linesToParseRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


#gview -f /tmp/xtextus-bloccoSelezionato.lmx

else
	########## solo il valore dell'id selezionato, quindi senza children

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


## Rimuovo dall'inizio dell'elemento successivo a quello del mio ID, alla fine
grep "^<" /tmp/xtextus-bloccoSelezionato.lmx | head -n2 | sed 's/>.*//g' | awk '$1 > 0 {print $2}' | tail -n1 > /tmp/xtextus-nextID

nextID=$(cat /tmp/xtextus-nextID)

grep -n "$nextID" /tmp/xtextus-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xtextus-idToEndParse

linesToEndParse=$(cat /tmp/xtextus-idToEndParse)

echo  "$linesToEndParse GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

#gview -f /tmp/xtextus-bloccoSelezionato.lmx

fi

cat /tmp/xtextus-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xtextus

cat -s /tmp/parsed-xtextus > /tmp/parsed-xtextusCats

cp /tmp/parsed-xtextusCats /tmp/parsed-xtextus

echo ""
echo ""
echo "Following stdout is about parsing of 
xtextus --parse-name=$nameToParse --f=$targetFile
you have extracted content on /tmp/parsed-xtextus"
echo ""
echo ""

cat /tmp/parsed-xtextus


break

fi





######### Parse title block in read-only mode
grep "^--parse-title=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParseR-title

stat --format %s /tmp/xtextus-actionParseR-title > /tmp/xtextus-actionParseR-titleBytes

leggoBytes=$(cat /tmp/xtextus-actionParseR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionParseR-title | sed 's/.*=//g' > /tmp/xtextus-idToParseR-title

	titleToParse=$(cat /tmp/xtextus-idToParseR-title)

/usr/local/bin/xmluxv -s --find-title="$titleToParse" --f=$targetFile

grep "$titleToParse$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToParseR

idToParseR="$(cat /tmp/xtextus-idToParseR)"

grep -n "ID=\"$idToParseR\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToParseRBeginLine

nLineBeginIdToParseR=$(cat /tmp/xtextus-idToParseRBeginLine)


cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

grep "^-all$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParseR-All

stat --format %s /tmp/xtextus-actionParseR-All > /tmp/xtextus-actionParseR-AllBytes

leggoBytesAll=$(cat /tmp/xtextus-actionParseR-AllBytes)

if test $leggoBytesAll -gt 0

then

grep -n "<!-- end $idToParse -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xtextus-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xtextus-linesToParse

linesToParseR=$(cat /tmp/xtextus-linesToParse)

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToParseRPlus=$(($linesToParseR + 1))

echo  "$linesToParseRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


#gview -f /tmp/xtextus-bloccoSelezionato.lmx

else
	########## solo il valore dell'id selezionato, quindi senza children

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


## Rimuovo dall'inizio dell'elemento successivo a quello del mio ID, alla fine
grep "^<" /tmp/xtextus-bloccoSelezionato.lmx | head -n2 | sed 's/>.*//g' | awk '$1 > 0 {print $2}' | tail -n1 > /tmp/xtextus-nextID

nextID=$(cat /tmp/xtextus-nextID)

grep -n "$nextID" /tmp/xtextus-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xtextus-idToEndParse

linesToEndParse=$(cat /tmp/xtextus-idToEndParse)

echo  "$linesToEndParse GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

#gview -f /tmp/xtextus-bloccoSelezionato.lmx

fi


cat /tmp/xtextus-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xtextus


cat -s /tmp/parsed-xtextus > /tmp/parsed-xtextusCats

cp /tmp/parsed-xtextusCats /tmp/parsed-xtextus


echo ""
echo ""
echo "Following stdout is about parsing of 
xtextus --parse-title=$titleToParse --f=$targetFile
you have extracted content on /tmp/parsed-xtextus"
echo ""
echo ""

cat /tmp/parsed-xtextus


break

fi



######### Parse id block in read-only mode
grep "^--parse-id=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParseR-id

stat --format %s /tmp/xtextus-actionParseR-id > /tmp/xtextus-actionParseR-idBytes

leggoBytes=$(cat /tmp/xtextus-actionParseR-idBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionParseR-id | sed 's/.*=//g' > /tmp/xtextus-idToParseR-id

	idToParse=$(cat /tmp/xtextus-idToParseR-id)

grep -n "ID=\"$idToParse\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToParseBeginLine

nLineBeginIdToParseR=$(cat /tmp/xtextus-idToParseBeginLine)

cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

grep "^-all$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParseR-All

stat --format %s /tmp/xtextus-actionParseR-All > /tmp/xtextus-actionParseR-AllBytes

leggoBytesAll=$(cat /tmp/xtextus-actionParseR-AllBytes)

if test $leggoBytesAll -gt 0

then

grep -n "<!-- end $idToParse -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToParseREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToParseR=$(cat /tmp/xtextus-idToParseREndLine)

echo $nLineEndIdToParseR - $nLineBeginIdToParseR | bc > /tmp/xtextus-linesToParse

linesToParseR=$(cat /tmp/xtextus-linesToParse)

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToParseRPlus=$(($linesToParseR + 1))

echo  "$linesToParseRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


#gview -f /tmp/xtextus-bloccoSelezionato.lmx

else
	########## solo il valore dell'id selezionato, quindi senza children

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToParseR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx


## Rimuovo dall'inizio dell'elemento successivo a quello del mio ID, alla fine
grep "^<" /tmp/xtextus-bloccoSelezionato.lmx | head -n2 | sed 's/>.*//g' | awk '$1 > 0 {print $2}' | tail -n1 > /tmp/xtextus-nextID

nextID=$(cat /tmp/xtextus-nextID)

grep -n "$nextID" /tmp/xtextus-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xtextus-idToEndParse

linesToEndParse=$(cat /tmp/xtextus-idToEndParse)

echo  "$linesToEndParse GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

#gview -f /tmp/xtextus-bloccoSelezionato.lmx

fi


cat /tmp/xtextus-bloccoSelezionato.lmx | sed 's/.*>//g' > /tmp/parsed-xtextus


cat -s /tmp/parsed-xtextus > /tmp/parsed-xtextusCats

cp /tmp/parsed-xtextusCats /tmp/parsed-xtextus


echo ""
echo ""
echo "Following stdout is about parsing of 
xtextus --parse-id=$idToParse --f=$targetFile
you have extracted content on /tmp/parsed-xtextus"
echo ""
echo ""

cat /tmp/parsed-xtextus

break

fi

done

exit

