#!/bin/bash



targetFile="$(cat /tmp/xmluxeTargetFile)"

echo $PWD > /tmp/xmluxe-posnow

posnow=$(cat /tmp/xmluxe-posnow)

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

############## INIZIO SINOSSI 
#
#for c in $(ls /tmp/xmluxe-cssRoot)
#
#do
#
#	leggoC="$(cat /tmp/xmluxe-cssRoot/$c)"
#
#        grep "$leggoC" /tmp/xmluxe-css000 | awk '$1 > 0 {print $1}' | sed 's/<//g' > /tmp/xmluxe-item
#
#	leggoItem="$(cat /tmp/xmluxe-item)"
#
#	cat /tmp/xmluxe-cssRoot/$c | sed 's/>/ /g' > /tmp/xmluxe-id0
#
#	cat /tmp/xmluxe-id0 | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-id
#
#	leggoID="$(cat /tmp/xmluxe-id)"
#
#	grep "ID=\"$leggoID\"" $targetFile.lmx | sed 's/.*>//g' > /tmp/xmluxe-title
#
#	leggoTitle="$(cat /tmp/xmluxe-title)"
#
#	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
#
#	echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-sinossi
#
#	idSinossi="$(cat /tmp/xmluxe-sinossi)"
#
#	## sinossi: un solo numero (un solo zero)
#	if test "$leggoID" == "$idSinossi"
#
#	then
#
#echo "$leggoID" >> /tmp/xmluxe-allIDs
#
#echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs
#
#	cp /tmp/xmluxe-item /tmp/xmluxe-itemSinossi
#
#	rm -f /tmp/xmluxe-cssRoot/$c
#        
#	fi
#
#done
#
############# FINE SINOSSI 

################ INIZIO  PART

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


	#### GradusI, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

		cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-gradusI

		cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusI

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE PART 

############## INIZIO CHAPTERS
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

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusII

rm -f /tmp/xmluxe-cssRoot/$c

	fi
	
done
################ FINE CHAPTERS 

################ INIZIO SECTION

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusIII

rm -f /tmp/xmluxe-css05Split/$d

fi

done

################ FINE SECTION

################ INIZIO SUBSECTION

mkdir /tmp/xmluxe-gradusIV

rm -f /tmp/xmluxe-ElementDtd

touch /tmp/xmluxe-ElementDtd

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

	if test $leggoDotFrequency -eq 3

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusIV

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusIV

        rm -f /tmp/xmluxe-css05Split/$d
	
	fi

done

################ FINE SUBSECTION 

################ INIZIO SUBSUBSECTION

mkdir /tmp/xmluxe-gradusV

for d in $(ls /tmp/xmluxe-css05Split)

do

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

	if test $leggoDotFrequency -eq 4

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusV

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusV

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE SUBSUBSECTION 

################ INIZIO PARAPGRAPH

mkdir /tmp/xmluxe-gradusVI

for d in $(ls /tmp/xmluxe-css05Split)

do
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

	if test $leggoDotFrequency -eq 5

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusVI

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusVI

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE PARAGRAPH

################ INIZIO SUBPARAGRAPH
mkdir /tmp/xmluxe-gradusVII

for d in $(ls /tmp/xmluxe-css05Split)

do

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

	if test $leggoDotFrequency -eq 6

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-item /tmp/xmluxe-itemGradusVII

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-gradusVII

	rm -f /tmp/xmluxe-css05Split/$d

	fi
done

################ FINE SUBPARAGRAPH 

if [ ! -f $targetFile.lmxe ]; then 

touch $targetFile.lmxe

fi

for options in {1}

do

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

/usr/local/lib/xmlux/xmluxeScripts/move/data/data-seven/moveSilent.sh

else

/usr/local/lib/xmlux/xmluxeScripts/move/data/data-seven/moveVerbose.sh

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

/usr/local/lib/xmlux/xmluxeScripts/add/data/data-seven-add.sh
	
break

### fine add
fi




############### ACTION REMOVE

grep "^--remove=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRemove

stat --format %s /tmp/xmluxe-actionRemove > /tmp/xmluxe-actionRemoveBytes

leggoBytes=$(cat /tmp/xmluxe-actionRemoveBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/remove/data/data-seven/remove.sh

break

fi


########### ACTION JUMP

grep "^--jump" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump

stat --format %s /tmp/xmluxe-actionJump > /tmp/xmluxe-actionJumpBytes

leggoBytes=$(cat /tmp/xmluxe-actionJumpBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/jump/data/data-seven/jump.sh

break

fi

############## ACTION SORT

grep "^--sort-" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSort

stat --format %s /tmp/xmluxe-actionSort > /tmp/xmluxe-actionSortBytes

leggoBytes=$(cat /tmp/xmluxe-actionSortBytes)

if test $leggoBytes -gt 0

then
	rm -fr /tmp/pseudoOptionsBackup-xmluxe

	cp -r /tmp/xmluxePseudoOptions/ /tmp/pseudoOptionsBackup-xmluxe

	## Sorting by titles or by names

	grep "^-t$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeSortByTitle

	stat --format %s /tmp/xmluxeSortByTitle > /tmp/xmluxeSortByTitleBytes

	leggoBytes=$(cat /tmp/xmluxeSortByTitleBytes)

	if test $leggoBytes -gt 0

	then

		/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byTitle.sh

	else
		## default

		/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byName.sh
	fi

#	grep "^-n" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeSortByName

#	stat --format %s /tmp/xmluxeSortByName > /tmp/xmluxeSortByNameBytes

#	leggoBytes=$(cat /tmp/xmluxeSortByNameBytes)

#	if test $leggoBytes -gt 0

#	then

#		/usr/local/lib/xmlux/xmluxeScripts/sorting/sorting-byName.sh

#	fi



#	rm -fr /tmp/xmluxePseudoOptions
if [ ! -d /tmp/xmluxePseudoOptions ]; then

	cp -r /tmp/pseudoOptionsBackup-xmluxe /tmp/xmluxePseudoOptions
fi

break

fi


############# ACTION INSERT

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

	touch /tmp/xmluxe-cimiceData-seven
	
        /usr/local/lib/xmlux/xmluxeScripts/insert/insert.sh

#	rm -fr /tmp/xmluxePseudoOptions

if [ ! -d /tmp/xmluxePseudoOptions ]; then

	cp -r /tmp/pseudoOptionsBackup-xmluxe /tmp/xmluxePseudoOptions
fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

break

fi



################## ACTION SELECTR
grep "^--selectR" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR

stat --format %s /tmp/xmluxe-actionSelectR > /tmp/xmluxe-actionSelectRBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectRBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/select/selectR/data/data-seven/selectR.sh

break

fi


################ ACTION SELECTW

grep "^--selectW" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW

stat --format %s /tmp/xmluxe-actionSelectW > /tmp/xmluxe-actionSelectWBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectWBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/select/selectW/data/data-seven/selectW.sh

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

/usr/local/lib/xmlux/xmluxeScripts/render/data/data-seven/render.sh

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

	/usr/local/lib/xmlux/xmluxeScripts/lack/data/data-seven/data-seven-lack.sh

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




