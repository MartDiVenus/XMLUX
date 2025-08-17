#!/bin/bash


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

############# INIZIO SINOSSI 

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

	echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-sinossi

	idSinossi="$(cat /tmp/xmluxe-sinossi)"

	## sinossi: un solo numero (un solo zero)
	if test "$leggoID" == "$idSinossi"

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

	cp /tmp/xmluxe-item /tmp/xmluxe-itemSinossi

	rm -f /tmp/xmluxe-cssRoot/$c
        
	fi

done

############# FINE SINOSSI 

################ INIZIO  PART

mkdir /tmp/xmluxe-parts

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


	#### Part, non ha mai punti nell'ID.

	if test $leggoDotFrequency -eq 0

	then

		cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-parts

		cp /tmp/xmluxe-item /tmp/xmluxe-itemPart

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

rm -f /tmp/xmluxe-cssRoot/$c

	fi


done
################ FINE PART 

############## INIZIO CHAPTERS
mkdir /tmp/xmluxe-chapters

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

	#### Capitolo: il capitolo, insieme a part, non ha mai punti nell'ID; ma part lo risolvo diversamente.

	if test $leggoDotFrequency -eq 1

	then

echo "$leggoID" >> /tmp/xmluxe-allIDs

echo "$leggoItem $leggoID" >> /tmp/xmluxe-itemsEtIDs

cp /tmp/xmluxe-cssRoot/$c /tmp/xmluxe-chapters

cp /tmp/xmluxe-item /tmp/xmluxe-itemChapter

rm -f /tmp/xmluxe-cssRoot/$c

	fi
	
done
################ FINE CHAPTERS 

################ INIZIO SECTION

mkdir /tmp/xmluxe-sections

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

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-sections

cp /tmp/xmluxe-item /tmp/xmluxe-itemSection

rm -f /tmp/xmluxe-css05Split/$d

fi

done

################ FINE SECTION

################ INIZIO SUBSECTION

mkdir /tmp/xmluxe-subsections

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

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-subsections

cp /tmp/xmluxe-item /tmp/xmluxe-itemSubsection

        rm -f /tmp/xmluxe-css05Split/$d
	
	fi

done

################ FINE SUBSECTION 

################ INIZIO SUBSUBSECTION

mkdir /tmp/xmluxe-subsubsections

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemSubsubsection

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-subsubsections

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE SUBSUBSECTION 

################ INIZIO PARAPGRAPH

mkdir /tmp/xmluxe-paragraphs

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemParagraph

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-paragraphs

	rm -f /tmp/xmluxe-css05Split/$d

	fi

done

################ FINE PARAGRAPH

################ INIZIO SUBPARAGRAPH
mkdir /tmp/xmluxe-subparagraphs

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

cp /tmp/xmluxe-item /tmp/xmluxe-itemSubparagraph

cp /tmp/xmluxe-css05Split/$d /tmp/xmluxe-subparagraphs

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

/usr/local/lib/xmlux/xmluxeScripts/move/matter/book/moveSilent.sh

else

/usr/local/lib/xmlux/xmluxeScripts/move/matter/book/moveVerbose.sh

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

/usr/local/lib/xmlux/xmluxeScripts/add/matter/matter-book-add.sh
	
break

### fine add
fi



########################## ACTION REMOVE

grep "^--remove=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRemove

stat --format %s /tmp/xmluxe-actionRemove > /tmp/xmluxe-actionRemoveBytes

