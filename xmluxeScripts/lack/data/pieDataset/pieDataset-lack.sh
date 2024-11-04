#!/bin/bash

## Non ha senso eliminare i vuoti tra le Key, e i Value in quanto
# gli Item possono avere ciascuno solo una coppia di Key e Value.


targetFile="$(cat /tmp/xmluxeTargetFile)"

xmluxv -s -ie --f=$targetFile

sleep 1

############ ITEM

	grep " Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyItem
	
	rm -fr /tmp/xmlux-onlyItemSplit

	mkdir /tmp/xmlux-onlyItemSplit

	split -l1 /tmp/xmlux-onlyItem /tmp/xmlux-onlyItemSplit/

	declare -i itemCount=0

	for allItem in $(ls /tmp/xmlux-onlyItemSplit)

	do

		itemCount=itemCount+1

		leggoItem=$(cat /tmp/xmlux-onlyItemSplit/$allItem)

		cat /tmp/xmlux-onlyItemSplit/$allItem | awk '$1 > 0 {print $1}' > /tmp/xmlux-idItem

		idItem=$(cat /tmp/xmlux-idItem)

		cat /tmp/xmlux-idItem | sed 's/^.//g' | sed 's/^0//g' > /tmp/xmlux-itemSubId

itemSubId=$(cat /tmp/xmlux-itemSubId)

	## if A01
	if ! test "$itemSubId" == "1"

	then

		##  if A01.01
		if [ ! -f /tmp/xmluxe-firstItemCount ]; then


		itemScarto=1	

		##  if A01.01.01
	#	if ! test $itemScarto -eq 0

	#	then
		
			/usr/local/bin/xmluxe -s --move=$idItem -b$itemScarto --f=$targetFile

			touch /tmp/xmluxe-firstItemCount
		## fi A01.01.01
	#	fi

#		touch /tmp/xmlux-itemFirstOrder


## else A01.01
else

		itemScarto=$(($itemSubId - $itemCount))	
		
		### if A01.01.02
		if ! test $itemScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idItem -b$itemScarto --f=$targetFile

		### fi A01.01.02
		fi

## A01.01
fi

## fi A01
fi

	### fine ITEM

	## Invece, /tmp/xmluxe-firstItemCount
	# non va mai eliminato, perché genitore di tutti i subelementi
	rm -f /tmp/xmluxe-firstItemCount

	### done fine ITEM
done


exit


