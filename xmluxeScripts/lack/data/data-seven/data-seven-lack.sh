#!/bin/bash

targetFile="$(cat /tmp/xmluxeTargetFile)"


xmluxv -s -ie --f=$targetFile

sleep 1

############ GRADUSI

	grep " gradusI$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyGradusI
	
	rm -fr /tmp/xmlux-onlyGradusISplit

	mkdir /tmp/xmlux-onlyGradusISplit

	split -l1 /tmp/xmlux-onlyGradusI /tmp/xmlux-onlyGradusISplit/

	declare -i gradusICount=0

	for allGradusI in $(ls /tmp/xmlux-onlyGradusISplit)

	do

		gradusICount=gradusICount+1

		leggoGradusI=$(cat /tmp/xmlux-onlyGradusISplit/$allGradusI)

		cat /tmp/xmlux-onlyGradusISplit/$allGradusI | awk '$1 > 0 {print $1}' > /tmp/xmlux-idGradusI

		idGradusI=$(cat /tmp/xmlux-idGradusI)

		cat /tmp/xmlux-idGradusI | sed 's/^.//g' | sed 's/^0//g' > /tmp/xmlux-gradusISubId

gradusISubId=$(cat /tmp/xmlux-gradusISubId)

	## if A01
	if ! test "$gradusISubId" == "1"

	then

		##  if A01.01
		if [ ! -f /tmp/xmluxe-firstGradusICount ]; then


		gradusIScarto=1	

		##  if A01.01.01
	#	if ! test $gradusIScarto -eq 0

	#	then
		
			/usr/local/bin/xmluxe -s --move=$idGradusI -b$gradusIScarto --f=$targetFile

			touch /tmp/xmluxe-firstGradusICount
		## fi A01.01.01
	#	fi

#		touch /tmp/xmlux-gradusIFirstOrder


## else A01.01
else

		gradusIScarto=$(($gradusISubId - $gradusICount))	
		
		### if A01.01.02
		if ! test $gradusIScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idGradusI -b$gradusIScarto --f=$targetFile

		### fi A01.01.02
		fi

## A01.01
fi

## fi A01
fi

############ GRADUSII

	grep "$idGradusI.* gradusII$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyGradusII

	stat --format %s /tmp/xmlux-onlyGradusII > /tmp/xmlux-GradusIIsExist

	gradusIIsExist=$(cat /tmp/xmlux-GradusIIsExist)

	## A01.02
	if test $gradusIIsExist -gt 0

	then

	rm -fr /tmp/xmlux-onlyGradusIISplit

	mkdir /tmp/xmlux-onlyGradusIISplit

	split -l1 /tmp/xmlux-onlyGradusII /tmp/xmlux-onlyGradusIISplit/

	declare -i gradusIICount=0

	for allGradusII in $(ls /tmp/xmlux-onlyGradusIISplit)

	do

		gradusIICount=gradusIICount+1

		leggoGradusII=$(cat /tmp/xmlux-onlyGradusIISplit/$allGradusII)

		cat /tmp/xmlux-onlyGradusIISplit/$allGradusII | awk '$1 > 0 {print $1}' > /tmp/xmlux-idGradusII

		idGradusII=$(cat /tmp/xmlux-idGradusII)
		
cat /tmp/xmlux-idGradusII | sed 's/\.[^\.]*$//' > /tmp/xmluxe-gradusIIIDPrefix

gradusIIPrefix="$(cat /tmp/xmluxe-gradusIIIDPrefix)"

cat /tmp/xmlux-idGradusII | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-gradusIISubId

gradusIISubId=$(cat /tmp/xmluxe-gradusIISubId)

## if A01.02.01
	if ! test "$gradusIISubId" == "1"

	then

## if A01.02.01.01
		if [ ! -f /tmp/xmluxe-firstGradusIICount ]; then

		gradusIIScarto=1

		## if A01.02.01.01.01
#		if ! test $gradusIIScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idGradusII -b$gradusIIScarto --f=$targetFile

			touch /tmp/xmluxe-firstGradusIICount
			## fi A01.02.01.01.01
#		fi
		
		## else A01.02.01.01
