#!/bin/bash

targetFile="$(cat /tmp/xmluxeTargetFile)"


xmluxv -s -ie --f=$targetFile

sleep 1

############ SECTION

	grep " section$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySection
	
	rm -fr /tmp/xmlux-onlySectionSplit

	mkdir /tmp/xmlux-onlySectionSplit

	split -l1 /tmp/xmlux-onlySection /tmp/xmlux-onlySectionSplit/

	declare -i sectionCount=0

	for allSection in $(ls /tmp/xmlux-onlySectionSplit)

	do

		sectionCount=sectionCount+1

		leggoSection=$(cat /tmp/xmlux-onlySectionSplit/$allSection)

		cat /tmp/xmlux-onlySectionSplit/$allSection | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSection

		idSection=$(cat /tmp/xmlux-idSection)

		cat /tmp/xmlux-idSection | sed 's/^.//g' | sed 's/^0//g' > /tmp/xmlux-sectionSubId

sectionSubId=$(cat /tmp/xmlux-sectionSubId)

	## if A01
	if ! test "$sectionSubId" == "1"

	then

		##  if A01.01
		if [ ! -f /tmp/xmluxe-firstSectionCount ]; then


		sectionScarto=1	

		##  if A01.01.01
	#	if ! test $sectionScarto -eq 0

	#	then
		
			/usr/local/bin/xmluxe -s --move=$idSection -b$sectionScarto --f=$targetFile

			touch /tmp/xmluxe-firstSectionCount
		## fi A01.01.01
	#	fi

#		touch /tmp/xmlux-sectionFirstOrder


## else A01.01
else

		sectionScarto=$(($sectionSubId - $sectionCount))	
		
		### if A01.01.02
		if ! test $sectionScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSection -b$sectionScarto --f=$targetFile

		### fi A01.01.02
		fi

## A01.01
fi

## fi A01
fi

############ SUBSECTION

	grep "$idSection.* subsection$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubsection

	stat --format %s /tmp/xmlux-onlySubsection > /tmp/xmlux-SubsectionsExist

	subsectionsExist=$(cat /tmp/xmlux-SubsectionsExist)

	## A01.02
	if test $subsectionsExist -gt 0

	then

	rm -fr /tmp/xmlux-onlySubsectionSplit

	mkdir /tmp/xmlux-onlySubsectionSplit

	split -l1 /tmp/xmlux-onlySubsection /tmp/xmlux-onlySubsectionSplit/

	declare -i subsectionCount=0

	for allSubsection in $(ls /tmp/xmlux-onlySubsectionSplit)

	do

		subsectionCount=subsectionCount+1

		leggoSubsection=$(cat /tmp/xmlux-onlySubsectionSplit/$allSubsection)

		cat /tmp/xmlux-onlySubsectionSplit/$allSubsection | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSubsection

		idSubsection=$(cat /tmp/xmlux-idSubsection)
		
cat /tmp/xmlux-idSubsection | sed 's/\.[^\.]*$//' > /tmp/xmluxe-subsectionIDPrefix

subsectionPrefix="$(cat /tmp/xmluxe-subsectionIDPrefix)"

cat /tmp/xmlux-idSubsection | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subsectionSubId

subsectionSubId=$(cat /tmp/xmluxe-subsectionSubId)

## if A01.02.01
	if ! test "$subsectionSubId" == "1"

	then

## if A01.02.01.01
		if [ ! -f /tmp/xmluxe-firstSubsectionCount ]; then

		subsectionScarto=1

		## if A01.02.01.01.01
#		if ! test $subsectionScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSubsection -b$subsectionScarto --f=$targetFile

			touch /tmp/xmluxe-firstSubsectionCount
			## fi A01.02.01.01.01
#		fi
		
		## else A01.02.01.01
else

		subsectionScarto=$(($subsectionSubId - $subsectionCount))	

		## if A01.02.01.01.02
		if ! test $subsectionScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubsection -b$subsectionScarto --f=$targetFile

		## fi A01.02.01.01.02
		fi

		## fi A01.02.01.01
	fi

