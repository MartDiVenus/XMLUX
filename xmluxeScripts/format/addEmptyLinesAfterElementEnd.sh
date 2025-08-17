#!/bin/bash

rm -fr /tmp/xmluxef*

if [ -f /tmp/xmluxeTargetFile ]; then

	## se tale script fosse lanciato direttamente da xmluxe, allora
targetFile=$(cat /tmp/xmluxeTargetFile)

else
# altrimenti, se fosse lanciato dallo script sorting ...
	targetFile=$(cat /tmp/xmluxse-targetFile)

fi

grep "end .*-->" $targetFile.lmx > /tmp/xmluxef-leChiusure

mkdir /tmp/xmluxef-container

split -l1 /tmp/xmluxef-leChiusure /tmp/xmluxef-container/

for chiusure in $(ls /tmp/xmluxef-container/)

do

cat /tmp/xmluxef-container/$chiusure | sed 's/.*end//g' | sed 's/-->//g' | sed 's/ //g' > /tmp/xmluxef-id

leggoID=$(cat /tmp/xmluxef-id)


echo "#!/bin/bash

cat $targetFile.lmx | sed 's/'end\ $leggoID\ \-\-\>'/end\ $leggoID --\>\n/g' > /tmp/xmluxef-newFile

exit
" > selectId.sh

chmod uga+xr selectId.sh


./selectId.sh

sleep 0.5

rm selectId.sh

cp /tmp/xmluxef-newFile $targetFile.lmx

done

rm -fr /tmp/xmluxef*

exit