else

		gradusIIScarto=$(($gradusIISubId - $gradusIICount))	

		## if A01.02.01.01.02
		if ! test $gradusIIScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idGradusII -b$gradusIIScarto --f=$targetFile

		## fi A01.02.01.01.02
		fi

		## fi A01.02.01.01
	fi

## fi A01.02.01
fi


############ GRADUSIII

grep "$idGradusII.* gradusIII$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlygradusIII

stat --format %s /tmp/xmlux-onlygradusIII > /tmp/xmlux-gradusIIIsExist

gradusIIIsExist=$(cat /tmp/xmlux-gradusIIIsExist)

## if A01.02.02
if test $gradusIIIsExist -gt 0

then

	rm -fr /tmp/xmlux-onlygradusIIISplit

	mkdir /tmp/xmlux-onlygradusIIISplit

	split -l1 /tmp/xmlux-onlygradusIII /tmp/xmlux-onlygradusIIISplit/

	declare -i gradusIIICount=0

	for allgradusIII in $(ls /tmp/xmlux-onlygradusIIISplit)

	do

		gradusIIICount=gradusIIICount+1

		leggogradusIII=$(cat /tmp/xmlux-onlygradusIIISplit/$allgradusIII)

		cat /tmp/xmlux-onlygradusIIISplit/$allgradusIII | awk '$1 > 0 {print $1}' > /tmp/xmlux-idgradusIII

		idgradusIII=$(cat /tmp/xmlux-idgradusIII)
		
cat /tmp/xmlux-idgradusIII | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idgradusIII | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-gradusIIISubId

gradusIIISubId=$(cat /tmp/xmluxe-gradusIIISubId)

## if A01.02.02.01
	if ! test "$gradusIIISubId" == "1"

	then

## if A01.02.02.01.01
		if [ ! -f /tmp/xmluxe-firstgradusIIICount ]; then

		gradusIIIScarto=1	

		## if A01.02.02.01.01.01
#		if ! test $gradusIIIScarto -eq 0

#		then

			/usr/local/bin/xmluxe -s --move=$idgradusIII -b$gradusIIIScarto --f=$targetFile

		touch /tmp/xmluxe-firstgradusIIICount

		## fi A01.02.02.01.01.01
#		fi
		
		## else A01.02.02.01.01
else

		gradusIIIScarto=$(($gradusIIISubId - $gradusIIICount))	

		## if A01.02.02.01.01.02
		if ! test $gradusIIIScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idgradusIII -b$gradusIIIScarto --f=$targetFile

		## fi A01.02.02.01.01.02
		fi

		## fi A01.02.02.01.01
	fi

## fi A01.02.02.01
fi

############ GRADUSIV

grep "$idGradusIII.* gradusIV$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyGradusIV

stat --format %s /tmp/xmlux-onlyGradusIV > /tmp/xmlux-GradusIVsExist

gradusIVsExist=$(cat /tmp/xmlux-GradusIVsExist)

## if A01.02.02.01
if test $gradusIVsExist -gt 0

then

	rm -fr /tmp/xmlux-onlyGradusIVSplit

	mkdir /tmp/xmlux-onlyGradusIVSplit

	split -l1 /tmp/xmlux-onlyGradusIV /tmp/xmlux-onlyGradusIVSplit/

	declare -i gradusIVCount=0

	for allGradusIV in $(ls /tmp/xmlux-onlyGradusIVSplit)

	do

		gradusIVCount=gradusIVCount+1

		leggoGradusIV=$(cat /tmp/xmlux-onlyGradusIVSplit/$allGradusIV)

		cat /tmp/xmlux-onlyGradusIVSplit/$allGradusIV | awk '$1 > 0 {print $1}' > /tmp/xmlux-idGradusIV

		idGradusIV=$(cat /tmp/xmlux-idGradusIV)
		
cat /tmp/xmlux-idGradusIV | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idGradusIV | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-gradusIVSubId

gradusIVSubId=$(cat /tmp/xmluxe-gradusIVSubId)

## if A01.02.02.01.01
	if ! test "$gradusIVSubId" == "1"

	then