## fi A01.02.01
fi


############ SUBSUBSECTION

grep "$idSubsection.* subsubsection$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubsubsection

stat --format %s /tmp/xmlux-onlySubsubsection > /tmp/xmlux-SubsubsectionsExist

subsubsectionsExist=$(cat /tmp/xmlux-SubsubsectionsExist)

## if A01.02.02
if test $subsubsectionsExist -gt 0

then

	rm -fr /tmp/xmlux-onlySubsubsectionSplit

	mkdir /tmp/xmlux-onlySubsubsectionSplit

	split -l1 /tmp/xmlux-onlySubsubsection /tmp/xmlux-onlySubsubsectionSplit/

	declare -i subsubsectionCount=0

	for allSubsubsection in $(ls /tmp/xmlux-onlySubsubsectionSplit)

	do

		subsubsectionCount=subsubsectionCount+1

		leggoSubsubsection=$(cat /tmp/xmlux-onlySubsubsectionSplit/$allSubsubsection)

		cat /tmp/xmlux-onlySubsubsectionSplit/$allSubsubsection | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSubsubsection

		idSubsubsection=$(cat /tmp/xmlux-idSubsubsection)
		
cat /tmp/xmlux-idSubsubsection | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idSubsubsection | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subsubsectionSubId

subsubsectionSubId=$(cat /tmp/xmluxe-subsubsectionSubId)

## if A01.02.02.01
	if ! test "$subsubsectionSubId" == "1"

	then

## if A01.02.02.01.01
		if [ ! -f /tmp/xmluxe-firstSubsubsectionCount ]; then

		subsubsectionScarto=1	

		## if A01.02.02.01.01.01
#		if ! test $subsubsectionScarto -eq 0

#		then

			/usr/local/bin/xmluxe -s --move=$idSubsubsection -b$subsubsectionScarto --f=$targetFile

		touch /tmp/xmluxe-firstSubsubsectionCount

		## fi A01.02.02.01.01.01
#		fi
		
		## else A01.02.02.01.01
else

		subsubsectionScarto=$(($subsubsectionSubId - $subsubsectionCount))	

		## if A01.02.02.01.01.02
		if ! test $subsubsectionScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubsubsection -b$subsubsectionScarto --f=$targetFile

		## fi A01.02.02.01.01.02
		fi

		## fi A01.02.02.01.01
	fi

## fi A01.02.02.01
fi

############ PARAGRAPH

grep "$idSubsubsection.* paragraph$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyParagraph

stat --format %s /tmp/xmlux-onlyParagraph > /tmp/xmlux-ParagraphsExist

paragraphsExist=$(cat /tmp/xmlux-ParagraphsExist)

## if A01.02.02.01
if test $paragraphsExist -gt 0

then

	rm -fr /tmp/xmlux-onlyParagraphSplit

	mkdir /tmp/xmlux-onlyParagraphSplit

	split -l1 /tmp/xmlux-onlyParagraph /tmp/xmlux-onlyParagraphSplit/

	declare -i paragraphCount=0

	for allParagraph in $(ls /tmp/xmlux-onlyParagraphSplit)

	do

		paragraphCount=paragraphCount+1

		leggoParagraph=$(cat /tmp/xmlux-onlyParagraphSplit/$allParagraph)

		cat /tmp/xmlux-onlyParagraphSplit/$allParagraph | awk '$1 > 0 {print $1}' > /tmp/xmlux-idParagraph

		idParagraph=$(cat /tmp/xmlux-idParagraph)
		
cat /tmp/xmlux-idParagraph | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idParagraph | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-paragraphSubId

paragraphSubId=$(cat /tmp/xmluxe-paragraphSubId)

## if A01.02.02.01.01
	if ! test "$paragraphSubId" == "1"

	then

## if A01.02.02.01.01.01
		if [ ! -f /tmp/xmluxe-firstParagraphCount ]; then

		paragraphScarto=1	

		## if A01.02.02.01.01.01.01
