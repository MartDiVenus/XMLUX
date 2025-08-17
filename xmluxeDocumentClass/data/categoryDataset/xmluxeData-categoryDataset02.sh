#!/bin/bash

### ! A differenza di tutti gli altri tipi di document class di xmlux,
## qui gli elementi Value e Key, per l'azione ADD, vengono specificati
## tramite opzione -k. Quando -k viene espressa --- l'azione ADD richiede
## l'elemento Key, altrimenti richiede l'elemento Value.

targetFile="$(cat /tmp/xmluxeTargetFile)"

## Tutti gli id che iniziano con <a>, ossia il capitolo a.
# è troppo vincolante utilizzare la chiave <a>.
#grep -o "ID=\"a*.*" $targetFile.lmx > /tmp/xmluxe-css01
# In questo modo puoi scrivere ID anche nel preambolo, perché quest'ultimo escluso.
cat $targetFile.lmx | sed -n '/<!-- begin radix/,$p' > /tmp/xmluxe-css0000

## mi serve la coerenza di numero di righe tra il file lmx in cui effettuerò le iniezioni
## e il file selezionato in cui ho escluso il preambolo.
grep -n "<!-- begin radix" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxe-nLineaBeginRadix

leggoNBeginRadix=$(cat /tmp/xmluxe-nLineaBeginRadix)

righeEsatte=$(echo $leggoNBeginRadix - 1 | bc)

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

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

## ora posso selezionare tutti gli ID appartenenti al root
grep "ID=\"$leggoIdRoot" /tmp/xmluxe-css000 | awk '$1 > 0 {print $2}' > /tmp/xmluxe-css01

cat /tmp/xmluxe-css01 | sort > /tmp/xmluxe-css02

cat /tmp/xmluxe-css02 | uniq > /tmp/xmluxe-css03

## tutti i capitoli e sottostanti elementi
grep "\." /tmp/xmluxe-css03 > /tmp/xmluxe-css04

cat /tmp/xmluxe-css04 | sort > /tmp/xmluxe-css05

## solo i capitoli, ossia gli a* senza .
comm -3 /tmp/xmluxe-css03 /tmp/xmluxe-css05 > /tmp/xmluxe-css06

## Nei valori degli elementi non possono esserci caratteri speciali, quali e.g. *, #, &.
# perché grep non leggerebbe la stringa e quindi non producendo file *.dtd, *.css perfetti.

################ INIZIO ROOT 

rm -fr  /tmp/xmluxe-cssRoot

mkdir /tmp/xmluxe-cssRoot

split -l1 /tmp/xmluxe-css01 /tmp/xmluxe-cssRoot/


for c in $(ls /tmp/xmluxe-cssRoot)
do
	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id

	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

	if test $leggoIdRoot == $leggoID

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoIdRoot" >> /tmp/xmluxe-itemsEtIDs

echo "$leggoItem" > /tmp/xmluxe-itemRoot
         
rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE ROOT 


################ INIZIO  SERIES

mkdir /tmp/xmluxe-gradusI

for c in $(ls /tmp/xmluxe-cssRoot)

do
	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id

	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)


	#### Series, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

		cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-gradusI

		cp /tmp/xmluxe-item /tmp/xmluxe-itemSeries

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE SERIES 

############## INIZIO ITEMS
mkdir /tmp/xmluxe-gradusII

for c in $(ls /tmp/xmluxe-cssRoot)

do

	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"

        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	#### Capitolo: il capitolo, insieme a part, non ha mai punti nell'ID; ma gradusI lo risolvo diversamente.

	if test $leggoDotFrequency -eq 1

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-gradusII

cp /tmp/xmluxe-item /tmp/xmluxe-itemITEM

rm -f /tmp/xmluxe-cssRoot/$c

	fi
	
done
################ FINE ITEMS 

################ INIZIO KEYorVALUE

mkdir /tmp/xmluxe-gradusIII

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

grep "ID=\"$leggoIdRoot" /tmp/xmluxe-css05 > /tmp/xmluxe-sectionAnd

rm -fr /tmp/xmluxe-css05Split