## if A01.02.02.01.01.01
		if [ ! -f /tmp/xmluxe-firstGradusIVCount ]; then

		gradusIVScarto=1	

		## if A01.02.02.01.01.01.01
#		if ! test $gradusIVScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idGradusIV -b$gradusIVScarto --f=$targetFile

		touch /tmp/xmluxe-firstGradusIVCount

		## fi A01.02.02.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01
else

		gradusIVScarto=$(($gradusIVSubId - $gradusIVCount))	

		## if A01.02.02.01.01.02.01
		if ! test $gradusIVScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idGradusIV -b$gradusIVScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01
		fi

		## fi A01.02.02.01.01.01
	fi

## fi A01.02.02.01.01
fi

############ GRADUSV

grep "$idGradusIV.* subparagraph$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyGradusV

stat --format %s /tmp/xmlux-onlyGradusV > /tmp/xmlux-GradusVsExist

subparagraphsExist=$(cat /tmp/xmlux-GradusVsExist)

## if A01.02.02.01.01
if test $subparagraphsExist -gt 0

then

	rm -fr /tmp/xmlux-onlyGradusVSplit

	mkdir /tmp/xmlux-onlyGradusVSplit

	split -l1 /tmp/xmlux-onlyGradusV /tmp/xmlux-onlyGradusVSplit/

	declare -i subparagraphCount=0

	for allGradusV in $(ls /tmp/xmlux-onlyGradusVSplit)

	do

		subparagraphCount=subparagraphCount+1

		leggoGradusV=$(cat /tmp/xmlux-onlyGradusVSplit/$allGradusV)

		cat /tmp/xmlux-onlyGradusVSplit/$allGradusV | awk '$1 > 0 {print $1}' > /tmp/xmlux-idGradusV

		idGradusV=$(cat /tmp/xmlux-idGradusV)
		
cat /tmp/xmlux-idGradusV | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idGradusV | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subparagraphSubId

subparagraphSubId=$(cat /tmp/xmluxe-subparagraphSubId)

## if A01.02.02.01.01.01
	if ! test "$subparagraphSubId" == "1"

	then

## if A01.02.02.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstGradusVCount ]; then

		subparagraphScarto=1	

		## if A01.02.02.01.01.01.01.01
#		if ! test $subparagraphScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idGradusV -b$subparagraphScarto --f=$targetFile

		touch /tmp/xmluxe-firstGradusVCount

		## fi A01.02.02.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01
else

		subparagraphScarto=$(($subparagraphSubId - $subparagraphCount))	

		## if A01.02.02.01.01.02.01.01
		if ! test $subparagraphScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idGradusV -b$subparagraphScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01
		fi

		## fi A01.02.02.01.01.01.01
	fi

## fi A01.02.02.01.01.01
fi

############ GRADUSVI

grep "$idGradusV.* gradusVI$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyGradusVI

stat --format %s /tmp/xmlux-onlyGradusVI > /tmp/xmlux-GradusVIsExist

saxumsExist=$(cat /tmp/xmlux-GradusVIsExist)

## if A01.02.02.01.01.01
if test $saxumsExist -gt 0

then

	rm -fr /tmp/xmlux-onlyGradusVISplit

	mkdir /tmp/xmlux-onlyGradusVISplit

	split -l1 /tmp/xmlux-onlyGradusVI /tmp/xmlux-onlyGradusVISplit/

	declare -i saxumCount=0

	for allGradusVI in $(ls /tmp/xmlux-onlyGradusVISplit)

	do

		saxumCount=saxumCount+1

		leggoGradusVI=$(cat /tmp/xmlux-onlyGradusVISplit/$allGradusVI)

		cat /tmp/xmlux-onlyGradusVISplit/$allGradusVI | awk '$1 > 0 {print $1}' > /tmp/xmlux-idGradusVI

		idGradusVI=$(cat /tmp/xmlux-idGradusVI)
		
cat /tmp/xmlux-idGradusVI | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idGradusVI | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-saxumSubId

saxumSubId=$(cat /tmp/xmluxe-saxumSubId)