#		if ! test $paragraphScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idParagraph -b$paragraphScarto --f=$targetFile

		touch /tmp/xmluxe-firstParagraphCount

		## fi A01.02.02.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01
else

		paragraphScarto=$(($paragraphSubId - $paragraphCount))	

		## if A01.02.02.01.01.02.01
		if ! test $paragraphScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idParagraph -b$paragraphScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01
		fi

		## fi A01.02.02.01.01.01
	fi

## fi A01.02.02.01.01
fi

############ SUBPARAGRAPH

grep "$idParagraph.* subparagraph$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubparagraph

stat --format %s /tmp/xmlux-onlySubparagraph > /tmp/xmlux-SubparagraphsExist

subparagraphsExist=$(cat /tmp/xmlux-SubparagraphsExist)

## if A01.02.02.01.01
if test $subparagraphsExist -gt 0

then

	rm -fr /tmp/xmlux-onlySubparagraphSplit

	mkdir /tmp/xmlux-onlySubparagraphSplit

	split -l1 /tmp/xmlux-onlySubparagraph /tmp/xmlux-onlySubparagraphSplit/

	declare -i subparagraphCount=0

	for allSubparagraph in $(ls /tmp/xmlux-onlySubparagraphSplit)

	do

		subparagraphCount=subparagraphCount+1

		leggoSubparagraph=$(cat /tmp/xmlux-onlySubparagraphSplit/$allSubparagraph)

		cat /tmp/xmlux-onlySubparagraphSplit/$allSubparagraph | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSubparagraph

		idSubparagraph=$(cat /tmp/xmlux-idSubparagraph)
		
cat /tmp/xmlux-idSubparagraph | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idSubparagraph | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subparagraphSubId

subparagraphSubId=$(cat /tmp/xmluxe-subparagraphSubId)

## if A01.02.02.01.01.01
	if ! test "$subparagraphSubId" == "1"

	then

## if A01.02.02.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstSubparagraphCount ]; then

		subparagraphScarto=1	

		## if A01.02.02.01.01.01.01.01
#		if ! test $subparagraphScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSubparagraph -b$subparagraphScarto --f=$targetFile

		touch /tmp/xmluxe-firstSubparagraphCount

		## fi A01.02.02.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01
else

		subparagraphScarto=$(($subparagraphSubId - $subparagraphCount))	

		## if A01.02.02.01.01.02.01.01
		if ! test $subparagraphScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubparagraph -b$subparagraphScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01
		fi

		## fi A01.02.02.01.01.01.01
	fi

## fi A01.02.02.01.01.01
fi

############ SAXUM

grep "$idSubparagraph.* saxum$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySaxum

stat --format %s /tmp/xmlux-onlySaxum > /tmp/xmlux-SaxumsExist

saxumsExist=$(cat /tmp/xmlux-SaxumsExist)

## if A01.02.02.01.01.01
if test $saxumsExist -gt 0

then

	rm -fr /tmp/xmlux-onlySaxumSplit

	mkdir /tmp/xmlux-onlySaxumSplit

	split -l1 /tmp/xmlux-onlySaxum /tmp/xmlux-onlySaxumSplit/

	declare -i saxumCount=0

	for allSaxum in $(ls /tmp/xmlux-onlySaxumSplit)

	do

		saxumCount=saxumCount+1

		leggoSaxum=$(cat /tmp/xmlux-onlySaxumSplit/$allSaxum)

		cat /tmp/xmlux-onlySaxumSplit/$allSaxum | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSaxum

		idSaxum=$(cat /tmp/xmlux-idSaxum)
		
cat /tmp/xmlux-idSaxum | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idSaxum | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-saxumSubId

saxumSubId=$(cat /tmp/xmluxe-saxumSubId)

## if A01.02.02.01.01.01.01
	if ! test "$saxumSubId" == "1"

	then

## if A01.02.02.01.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstSaxumCount ]; then

		saxumScarto=1	

		## if A01.02.02.01.01.01.01.01.01
