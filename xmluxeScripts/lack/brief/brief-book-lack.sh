#!/bin/bash

targetFile="$(cat /tmp/xmluxeTargetFile)"


xmluxv -s -ie --f=$targetFile

sleep 1

############ PART

	grep " part$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyPart
	
	rm -fr /tmp/xmlux-onlyPartSplit

	mkdir /tmp/xmlux-onlyPartSplit

	split -l1 /tmp/xmlux-onlyPart /tmp/xmlux-onlyPartSplit/

	declare -i partCount=0

	for allPart in $(ls /tmp/xmlux-onlyPartSplit)

	do

		partCount=partCount+1

		leggoPart=$(cat /tmp/xmlux-onlyPartSplit/$allPart)

		cat /tmp/xmlux-onlyPartSplit/$allPart | awk '$1 > 0 {print $1}' > /tmp/xmlux-idPart

		idPart=$(cat /tmp/xmlux-idPart)

		cat /tmp/xmlux-idPart | sed 's/^.//g' | sed 's/^0//g' > /tmp/xmlux-partSubId

partSubId=$(cat /tmp/xmlux-partSubId)

	## if A01
	if ! test "$partSubId" == "1"

	then

		##  if A01.01
		if [ ! -f /tmp/xmluxe-firstPartCount ]; then

		partScarto=1	

		##  if A01.01.01
	#	if ! test $partScarto -eq 0

	#	then
		
			/usr/local/bin/xmluxe -s --move=$idPart -b$partScarto --f=$targetFile

			touch /tmp/xmluxe-firstPartCount
		## fi A01.01.01
	#	fi

#		touch /tmp/xmlux-partFirstOrder


## else A01.01
else

		partScarto=$(($partSubId - $partCount))	
		
		### if A01.01.02
		if ! test $partScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idPart -b$partScarto --f=$targetFile

		### fi A01.01.02
		fi

## A01.01
fi

## fi A01
fi

############ CHAPTER

	grep "$idPart.* chapter$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyChapter

	stat --format %s /tmp/xmlux-onlyChapter > /tmp/xmlux-ChaptersExist

	chaptersExist=$(cat /tmp/xmlux-ChaptersExist)

	## A01.02
	if test $chaptersExist -gt 0

	then

	rm -fr /tmp/xmlux-onlyChapterSplit

	mkdir /tmp/xmlux-onlyChapterSplit

	split -l1 /tmp/xmlux-onlyChapter /tmp/xmlux-onlyChapterSplit/

	declare -i chapterCount=0

	for allChapter in $(ls /tmp/xmlux-onlyChapterSplit)

	do

		chapterCount=chapterCount+1

		leggoChapter=$(cat /tmp/xmlux-onlyChapterSplit/$allChapter)

		cat /tmp/xmlux-onlyChapterSplit/$allChapter | awk '$1 > 0 {print $1}' > /tmp/xmlux-idChapter

		idChapter=$(cat /tmp/xmlux-idChapter)
		
cat /tmp/xmlux-idChapter | sed 's/\.[^\.]*$//' > /tmp/xmluxe-chapterIDPrefix

chapterPrefix="$(cat /tmp/xmluxe-chapterIDPrefix)"

cat /tmp/xmlux-idChapter | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-chapterSubId

chapterSubId=$(cat /tmp/xmluxe-chapterSubId)

## if A01.02.01
	if ! test "$chapterSubId" == "1"

	then

## if A01.02.01.01
		if [ ! -f /tmp/xmluxe-firstChapterCount ]; then

		chapterScarto=1

		## if A01.02.01.01.01
		#if ! test $chapterScarto -eq 0

		#then
	
			/usr/local/bin/xmluxe -s --move=$idChapter -b$chapterScarto --f=$targetFile

			touch /tmp/xmluxe-firstChapterCount
			## fi A01.02.01.01.01
		#fi
		
		## else A01.02.01.01
else

		chapterScarto=$(($chapterSubId - $chapterCount))	

		## if A01.02.01.01.02
		if ! test $chapterScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idChapter -b$chapterScarto --f=$targetFile

		## fi A01.02.01.01.02
		fi

		## fi A01.02.01.01
	fi

