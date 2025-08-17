
--------------- 273 
if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

#grep "^$leggoGradusI " $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $2}' > /tmp/insXmluxe-element

#element=$(cat /tmp/insXmluxe-element)

touch /tmp/xmluxe-cimiceCategoryDataset02-series

grep " Series$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | tail -n1 > /tmp/insXmluxe-lastID

 ...

break

fi

____________________________________________________________________


------------------ 451
if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

#grep "Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv |  awk '$1 > 0 {print $1}' | grep "^$leggoGradusI" > /tmp/insXmluxe-IDs

grep "Item$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv | awk '$1 > 0 {print $1}' > /tmp/insXmluxe-IDs

touch /tmp/xmluxe-cimiceCategoryDataset02-items

...

break

fi

________________________________________________________________________


------------------ 1136
## Per gli Items delle category dataset02 il discorso è differente

if [ ! -f /tmp/xmluxe-cimiceCategoryDataset02-items ]; then


if [ -f /tmp/xmluxe-cimiceDotFrequencyZero ]; then

...

fi


newID="$prefix.$subIdL"

		fi

fi

_____________________________________________________________

-------------------- 2813

if [ -f /tmp/xmluxe-cimiceCategoryDataset02 ]; then

	## Per i category dataset02 si possono inserire o Series (dotFrequency = 0)
	## o Items (dotFrequency = 1); non avrebbe senso inserire Keys o Values direttamente, ma
	## ha senso solo inserire Keys e Values all'interno di Series o Items.
	if [ -f /tmp/xmluxe-cimiceCategoryDataset02-series ]; then 	

	leggoDotFrequency=0

else

	leggoDotFrequency=1

	fi


...

fi

done

break

fi

done

break

fi