leggoBytes=$(cat /tmp/xmluxe-actionRemoveBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionRemove | cut -d= -f2,2 | awk '$1 > 0 {print $1}' >  /tmp/xmluxe-idToRemove

idToRemove="$(cat /tmp/xmluxe-idToRemove)"

grep -n "ID=\"$idToRemove\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRemoveBeginLine

nLineBeginIdToRemove=$(cat /tmp/xmluxe-idToRemoveBeginLine)

grep -n "<!-- end $idToRemove -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRemoveEndLine

nLineEndIdToRemove=$(cat /tmp/xmluxe-idToRemoveEndLine)

linesToDelete=$(echo $nLineEndIdToRemove - $nLineBeginIdToRemove | bc)

echo "$nLineBeginIdToRemove Gd$linesToDelete
ZZ

" | sed 's/ //g' > /tmp/xmluxe-blockToDelete


vim -s /tmp/xmluxe-blockToDelete $targetFile.lmx

	echo "
$(date +"%Y-%m-%d-%H-%M")	$idToRemove removed" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

###################### REMOVE / DEL LACK
##########++++++++++++ modifica 2024.10.30
grep "^-delLack$" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionDelLack

stat --format %s /tmp/xmluxe-actionDelLack > /tmp/xmluxe-actionDelLackBytes

bytesLack=$(cat /tmp/xmluxe-actionDelLackBytes)

if test $bytesLack -gt 0

then

/usr/local/lib/xmlux/xmluxeScripts/lack/matter/matter-book-lack.sh

fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

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

	touch /tmp/xmluxe-cimiceMatter-book
	
        /usr/local/lib/xmlux/xmluxeScripts/insert/insert.sh

#	rm -fr /tmp/xmluxePseudoOptions

if [ ! -d /tmp/xmluxePseudoOptions ]; then

	cp -r /tmp/pseudoOptionsBackup-xmluxe /tmp/xmluxePseudoOptions
fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

break

fi

############# ACTION JUMP

grep "^--jump" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump

stat --format %s /tmp/xmluxe-actionJump > /tmp/xmluxe-actionJumpBytes

leggoBytes=$(cat /tmp/xmluxe-actionJumpBytes)

if test $leggoBytes -gt 0

then

	for jump in {1}

	do

######### jump by ID
grep "^--jump-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump

stat --format %s /tmp/xmluxe-actionJump > /tmp/xmluxe-actionJumpBytes

leggoBytes=$(cat /tmp/xmluxe-actionJumpBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionJump | sed 's/.*=//g' > /tmp/xmluxe-idToJump
idToJump="$(cat /tmp/xmluxe-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xmluxe-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

break

fi


######### jump by name
grep "^--jump-name=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump-name

stat --format %s /tmp/xmluxe-actionJump-name > /tmp/xmluxe-actionJump-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionJump-nameBytes)

if test $leggoBytes -gt 0

then
	cat  /tmp/xmluxe-actionJump-name | sed 's/.*=//g' > /tmp/xmluxe-idToJump-name
	nameToSelect=$(cat /tmp/xmluxe-idToJump-name)

/usr/local/bin/xmluxv --find-name="$nameToSelect" --f=$targetFile

grep "\"$nameToSelect\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToJump

idToJump="$(cat /tmp/xmluxe-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xmluxe-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

break

fi

######### jump by title
grep "^--jump-title=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionJump-title

stat --format %s /tmp/xmluxe-actionJump-title > /tmp/xmluxe-actionJump-titleBytes

leggoBytes=$(cat /tmp/xmluxe-actionJump-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionJump-title | sed 's/.*=//g' > /tmp/xmluxe-idToJump-title
	titleToSelect=$(cat /tmp/xmluxe-idToJump-title)

/usr/local/bin/xmluxv --find-title="$titleToSelect" --f=$targetFile

grep "$titleToSelect$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToJump

idToJump="$(cat /tmp/xmluxe-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xmluxe-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

break

fi

done

break

fi

################# ACTION SELECTR

grep "^--selectR" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectR

stat --format %s /tmp/xmluxe-actionSelectR > /tmp/xmluxe-actionSelectRBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectRBytes)

if test $leggoBytes -gt 0

then

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


## fine modifica rispetto a remove

	echo "
$(date +"%Y-%m-%d-%H-%M")	$idToSelectR selected in read-only mode" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

#read -p "testing 6421" EnterNull

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

fi

break

fi

##################### ACTION SELECTW

grep "^--selectW" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionSelectW

stat --format %s /tmp/xmluxe-actionSelectW > /tmp/xmluxe-actionSelectWBytes

leggoBytes=$(cat /tmp/xmluxe-actionSelectWBytes)

if test $leggoBytes -gt 0

then

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
$(date +"%Y-%m-%d-%H-%M")	ID=$idToSelectR alias name=$nameToSelect selected in write mode" >> $targetFile.lmxe

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

break

fi


################# ACTION PARSE

grep "^--parse" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionParseR-name

stat --format %s /tmp/xmluxe-actionParseR-name > /tmp/xmluxe-actionParseR-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionParseR-nameBytes)