## fi A01.02.01
fi


############ SECTION

grep "$idChapter.* section$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySection

stat --format %s /tmp/xmlux-onlySection > /tmp/xmlux-SectionsExist

sectionsExist=$(cat /tmp/xmlux-SectionsExist)

## if A01.02.02
if test $sectionsExist -gt 0

then

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
		
cat /tmp/xmlux-idSection | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idSection | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-sectionSubId

sectionSubId=$(cat /tmp/xmluxe-sectionSubId)

## if A01.02.02.01
	if ! test "$sectionSubId" == "1"

	then

## if A01.02.02.01.01
		if [ ! -f /tmp/xmluxe-firstSectionCount ]; then

		sectionScarto=1	

		## if A01.02.02.01.01.01
	#	if ! test $sectionScarto -eq 0

	#	then

			/usr/local/bin/xmluxe -s --move=$idSection -b$sectionScarto --f=$targetFile

		touch /tmp/xmluxe-firstSectionCount

		## fi A01.02.02.01.01.01
	#	fi
		
		## else A01.02.02.01.01
else

		sectionScarto=$(($sectionSubId - $sectionCount))	

		## if A01.02.02.01.01.02
		if ! test $sectionScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSection -b$sectionScarto --f=$targetFile

		## fi A01.02.02.01.01.02
		fi

		## fi A01.02.02.01.01
	fi

## fi A01.02.02.01
fi

############ SUBSECTION

grep "$idSection.* subsection$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubsection

stat --format %s /tmp/xmlux-onlySubsection > /tmp/xmlux-SubsectionsExist

subsectionsExist=$(cat /tmp/xmlux-SubsectionsExist)

## if A01.02.02.01
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
		
cat /tmp/xmlux-idSubsection | sed 's/\.[^\.]*$//' > /tmp/xmluxe-IDPrefix

prefix="$(cat /tmp/xmluxe-IDPrefix)"

cat /tmp/xmlux-idSubsection | sed 's/.*\.//' | sed 's/^0//g' > /tmp/xmluxe-subsectionSubId

subsectionSubId=$(cat /tmp/xmluxe-subsectionSubId)

## if A01.02.02.01.01
	if ! test "$subsectionSubId" == "1"

	then

## if A01.02.02.01.01.01
		if [ ! -f /tmp/xmluxe-firstSubsectionCount ]; then

		subsectionScarto=1	

		## if A01.02.02.01.01.01.01
#		if ! test $subsectionScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSubsection -b$subsectionScarto --f=$targetFile

		touch /tmp/xmluxe-firstSubsectionCount

		## fi A01.02.02.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01
else

		subsectionScarto=$(($subsectionSubId - $subsectionCount))	

		## if A01.02.02.01.01.02.01
		if ! test $subsectionScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubsection -b$subsectionScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01
		fi

		## fi A01.02.02.01.01.01
	fi

## fi A01.02.02.01.01
fi

############ SUBSUBSECTION

grep "$idSubsection.* subsubsection$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubsubsection

stat --format %s /tmp/xmlux-onlySubsubsection > /tmp/xmlux-SubsubsectionsExist

subsubsectionsExist=$(cat /tmp/xmlux-SubsubsectionsExist)

## if A01.02.02.01.01
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

## if A01.02.02.01.01.01
	if ! test "$subsubsectionSubId" == "1"

	then

## if A01.02.02.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstSubsubsectionCount ]; then

		subsubsectionScarto=1	

		## if A01.02.02.01.01.01.01.01
#		if ! test $subsubsectionScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSubsubsection -b$subsubsectionScarto --f=$targetFile

		touch /tmp/xmluxe-firstSubsubsectionCount

		## fi A01.02.02.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01
else

		subsubsectionScarto=$(($subsubsectionSubId - $subsubsectionCount))	

		## if A01.02.02.01.01.02.01.01
		if ! test $subsubsectionScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubsubsection -b$subsubsectionScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01
		fi

		## fi A01.02.02.01.01.01.01
	fi

