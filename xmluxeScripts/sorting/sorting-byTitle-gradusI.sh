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

targetFile="$(cat /tmp/xmluxeTargetFile)"

##  /tmp/xmluxse-targetFile
# serve agli script di formattazione lanciato da questo, in quanto
# /tmp/xmluxeTargetFile viene elminato da xmluxe lanciato internamente (sempre) da questo.
cp /tmp/xmluxeTargetFile /tmp/xmluxse-targetFile

cp $targetFile.lmx $targetFile.lmx.orig

leggoIdRoot=$(cat /tmp/xmluxe-idRoot)

leggoIdToMove=$(cat /tmp/xmluxse-idsToShift)

### seleziono solo i gradusI
## lascia lo spazio, è voluto
grep " gradusI$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxse-onlyIDgradusI

## lascia lo spazio, è voluto
grep "gradusI " $targetFile-lmxv/kin/$targetFile-ids-elements-titles.lmxv > /tmp/xmluxse-ID-gradusI-titles

### seleziono solo i titles
## con i cappelletti elimino i primi due spazi bianchi
cat /tmp/xmluxse-ID-gradusI-titles | sed 's/.*gradusI//g' | sed 's/^ //g' | sed 's/^ //g' > /tmp/xmluxse-onlyTitles

#read -p "testing 41
#" EnterNUll

translateA () {

### ordino in forma ascendente
cat /tmp/xmluxse-onlyTitles | sort > /tmp/xmluxse-onlyTitlesSorted

### individuo il numero di righe perché devo ritrovare i corrispondenti id in base
# al nuovo ordine, e muovere
awk '{ nlines++;  print nlines }' /tmp/xmluxse-onlyTitles | tail -n1 > /tmp/xmluxse-frequGradusI

nLines=$(cat /tmp/xmluxse-frequGradusI)

## devo aggiungere 1 per non aver sovrapposizioni negli spostamenti
plusNLine=$(($nLines + 1))

#read -p "testing 49
#" EnterNull

mkdir /tmp/xmluxse-idToMove

split -l1 /tmp/xmluxse-onlyIDgradusI /tmp/xmluxse-idToMove/

for idToMove in $(ls /tmp/xmluxse-idToMove)

do

	leggoIdToMove=$(cat /tmp/xmluxse-idToMove/$idToMove)

/usr/local/bin/xmluxe --move=$leggoIdToMove -a$plusNLine --f=$targetFile

done

## invece di usare la struttura interna a bash <@> che reputo non affidabile,
# seleziono manualmente con seq

mkdir /tmp/xmluxse-idOriginali

#mkdir /tmp/xmluxse-titleOrdinati

declare -i var=0

for a in `seq $nLines`

do

var=var+1

cat /tmp/xmluxse-onlyTitlesSorted | head -n$var | tail -n1 > /tmp/xmluxse-fromTitleToId

title=$(cat /tmp/xmluxse-fromTitleToId)

## Cercando il primo title ordinato, ottengo il suo corrispondente passato ID
grep "$title$" /tmp/xmluxse-ID-gradusI-titles | awk '$1 > 0 {print $1}' > /tmp/xmluxse-idOriginali/xmluxse-originalID-$var

cat /tmp/xmluxse-idOriginali/xmluxse-originalID-$var | sed 's/'$leggoIdRoot'0//g' > /tmp/xmluxse-originalIDSuffix


originalIDSuffix=$(cat /tmp/xmluxse-originalIDSuffix)

movedIDSuffix=$(($originalIDSuffix + $plusNLine))

if test $movedIDSuffix -lt 10

then

shiftedIDSuffix="0$movedIDSuffix"

else

shiftedIDSuffix="$movedIDSuffix"

fi



if test $var -lt 10

then

nVar="0$var"

else

nVar=$var

fi

#read -p "testing 130
#vim -c \":%s/\$leggoIdRoot\$shiftedIDSuffix/\$leggoIdRoot\$nVar/g\" \$targetFile.lmx -c :w -c :q
#vim -c ":%s/$leggoIdRoot$shiftedIDSuffix/$leggoIdRoot$nVar/g" $targetFile.lmx -c :w -c :q
#" EnterNull

## l'originalID ora deve avere suffisso numerico pari a $var
vim -c ":%s/$leggoIdRoot$shiftedIDSuffix/$leggoIdRoot$nVar/g" $targetFile.lmx -c :w -c :q 

done


## Seleziono l'inizio della radice
grep -n "ID=\"$leggoIdRoot\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDRadixBegin

lineBeginRadix=$(cat /tmp/xmluxse-translateIDRadixBegin)

sed -n '1,'$lineBeginRadix'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco01


##### Traslazione dei blocchi
mkdir /tmp/xmluxse-idsToOrder

mkdir /tmp/xmluxse-containerBlocchi


split -l1 /tmp/xmluxse-onlyIDgradusI /tmp/xmluxse-idsToOrder/

declare -i var=0

for idToOrder in $(ls /tmp/xmluxse-idsToOrder)

do

	var=var+1

	leggoIdToOrder=$(cat /tmp/xmluxse-idsToOrder/$idToOrder)

grep -n "ID=\"$leggoIdToOrder\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDBegin

lineBegin=$(cat /tmp/xmluxse-translateIDBegin)

grep -n "<!-- end $leggoIdToOrder -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDEnd

lineEnd=$(cat /tmp/xmluxse-translateIDEnd)

if test $var -lt 10

then

sed -n ''$lineBegin','$lineEnd'p' $targetFile.lmx > /tmp/xmluxse-containerBlocchi/blocco02-0$var

else

sed -n ''$lineBegin','$lineEnd'p' $targetFile.lmx > /tmp/xmluxse-containerBlocchi/blocco02-$var

fi

### ok, isolati.
#
#read -p "testing 189
#" EnterNull

done


for mosaico in $(ls /tmp/xmluxse-containerBlocchi)

do

if [ -f /tmp/xmluxse-mosaicoDone ]; then

	cat /tmp/xmluxse-mosaicoDone /tmp/xmluxse-containerBlocchi/$mosaico > /tmp/xmluxse-mosaico

	cp /tmp/xmluxse-mosaico /tmp/xmluxse-mosaicoDone

else
	cp /tmp/xmluxse-containerBlocchi/$mosaico /tmp/xmluxse-mosaicoDone

fi

#echo "" >> /tmp/xmluxse-mosaicoDone

done


echo "" >> /tmp/xmluxse-translate-blocco01

cat /tmp/xmluxse-translate-blocco01 /tmp/xmluxse-mosaicoDone > $targetFile.lmx

#echo "" >> $targetFile.lmx

echo "</radix>" >> $targetFile.lmx

}


