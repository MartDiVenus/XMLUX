#!/bin/bash

## I condizionali e.g.
# if [ -f /tmp/xmluxe-elementSubsection ]; then
# servirebbero se non uniformassi le document class, ma li commento perché ho 
# scelto di uniformarle.
		
targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

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

/usr/local/lib/xmlux/xmluxeScripts/lack/brief/brief-book-lack.sh

fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

exit