## if A01.02.02.01.01.01.01
	if ! test "$saxumSubId" == "1"

	then

## if A01.02.02.01.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstGradusVICount ]; then

		saxumScarto=1	

		## if A01.02.02.01.01.01.01.01.01
#		if ! test $saxumScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idGradusVI -b$saxumScarto --f=$targetFile

		touch /tmp/xmluxe-firstGradusVICount

		## fi A01.02.02.01.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01.01
else

		saxumScarto=$(($saxumSubId - $saxumCount))	

		## if A01.02.02.01.01.02.01.01.01
		if ! test $saxumScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idGradusVI -b$saxumScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01.01
		fi

		## fi A01.02.02.01.01.01.01.01
	fi

## fi A01.02.02.01.01.01.01
fi

############ GRADUSVII

grep "$idGradusVII.* subsaxum$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyGradusVII

stat --format %s /tmp/xmlux-onlyGradusVII > /tmp/xmlux-GradusVIIsExist

subsaxumsExist=$(cat /tmp/xmlux-GradusVIIsExist)

## if A01.02.02.01.01.01
if test $subsaxumsExist -gt 0

then

	rm -fr /tmp/xmlux-onlyGradusVIISplit

	mkdir /tmp/xmlux-onlyGradusVIISplit

	split -l1 /tmp/xmlux-onlyGradusVII /tmp/xmlux-onlyGradusVIISplit/

	declare -i subsaxumCount=0

	for allGradusVII in $(ls /tmp/xmlux-onlyGradusVIISplit)

	do

		subsaxumCount=subsaxumCount+1

		leggoGradusVII=$(cat /tmp/xmlux-onlyGradusVIISplit/$allGradusVII)

		cat /tmp/xmlux-onlyGradusVIISplit/$allGradusVII | awk '$1 > 0 {print $1}' > /tmp/xmlux-idGradusVII

		idGradusVII=$(cat /tmp/xmlux-idGradusVII)
		
cat /tmp/xmlux-idGradusVII | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idGradusVII | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subsaxumSubId

subsaxumSubId=$(cat /tmp/xmluxe-subsaxumSubId)

## if A01.02.02.01.01.01.01
	if ! test "$subsaxumSubId" == "1"

	then

## if A01.02.02.01.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstGradusVIICount ]; then

		subsaxumScarto=1	

		## if A01.02.02.01.01.01.01.01.01
#		if ! test $subsaxumScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idGradusVII -b$subsaxumScarto --f=$targetFile

		touch /tmp/xmluxe-firstGradusVIICount

		## fi A01.02.02.01.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01.01
else

		subsaxumScarto=$(($subsaxumSubId - $subsaxumCount))	

		## if A01.02.02.01.01.02.01.01.01
		if ! test $subsaxumScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idGradusVII -b$subsaxumScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01.01
		fi

		## fi A01.02.02.01.01.01.01.01
	fi

## fi A01.02.02.01.01.01.01
fi

### done GRADUSVII
done


### fine GRADUSVII
## fi A01.02.02.01.01.01
fi 


### done GRADUSVI
done


### fine GRADUSVI
## fi A01.02.02.01.01.01
fi 


### done GRADUSV
done

### fine GRADUSV	
## fi A01.02.02.01.01
fi 


### done GRADUSIV

done

### fine GRADUSIV
## fi A01.02.02.01
fi 


### done GRADUSIII
done

### fine GRADUSIII
## fi A01.02.02
fi 


### done GRADUSII
done

### fine GRADUSII
# fi A01.02
	fi


	### fine GRADUSI

	## Invece, /tmp/xmluxe-firstGradusICount
	# non va mai eliminato, perché genitore di tutti i subelementi

	rm -f /tmp/xmluxe-firstGradusIICount
	
	rm -f /tmp/xmluxe-firstGradusIIICount
	
	rm -f /tmp/xmluxe-firstGradusIVCount
	
	rm -f /tmp/xmluxe-firstGradusVCount
	
	rm -f /tmp/xmluxe-firstGradusVICount
	
	rm -f /tmp/xmluxe-firstGradusVIICount
	### done fine SECTION
done


exit