if test $leggoBytes -gt 0

then

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

break

fi


################ ACTION RENDER

grep "^--render" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRender

stat --format %s /tmp/xmluxe-actionRender > /tmp/xmluxe-actionRenderBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderBytes)

if test $leggoBytes -gt 0

then

	for render in {1}

	do

######### Render id block
grep "^--renderCss-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRenderedR

stat --format %s /tmp/xmluxe-actionRenderedR > /tmp/xmluxe-actionRenderedRBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderedRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionRenderedR | sed 's/.*=//g' > /tmp/xmluxe-idToRenderedR

	idToRenderedR="$(cat /tmp/xmluxe-idToRenderedR)"


	## Invece di intervenire sul codice lmx, lavoro direttament sul xml.
#	grep -n "ID=\"$idToRenderedR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedRBeginLine

#nLineBeginIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedRBeginLine)

#grep -n "<!-- end $idToRenderedR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedREndLine

	
	grep -n "ID=\"$idToRenderedR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedRBeginLine

nLineBeginIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedRBeginLine)

grep -n "<!-- end $idToRenderedR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedREndLine)

echo $nLineEndIdToRenderedR - $nLineBeginIdToRenderedR | bc > /tmp/xmluxe-linesToRendered

linesToRenderedR=$(cat /tmp/xmluxe-linesToRendered)

linesToRenderedRPlusComment=$(($linesToRenderedR + 1))


