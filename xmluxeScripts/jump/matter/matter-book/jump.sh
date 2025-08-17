#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

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

exit