translateD () {

### ordino in forma ascendente
cat /tmp/xmluxse-onlyTitles | sort -r > /tmp/xmluxse-onlyTitlesSorted

### individuo il numero di righe perché devo ritrovare i corrispondenti id in base
# al nuovo ordine, e muovere
awk '{ nlines++;  print nlines }' /tmp/xmluxse-onlyTitles | tail -n1 > /tmp/xmluxse-frequGradusI

nLines=$(cat /tmp/xmluxse-frequGradusI)

## devo aggiungere 1 per non aver sovrapposizioni negli spostamenti
plusNLine=$(($nLines + 1))

#read -p "testing 49
#" EnterNull

mkdir /tmp/xmluxse-idToMove

split -l1 /tmp/xmluxse-onlyIDgradusI /tmp/xmluxse-idToMove/

for idToMove in $(ls /tmp/xmluxse-idToMove)

do

	leggoIdToMove=$(cat /tmp/xmluxse-idToMove/$idToMove)

/usr/local/bin/xmluxe --move=$leggoIdToMove -a$plusNLine --f=$targetFile

done

## invece di usare la struttura interna a bash <@> che reputo non affidabile,
# seleziono manualmente con seq

mkdir /tmp/xmluxse-idOriginali

#mkdir /tmp/xmluxse-titleOrdinati

declare -i var=0

for a in `seq $nLines`

do

var=var+1

cat /tmp/xmluxse-onlyTitlesSorted | head -n$var | tail -n1 > /tmp/xmluxse-fromTitleToId

title=$(cat /tmp/xmluxse-fromTitleToId)

## Cercando il primo title ordinato, ottengo il suo corrispondente passato ID
grep "$title$" /tmp/xmluxse-ID-gradusI-titles | awk '$1 > 0 {print $1}' > /tmp/xmluxse-idOriginali/xmluxse-originalID-$var

cat /tmp/xmluxse-idOriginali/xmluxse-originalID-$var | sed 's/'$leggoIdRoot'0//g' > /tmp/xmluxse-originalIDSuffix


originalIDSuffix=$(cat /tmp/xmluxse-originalIDSuffix)

movedIDSuffix=$(($originalIDSuffix + $plusNLine))

if test $movedIDSuffix -lt 10

then

shiftedIDSuffix="0$movedIDSuffix"

else

shiftedIDSuffix="$movedIDSuffix"

fi



if test $var -lt 10

then

nVar="0$var"

else

nVar=$var

fi

#read -p "testing 108
#vim -c \":%s/\$leggoIdRoot\$shiftedIDSuffix/\$leggoIdRoot\$nVar/g\" \$targetFile.lmx -c :w -c :q
#vim -c ":%s/$leggoIdRoot$shiftedIDSuffix/$leggoIdRoot$nVar/g" $targetFile.lmx -c :w -c :q
#" EnterNull

## l'originalID ora deve avere suffisso numerico pari a $var
vim -c ":%s/$leggoIdRoot$shiftedIDSuffix/$leggoIdRoot$nVar/g" $targetFile.lmx -c :w -c :q 

done


## Seleziono l'inizio della radice
grep -n "ID=\"$leggoIdRoot\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDRadixBegin

lineBeginRadix=$(cat /tmp/xmluxse-translateIDRadixBegin)

sed -n '1,'$lineBeginRadix'p' $targetFile.lmx > /tmp/xmluxse-translate-blocco01


##### Traslazione dei blocchi
mkdir /tmp/xmluxse-idsToOrder

mkdir /tmp/xmluxse-containerBlocchi


split -l1 /tmp/xmluxse-onlyIDgradusI /tmp/xmluxse-idsToOrder/

declare -i var=0

for idToOrder in $(ls /tmp/xmluxse-idsToOrder)

do

	var=var+1

	leggoIdToOrder=$(cat /tmp/xmluxse-idsToOrder/$idToOrder)

grep -n "ID=\"$leggoIdToOrder\"" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDBegin

lineBegin=$(cat /tmp/xmluxse-translateIDBegin)

grep -n "<!-- end $leggoIdToOrder -->" $targetFile.lmx | cut -d: -f1,1 > /tmp/xmluxse-translateIDEnd

lineEnd=$(cat /tmp/xmluxse-translateIDEnd)

if test $var -lt 10

then

sed -n ''$lineBegin','$lineEnd'p' $targetFile.lmx > /tmp/xmluxse-containerBlocchi/blocco02-0$var

else

sed -n ''$lineBegin','$lineEnd'p' $targetFile.lmx > /tmp/xmluxse-containerBlocchi/blocco02-$var

fi

### ok, isolati.
done


for mosaico in $(ls /tmp/xmluxse-containerBlocchi)

do

if [ -f /tmp/xmluxse-mosaicoDone ]; then

	cat /tmp/xmluxse-mosaicoDone /tmp/xmluxse-containerBlocchi/$mosaico > /tmp/xmluxse-mosaico

	cp /tmp/xmluxse-mosaico /tmp/xmluxse-mosaicoDone

else
	cp /tmp/xmluxse-containerBlocchi/$mosaico /tmp/xmluxse-mosaicoDone

fi

#echo "" >> /tmp/xmluxse-mosaicoDone

done


echo "" >> /tmp/xmluxse-translate-blocco01

cat /tmp/xmluxse-translate-blocco01 /tmp/xmluxse-mosaicoDone > $targetFile.lmx

#echo "" >> $targetFile.lmx

echo "</radix>" >> $targetFile.lmx

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