## Rimuovo dalla I riga all'inizio del blocco da selezionare
echo $(($nLineBeginIdToRenderedR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xmluxe-bloccoSelezionato

vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToRenderedRPlus=$(($linesToRenderedR + 1))

echo  "$linesToRenderedRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xmluxe-intestazione

cat /tmp/xmluxe-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xmluxe-intestazione01

cp /tmp/xmluxe-intestazione01 /tmp/xmluxe-intestazione


/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xmluxe-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xmluxe-notKin_elements

vim -s /tmp/xmluxe-commandDelFirstEtLastLine /tmp/xmluxe-notKin_elements



cat /tmp/xmluxe-notKin_elements | sed '/^$/d' | uniq > /tmp/xmluxe-ToCTree

grep "$idToRenderedR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-relativeElement

element=$(cat /tmp/xmluxe-relativeElement)
 

cat /tmp/xmluxe-ToCTree | grep -B 1000 "$element" > /tmp/xmluxe-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xmluxe-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure

rm -fr /tmp/xmluxe-ToCStructureSplit

mkdir  /tmp/xmluxe-ToCStructureSplit

split -l1 /tmp/xmluxe-ToCStructure /tmp/xmluxe-ToCStructureSplit/

declare -i var=0

for tocStructure in $(ls /tmp/xmluxe-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xmluxe-ToCStructureSplit/$tocStructure)

	if test "$leggoToC" == "synopsis"

	then
	
	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione
	echo "</$leggoToC>" >> /tmp/xmluxe-intestazione

	else

	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione

	echo "$leggoToC" > /tmp/xmluxe-inverseOrderToC-$var


	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xmluxe-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xmluxe-inverseOrderToC-$var /tmp/xmluxe-inverseOrder-$VarMenoUno > /tmp/xmluxe-inverseOrder-$var

		else
			cat /tmp/xmluxe-inverseOrderToC-$var > /tmp/xmluxe-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xmluxe-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xmluxe-inverseOrderToC-'n' per la synopsis.
done

rm -fr /tmp/xmluxe-inverseOrderToCSplit

mkdir /tmp/xmluxe-inverseOrderToCSplit

ls /tmp/xmluxe-inverseOrder-* | tail -n1 > /tmp/xmluxe-inverseOrder-finalLs

cat /tmp/xmluxe-inverseOrder-finalLs > /tmp/xmluxe-inverseOrder-final

inversedOrder=$(cat /tmp/xmluxe-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xmluxe-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xmluxe-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xmluxe-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xmluxe-bloccoSelezionato

done

cat /tmp/xmluxe-intestazione /tmp/xmluxe-bloccoSelezionato > /tmp/xmluxe-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xmluxe

mkdir /tmp/renderCss-xmluxe

cp -r . /tmp/renderCss-xmluxe/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xmluxe/*.back

rm /tmp/renderCss-xmluxe/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xmluxe/*.dtd

rm /tmp/renderCss-xmluxe/*.xml

rm /tmp/renderCss-xmluxe/*.lmx

rm -f /tmp/renderCss-xmluxe/*.lmxv

rm -fr /tmp/renderCss-xmluxe/*lmxv*

rm /tmp/renderCss-xmluxe/*.lmxp

rm -f /tmp/renderCss-xmluxe/*.lmxe

cp /tmp/xmluxe-bloccoSelezionatoIntestato /tmp/renderCss-xmluxe/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xmluxe/renderedCss.css



#cd /tmp/renderCss-xmluxe

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingChoice.java

scelta=$(cat /tmp/xmluxe-parsingChoice)

for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xmluxe/renderedCss.xml

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

break
fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xmluxe/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

break

fi

done

break

fi

######### Render name block
grep "^--renderCss-name=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRenderedR-name

stat --format %s /tmp/xmluxe-actionRenderedR-name > /tmp/xmluxe-actionRenderedR-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderedR-nameBytes)

if test $leggoBytes -gt 0

then
	cat  /tmp/xmluxe-actionRenderedR-name | sed 's/.*=//g' > /tmp/xmluxe-idToRenderedR-name
	nameToRendered=$(cat /tmp/xmluxe-idToRenderedR-name)

/usr/local/bin/xmluxv -s --find-name="$nameToRendered" --f=$targetFile

grep "\"$nameToRendered\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToRenderedR

idToRenderedR="$(cat /tmp/xmluxe-idToRenderedR)"

	grep -n "ID=\"$idToRenderedR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedRBeginLine

nLineBeginIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedRBeginLine)

grep -n "<!-- end $idToRenderedR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedREndLine)

echo $nLineEndIdToRenderedR - $nLineBeginIdToRenderedR | bc > /tmp/xmluxe-linesToRendered

linesToRenderedR=$(cat /tmp/xmluxe-linesToRendered)

linesToRenderedRPlusComment=$(($linesToRenderedR + 1))



## Rimuovo dalla I riga all'inizio del blocco da selezionare
echo $(($nLineBeginIdToRenderedR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xmluxe-bloccoSelezionato

vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato


## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToRenderedRPlus=$(($linesToRenderedR + 1))

echo  "$linesToRenderedRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xmluxe-intestazione

cat /tmp/xmluxe-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xmluxe-intestazione01

cp /tmp/xmluxe-intestazione01 /tmp/xmluxe-intestazione



/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xmluxe-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xmluxe-notKin_elements

vim -s /tmp/xmluxe-commandDelFirstEtLastLine /tmp/xmluxe-notKin_elements



cat /tmp/xmluxe-notKin_elements | sed '/^$/d' | uniq > /tmp/xmluxe-ToCTree

grep "$idToRenderedR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-relativeElement

element=$(cat /tmp/xmluxe-relativeElement)
 

cat /tmp/xmluxe-ToCTree | grep -B 1000 "$element" > /tmp/xmluxe-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xmluxe-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure

rm -fr /tmp/xmluxe-ToCStructureSplit

mkdir  /tmp/xmluxe-ToCStructureSplit

split -l1 /tmp/xmluxe-ToCStructure /tmp/xmluxe-ToCStructureSplit/

declare -i var=0

for tocStructure in $(ls /tmp/xmluxe-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xmluxe-ToCStructureSplit/$tocStructure)

	if test "$leggoToC" == "synopsis"

	then
	
	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione
	echo "</$leggoToC>" >> /tmp/xmluxe-intestazione

	else

	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione

	echo "$leggoToC" > /tmp/xmluxe-inverseOrderToC-$var


	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xmluxe-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xmluxe-inverseOrderToC-$var /tmp/xmluxe-inverseOrder-$VarMenoUno > /tmp/xmluxe-inverseOrder-$var

		else
			cat /tmp/xmluxe-inverseOrderToC-$var > /tmp/xmluxe-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xmluxe-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xmluxe-inverseOrderToC-'n' per la synopsis.
done

rm -fr /tmp/xmluxe-inverseOrderToCSplit

mkdir /tmp/xmluxe-inverseOrderToCSplit

ls /tmp/xmluxe-inverseOrder-* | tail -n1 > /tmp/xmluxe-inverseOrder-finalLs

cat /tmp/xmluxe-inverseOrder-finalLs > /tmp/xmluxe-inverseOrder-final

inversedOrder=$(cat /tmp/xmluxe-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xmluxe-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xmluxe-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xmluxe-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xmluxe-bloccoSelezionato

done


cat /tmp/xmluxe-intestazione /tmp/xmluxe-bloccoSelezionato > /tmp/xmluxe-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xmluxe

mkdir /tmp/renderCss-xmluxe

cp -r . /tmp/renderCss-xmluxe/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xmluxe/*.back

rm /tmp/renderCss-xmluxe/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xmluxe/*.dtd

rm /tmp/renderCss-xmluxe/*.xml

rm /tmp/renderCss-xmluxe/*.lmx

rm -f /tmp/renderCss-xmluxe/*.lmxv

rm -fr /tmp/renderCss-xmluxe/*lmxv*

rm /tmp/renderCss-xmluxe/*.lmxp

rm -f /tmp/renderCss-xmluxe/*.lmxe

cp /tmp/xmluxe-bloccoSelezionatoIntestato /tmp/renderCss-xmluxe/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xmluxe/renderedCss.css


#cd /tmp/renderCss-xmluxe

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingChoice.java

scelta=$(cat /tmp/xmluxe-parsingChoice)

for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xmluxe/renderedCss.xml

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

break
fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xmluxe/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)
	

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

break

fi

done

break

fi

######### Render title block
grep "^--renderCss-title=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRenderedR-title

stat --format %s /tmp/xmluxe-actionRenderedR-title > /tmp/xmluxe-actionRenderedR-titleBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderedR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionRenderedR-title | sed 's/.*=//g' > /tmp/xmluxe-idToRenderedR-title
	titleToRendered=$(cat /tmp/xmluxe-idToRenderedR-title)

/usr/local/bin/xmluxv -s --find-title="$titleToRendered" --f=$targetFile

grep "$titleToRendered$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToRenderedR

idToRenderedR="$(cat /tmp/xmluxe-idToRenderedR)"
	grep -n "ID=\"$idToRenderedR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedRBeginLine

nLineBeginIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedRBeginLine)

grep -n "<!-- end $idToRenderedR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderedREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderedR=$(cat /tmp/xmluxe-idToRenderedREndLine)

echo $nLineEndIdToRenderedR - $nLineBeginIdToRenderedR | bc > /tmp/xmluxe-linesToRendered

linesToRenderedR=$(cat /tmp/xmluxe-linesToRendered)

linesToRenderedRPlusComment=$(($linesToRenderedR + 1))

echo $(($nLineBeginIdToRenderedR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xmluxe-bloccoSelezionato

vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

linesToRenderedRPlus=$(($linesToRenderedR + 1))

echo  "$linesToRenderedRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xmluxe-intestazione

cat /tmp/xmluxe-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xmluxe-intestazione01

cp /tmp/xmluxe-intestazione01 /tmp/xmluxe-intestazione


/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xmluxe-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xmluxe-notKin_elements

vim -s /tmp/xmluxe-commandDelFirstEtLastLine /tmp/xmluxe-notKin_elements


cat /tmp/xmluxe-notKin_elements | sed '/^$/d' | uniq > /tmp/xmluxe-ToCTree

grep "$idToRenderedR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-relativeElement

element=$(cat /tmp/xmluxe-relativeElement)
 

cat /tmp/xmluxe-ToCTree | grep -B 1000 "$element" > /tmp/xmluxe-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xmluxe-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure

rm -fr /tmp/xmluxe-ToCStructureSplit

mkdir  /tmp/xmluxe-ToCStructureSplit

split -l1 /tmp/xmluxe-ToCStructure /tmp/xmluxe-ToCStructureSplit/

declare -i var=0
for tocStructure in $(ls /tmp/xmluxe-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xmluxe-ToCStructureSplit/$tocStructure)

	if test "$leggoToC" == "synopsis"

	then
	
	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione
	echo "</$leggoToC>" >> /tmp/xmluxe-intestazione

	else

	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione

	echo "$leggoToC" > /tmp/xmluxe-inverseOrderToC-$var


	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xmluxe-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xmluxe-inverseOrderToC-$var /tmp/xmluxe-inverseOrder-$VarMenoUno > /tmp/xmluxe-inverseOrder-$var

		else
			cat /tmp/xmluxe-inverseOrderToC-$var > /tmp/xmluxe-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xmluxe-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xmluxe-inverseOrderToC-'n' per la synopsis.
done


rm -fr /tmp/xmluxe-inverseOrderToCSplit

mkdir /tmp/xmluxe-inverseOrderToCSplit

ls /tmp/xmluxe-inverseOrder-* | tail -n1 > /tmp/xmluxe-inverseOrder-finalLs

cat /tmp/xmluxe-inverseOrder-finalLs > /tmp/xmluxe-inverseOrder-final

inversedOrder=$(cat /tmp/xmluxe-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xmluxe-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xmluxe-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xmluxe-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xmluxe-bloccoSelezionato

done

cat /tmp/xmluxe-intestazione /tmp/xmluxe-bloccoSelezionato > /tmp/xmluxe-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xmluxe

mkdir /tmp/renderCss-xmluxe

cp -r . /tmp/renderCss-xmluxe/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xmluxe/*.back

rm /tmp/renderCss-xmluxe/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xmluxe/*.dtd

rm /tmp/renderCss-xmluxe/*.xml

rm /tmp/renderCss-xmluxe/*.lmx

rm -f /tmp/renderCss-xmluxe/*.lmxv

rm -fr /tmp/renderCss-xmluxe/*lmxv*

rm /tmp/renderCss-xmluxe/*.lmxp

rm -f /tmp/renderCss-xmluxe/*.lmxe

cp /tmp/xmluxe-bloccoSelezionatoIntestato /tmp/renderCss-xmluxe/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xmluxe/renderedCss.css


#cd /tmp/renderCss-xmluxe

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingChoice.java

scelta=$(cat /tmp/xmluxe-parsingChoice)


for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xmluxe/renderedCss.xml

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

break
fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xmluxe/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

fi

done

break

fi

done

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

	/usr/local/lib/xmlux/xmluxeScripts/lack/matter/matter-book-lack.sh

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

	break

fi

done

rm -fr /tmp/xmluxe*

exit