mkdir /tmp/xmluxe-css05Split

split -l1 /tmp/xmluxe-sectionAnd  /tmp/xmluxe-css05Split/

for d in $(ls /tmp/xmluxe-css05Split)

do

rm -f /tmp/xmluxe-pcdata

touch /tmp/xmluxe-pcdata

	leggoD="$(cat /tmp/xmluxe-css05Split/$d)"

        grep "$leggoD" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item

	leggoItem="$(cat /tmp/xmluxe-item)"

	cat /tmp/xmluxe-css05Split/$d | sed 's/>/ /g' > /tmp/xmluxe-id0

	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
	
	leggoID="$(cat /tmp/xmluxe-id)"

	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title

	leggoTitle="$(cat /tmp/xmluxe-title)"

	sed 's/[^.]//g' /tmp/xmluxe-id | awk '{ print length }' > /tmp/xmluxe-dotFrequency

	leggoDotFrequency=$(cat /tmp/xmluxe-dotFrequency)

	if test $leggoDotFrequency -eq 2

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusIII

cp /tmp/xmluxe-item /tmp/xmluxe-itemKeyOrValue

rm -f /tmp/xmluxe-css05Split/$d

fi

done

################ FINE KEYorVALUE


if [ ! -f $targetFile.lmxe ]; then 

touch $targetFile.lmxe

fi
for options in {1}

do

############################################################## ACTION INSERT
grep "^--ins" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionInsert

stat --format %s /tmp/xmluxe-actionInsert > /tmp/xmluxe-actionInsertBytes