## fi A01.02.02.01.01.01
fi

############ PARAGRAPH

grep "$idSubsubsection.* paragraph$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlyParagraph

stat --format %s /tmp/xmlux-onlyParagraph > /tmp/xmlux-ParagraphsExist

paragraphsExist=$(cat /tmp/xmlux-ParagraphsExist)

## if A01.02.02.01.01.01
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

## if A01.02.02.01.01.01.01
	if ! test "$paragraphSubId" == "1"

	then

## if A01.02.02.01.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstParagraphCount ]; then

		paragraphScarto=1	

		## if A01.02.02.01.01.01.01.01.01
#		if ! test $paragraphScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idParagraph -b$paragraphScarto --f=$targetFile

		touch /tmp/xmluxe-firstParagraphCount

		## fi A01.02.02.01.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01.01
else

		paragraphScarto=$(($paragraphSubId - $paragraphCount))	

		## if A01.02.02.01.01.02.01.01.01
		if ! test $paragraphScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idParagraph -b$paragraphScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01.01
		fi

		## fi A01.02.02.01.01.01.01.01
	fi

## fi A01.02.02.01.01.01.01
fi

############ SUBPARAGRAPH

grep "$idParagraph.* subparagraph$" $targetFile-lmxv/kin/$targetFile-ids-elements.lmxv > /tmp/xmlux-onlySubparagraph

stat --format %s /tmp/xmlux-onlySubparagraph > /tmp/xmlux-SubparagraphsExist

subparagraphsExist=$(cat /tmp/xmlux-SubparagraphsExist)

## if A01.02.02.01.01.01
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

## if A01.02.02.01.01.01.01
	if ! test "$subparagraphSubId" == "1"

	then

## if A01.02.02.01.01.01.01.01
		if [ ! -f /tmp/xmluxe-firstSubparagraphCount ]; then

		subparagraphScarto=1	

		## if A01.02.02.01.01.01.01.01.01
#		if ! test $subparagraphScarto -eq 0

#		then
	
			/usr/local/bin/xmluxe -s --move=$idSubparagraph -b$subparagraphScarto --f=$targetFile

		touch /tmp/xmluxe-firstSubparagraphCount

		## fi A01.02.02.01.01.01.01.01.01
#		fi
		
		## else A01.02.02.01.01.01.01.01
else

		subparagraphScarto=$(($subparagraphSubId - $subparagraphCount))	

		## if A01.02.02.01.01.02.01.01.01
		if ! test $subparagraphScarto -eq 0

		then

		/usr/local/bin/xmluxe -s --move=$idSubparagraph -b$subparagraphScarto --f=$targetFile

		## fi A01.02.02.01.01.02.01.01.01
		fi

		## fi A01.02.02.01.01.01.01.01
	fi

## fi A01.02.02.01.01.01.01
fi

### done SUBPARAGRAPH
done


### fine SUBPARAGRAPH
## fi A01.02.02.01.01.01
fi 


### done PARAGRAPH
done


### fine PARAGRAPH
## fi A01.02.02.01.01.01
fi 


### done SUBSUBSECTION
done

### fine SUBSUBSECTION
## fi A01.02.02.01.01
fi 


### done SUBSECTION
done

### fine SUBSECTION
## fi A01.02.02.01
fi 


### done SECTION
done

### fine SECTION
## fi A01.02.02
fi 


### done CHAPTER
done

### fine CHAPTER
# fi A01.02
	fi


	### fine PART

	## Invece, /tmp/xmluxe-firstSectionCount
	# non va mai eliminato, perché genitore di tutti i subelementi
	rm -f /tmp/xmluxe-firstSubsectionCount

	rm -f /tmp/xmluxe-firstSubsubsectionCount
	
	rm -f /tmp/xmluxe-firstParagraphCount
	
	rm -f /tmp/xmluxe-firstSubparagraphCount
	
	rm -f /tmp/xmluxe-firstSaxumCount
	
	rm -f /tmp/xmluxe-firstSubsaxumCount
	### done fine PART
done


exit


