#!/bin/bash

## Non ha senso eliminare i vuoti tra le Key, e i Value in quanto
# gli Item possono avere ciascuno solo una coppia di Key e Value.

targetFile="$(cat /tmp/xmluxeTargetFile)"

xmluxv -s -ie --f=$targetFile

sleep 1

############ SERIES

	grep " Series$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySeries
	
	rm -fr /tmp/xmlux-onlySeriesSplit

	mkdir /tmp/xmlux-onlySeriesSplit

	split -l1 /tmp/xmlux-onlySeries /tmp/xmlux-onlySeriesSplit/

	declare -i seriesCount=0

	for allSeries in $(ls /tmp/xmlux-onlySeriesSplit)

	do

		seriesCount=seriesCount+1

		leggoSeries=$(cat /tmp/xmlux-onlySeriesSplit/$allSeries)

		cat /tmp/xmlux-onlySeriesSplit/$allSeries | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSeries

		idSeries=$(cat /tmp/xmlux-idSeries)

		cat /tmp/xmlux-idSeries | sed 's/^.//g' | sed 's/^0//g' > /tmp/xmlux-seriesSubId

seriesSubId=$(cat /tmp/xmlux-seriesSubId)


	## if A01
	if ! test "$seriesSubId" == "1"

	then

		##  if A01.01
		if [ ! -f /tmp/xmluxe-firstSeriesCount ]; then


		seriesScarto=1	

		##  if A01.01.01
	#	if ! test $seriesScarto -eq 0

	#	then
	
			/usr/local/bin/xmluxe -s --move=$idSeries -b$seriesScarto --f=$targetFile

			touch /tmp/xmluxe-firstSeriesCount
		## fi A01.01.01
	#	fi

#		touch /tmp/xmlux-seriesFirstOrder


## else A01.01
else

	seriesScarto=$(($seriesSubId - $seriesCount))	

		### if A01.01.02
		if ! test $seriesScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSeries -b$seriesScarto --f=$targetFile

		### fi A01.01.02
		fi

## A01.01
fi

## fi A01
fi

############ ITEM

	grep "$idSeries.* Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyItem

	stat --format %s /tmp/xmlux-onlyItem > /tmp/xmlux-ItemsExist

	itemsExist=$(cat /tmp/xmlux-ItemsExist)

	## A01.02
	if test $itemsExist -gt 0

	then

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
		
cat /tmp/xmlux-idItem | sed 's/\.[^\.]*$//' > /tmp/xmluxe-itemIDPrefix

itemPrefix="$(cat /tmp/xmluxe-itemIDPrefix)"

cat /tmp/xmlux-idItem | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-itemSubId

itemSubId=$(cat /tmp/xmluxe-itemSubId)

## if A01.02.01
	if ! test "$itemSubId" == "1"

	then

## if A01.02.01.01
		if [ ! -f /tmp/xmluxe-firstItemCount ]; then

		itemScarto=1

		## if A01.02.01.01.01
#		if ! test $itemScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idItem -b$itemScarto --f=$targetFile

			touch /tmp/xmluxe-firstItemCount
			## fi A01.02.01.01.01
#		fi
		
		## else A01.02.01.01
else

		itemScarto=$(($itemSubId - $itemCount))	

		## if A01.02.01.01.02
		if ! test $itemScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idItem -b$itemScarto --f=$targetFile

		## fi A01.02.01.01.02
		fi

		## fi A01.02.01.01
	fi

## fi A01.02.01
fi

### done ITEM
done

### fine ITEM
# fi A01.02
	fi


	### fine SERIES

	## Invece, /tmp/xmluxe-firstSeriesCount
	# non va mai eliminato, perché genitore di tutti i subelementi
	rm -f /tmp/xmluxe-firstItemCount

	### done fine SERIES
done


exit