leggoBytes=$(cat /tmp/xmluxe-actionInsertBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionInsert | cut -d= -f2,2 | awk '$1 > 0 {print $1}' > /tmp/insXmluxe-idToInsert

	rm -fr /tmp/pseudoOptionsBackup-xmluxe

	cp -r /tmp/xmluxePseudoOptions/ /tmp/pseudoOptionsBackup-xmluxe

	rm -fr /tmp/InsXmluxe-PseudoOptions

	cp -r /tmp/xmluxePseudoOptions /tmp/InsXmluxe-PseudoOptions

	touch /tmp/xmluxe-cimiceCategoryDataset02
	
        /usr/local/lib/xmlux/xmluxeScripts/insert/insert.sh

#	rm -fr /tmp/xmluxePseudoOptions

if [ ! -d /tmp/xmluxePseudoOptions ]; then

	cp -r /tmp/pseudoOptionsBackup-xmluxe /tmp/xmluxePseudoOptions
fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

break

fi


############################################################## ACTION MOVE (21 ottobre)
grep "^--move=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionMove

stat --format %s /tmp/xmluxe-actionMove > /tmp/xmluxe-actionMoveBytes

leggoBytesActionMove=$(cat /tmp/xmluxe-actionMoveBytes)

## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

## I if
if test $leggoBytesActionMove -gt 0

then

grep "^-s$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-moveSilentOrNot

stat --format %s /tmp/xmluxe-moveSilentOrNot > /tmp/xmluxe-moveSilentOrNotBytes

silentMoveBytes=$(cat /tmp/xmluxe-moveSilentOrNotBytes)

if test $silentMoveBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/move/data/categoryDataset/categoryDataset02/moveSilent.sh

else

/usr/local/lib/xmlux/xmluxeScripts/move/data/categoryDataset/categoryDataset02/moveVerbose.sh

fi

break

fi
## I if chiuso (quello dell'azione --move)




############################################################## ACTION ADD

grep "^--add=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionAdd

stat --format %s /tmp/xmluxe-actionAdd > /tmp/xmluxe-actionAddBytes

leggoBytes=$(cat /tmp/xmluxe-actionAddBytes)

## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/add/data/categoryDataset/categoryDataset02-add.sh
	
break

### fine add
fi




################################ INIZIO REMOVE ACTION

grep "^--remove=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRemove

stat --format %s /tmp/xmluxe-actionRemove > /tmp/xmluxe-actionRemoveBytes

leggoBytes=$(cat /tmp/xmluxe-actionRemoveBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/remove/data/categoryDataset/categoryDataset02/remove.sh
	
break

fi

################ ACTION JUMP


grep "^--jump" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump

stat --format %s /tmp/xmluxe-actionJump > /tmp/xmluxe-actionJumpBytes

leggoBytes=$(cat /tmp/xmluxe-actionJumpBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/jump/data/categoryDataset/categoryDataset02/jump.sh

break

fi


########### ACTION SELECTR

grep "^--selectR" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR

stat --format %s /tmp/xmluxe-actionSelectR > /tmp/xmluxe-actionSelectRBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectRBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/select/selectR/data/categoryDataset/categoryDataset02/selectR.sh

break

fi



############ ACTION SELECTW

grep "^--selectW" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW

stat --format %s /tmp/xmluxe-actionSelectW > /tmp/xmluxe-actionSelectWBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectWBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/select/selectW/data/categoryDataset/categoryDataset02/selectW.sh

break

fi


############## ACTION PARSE
grep "^--parse" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-name

stat --format %s /tmp/xmluxe-actionParseR-name > /tmp/xmluxe-actionParseR-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionParseR-nameBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/parse/parse.sh

break

fi


################ ACTION RENDER

grep "^--render" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRender

stat --format %s /tmp/xmluxe-actionRender > /tmp/xmluxe-actionRenderBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/render/data/categoryDataset/categoryDataset02/render.sh

fi

############################# OPTION DEL LACK
######################### alla fine altrimenti, salterebbe le azioni con cui
######################### può essere abbinata, e.g. --remove='ID' -delLack

grep "^-delLack$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-optionDelLack

stat --format %s /tmp/xmluxe-optionDelLack > /tmp/xmluxe-optionDelLackBytes

leggoBytesOptionDelLack=$(cat /tmp/xmluxe-optionDelLackBytes)


## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

## I if
if test $leggoBytesOptionDelLack -gt 0

then

	/usr/local/lib/xmlux/xmluxeScripts/lack/data/categoryDataset/categoryDataset02-lack.sh

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

	break

fi

############################# OPTION DEL MULTIPLE EMPTY LINES
######################### Rimuove banchi di linee vuote, lascia solo le righe vuote singole

grep "^-delEmpty" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-optionDelEmpty

stat --format %s /tmp/xmluxe-optionDelEmpty > /tmp/xmluxe-optionDelEmptyBytes

leggoBytesOptionDelEmpty=$(cat /tmp/xmluxe-optionDelEmptyBytes)


## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

## I if
if test $leggoBytesOptionDelEmpty -gt 0

then

cat -s $targetFile.lmx > /tmp/xmluxe-catS
cp /tmp/xmluxe-catS $targetFile.lmx

## Mia alternativa a cat -s, ma è più veloce cat -s
#/usr/local/lib/xmlux/xmluxeScripts/format/delMultipleEmptyLines.sh

	break

fi


############################# OPTION ADD EMPTY LINE AFTER THE ELEMENT END
######################### Aggiunge una linea vuota dopo la chiusura <!-- end ... -->

grep "^-addEmpty" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-optionAddEmpty

stat --format %s /tmp/xmluxe-optionAddEmpty > /tmp/xmluxe-optionAddEmptyBytes

leggoBytesOptionAddEmpty=$(cat /tmp/xmluxe-optionAddEmptyBytes)

if test $leggoBytesOptionAddEmpty -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/format/addEmptyLinesAfterElementEnd.sh

break

fi

############################# OPTION FORMAT:
################# ADD EMPTY LINE AFTER THE ELEMENT END;
################  DEL MULTIPLE EMPTY LINES

grep "^-format" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-optionFormat

stat --format %s /tmp/xmluxe-optionFormat > /tmp/xmluxe-optionFormatBytes

leggoBytesOptionFormat=$(cat /tmp/xmluxe-optionFormatBytes)

if test $leggoBytesOptionFormat -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/format/addEmptyLinesAfterElementEnd.sh

cat -s $targetFile.lmx > /tmp/xmluxe-catS
cp /tmp/xmluxe-catS $targetFile.lmx

break

fi

done


rm -fr /tmp/xmluxe*


exit