#		if ! test $saxumScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSaxum -b$saxumScarto --f=$targetFile

		touch /tmp/xmluxe-firstSaxumCount

		## fi A01.02.02.01.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01.01
else

		saxumScarto=$(($saxumSubId - $saxumCount))	

		## if A01.02.02.01.01.02.01.01.01
		if ! test $saxumScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSaxum -b$saxumScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01.01
		fi

		## fi A01.02.02.01.01.01.01.01
	fi

## fi A01.02.02.01.01.01.01
fi

############ SUBSAXUM

grep "$idSubsaxum.* subsaxum$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubsaxum

stat --format %s /tmp/xmlux-onlySubsaxum > /tmp/xmlux-SubsaxumsExist

subsaxumsExist=$(cat /tmp/xmlux-SubsaxumsExist)

## if A01.02.02.01.01.01
if test $subsaxumsExist -gt 0

then

	rm -fr /tmp/xmlux-onlySubsaxumSplit

	mkdir /tmp/xmlux-onlySubsaxumSplit

	split -l1 /tmp/xmlux-onlySubsaxum /tmp/xmlux-onlySubsaxumSplit/

	declare -i subsaxumCount=0

	for allSubsaxum in $(ls /tmp/xmlux-onlySubsaxumSplit)

	do

		subsaxumCount=subsaxumCount+1

		leggoSubsaxum=$(cat /tmp/xmlux-onlySubsaxumSplit/$allSubsaxum)

		cat /tmp/xmlux-onlySubsaxumSplit/$allSubsaxum | awk '$1 > 0 {print $1}' > /tmp/xmlux-idSubsaxum

		idSubsaxum=$(cat /tmp/xmlux-idSubsaxum)
		
cat /tmp/xmlux-idSubsaxum | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idSubsaxum | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subsaxumSubId

subsaxumSubId=$(cat /tmp/xmluxe-subsaxumSubId)

## if A01.02.02.01.01.01.01
	if ! test "$subsaxumSubId" == "1"

	then

## if A01.02.02.01.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstSubsaxumCount ]; then

		subsaxumScarto=1	

		## if A01.02.02.01.01.01.01.01.01
#		if ! test $subsaxumScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSubsaxum -b$subsaxumScarto --f=$targetFile

		touch /tmp/xmluxe-firstSubsaxumCount

		## fi A01.02.02.01.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01.01
else

		subsaxumScarto=$(($subsaxumSubId - $subsaxumCount))	

		## if A01.02.02.01.01.02.01.01.01
		if ! test $subsaxumScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubsaxum -b$subsaxumScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01.01
		fi

		## fi A01.02.02.01.01.01.01.01
	fi

## fi A01.02.02.01.01.01.01
fi

### done SUBSAXUM
done


### fine SUBSAXUM
## fi A01.02.02.01.01.01
fi 


### done SAXUM
done


### fine SAXUM
## fi A01.02.02.01.01.01
fi 


### done SUBPARAGRAPH
done

### fine SUBPARAGRAPH
## fi A01.02.02.01.01
fi 


### done PARAGRAPH
done

### fine PARAGRAPH
## fi A01.02.02.01
fi 


### done SUBSUBSECTION
done

### fine SUBSUBSECTION
## fi A01.02.02
fi 


### done SUBSECTION
done

### fine SUBSECTION
# fi A01.02
	fi


	### fine SECTION

	## Invece, /tmp/xmluxe-firstSectionCount
	# non va mai eliminato, perché genitore di tutti i subelementi
	rm -f /tmp/xmluxe-firstSubsectionCount

	rm -f /tmp/xmluxe-firstSubsubsectionCount
	
	rm -f /tmp/xmluxe-firstParagraphCount
	
	rm -f /tmp/xmluxe-firstSubparagraphCount
	
	rm -f /tmp/xmluxe-firstSaxumCount
	
	rm -f /tmp/xmluxe-firstSubsaxumCount
	### done fine SECTION
done


exit

