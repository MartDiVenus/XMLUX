#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

	rm -f /tmp/xmluxe-optionW.lmx

	rm -f /tmp/xmluxe-optionKey.lmx


	for a in $(ls /tmp/xmluxePseudoOptions)

	do

	grep "^-w$" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionW.lmx
	
	fi

	## Key or Value Element
	grep "^-k$" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOpK

	stat --format %s /tmp/xmluxeTargetFileOpK > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionKey.lmx
	
	fi

	## name attribute
	grep "^-name$" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionName.lmx
	
	fi


	done

	cat /tmp/xmluxe-actionAdd | cut -d= -f2,2 > /tmp/xmluxe-elementToAdd

	leggoIDToAdd="$(cat /tmp/xmluxe-elementToAdd)"

	## verifico se l'id che l'utente vuole aggiungere esista già
	grep "$leggoIDToAdd$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenza

	stat --format %s /tmp/xmluxe-verificaEsistenza > /tmp/xmluxe-verificaEsistenzaBytes

	leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaBytes)

	if test $leggoBytes -gt 0

	then
		leggoElementEtId="$(cat /tmp/xmluxe-verificaEsistenza)"
		clear

		echo "$leggoElementEtId exists already." 
		echo "Forced exit."

		exit
	fi

#read -p "testing 1789" EnterNull	
	sed 's/[^.]//g' /tmp/xmluxe-elementToAdd | awk '{ print length }' > /tmp/xmluxe-elementKind

	leggoElementKind="$(cat /tmp/xmluxe-elementKind)"

	# I if
	if test $leggoElementKind -eq 0

	then

################# INIZIO SERIES LMXE, LMX

## I if
#		if test ! $leggoBytesSinossi -gt 0 
			
#		then 

		## l'elemento da aggiungere è una series 
#read -p "testing 1806" EnterNull	
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericPiece

		idNumericPiece=$(cat /tmp/xmluxe-idNumericPiece)
## II if
		if ! test $idNumericPiece -gt 10

		then
			echo 0$(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousSeries

			leggoIdNumericPiecePreviousSeries=$(cat /tmp/xmluxe-idNumericPiecePreviousSeries)
### III if
			if test $leggoIdNumericPiecePreviousSeries == "00"
			then

				echo "è la prima series del documento" > /tmp/xmluxe-Ichild
#read -p "testing 1823" EnterNull
					else
				idNumericPiecePreviousSeries=$(cat /tmp/xmluxe-idNumericPiecePreviousSeries)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousSeries$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousSeries doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit
				
				fi
## chiusura IV if

			fi
## chiusura III if

else
                        echo $(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousSeries

			leggoIdNumericPiecePreviousSeries=$(cat /tmp/xmluxe-idNumericPiecePreviousSeries)
### III if
			if test $leggoIdNumericPiecePreviousSeries == "0"
			 then

				 echo "è la prima series del documento" > /tmp/xmluxe-ISeriese
#read -p "testing 1864" EnterNull
			else
				idNumericPiecePreviousSeries=$(cat /tmp/xmluxe-idNumericPiecePreviousSeries)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousSeries$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousSeries doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				### chiusura IV if
				fi

### chiusura III if
			fi
### chiusura II if
		fi

#read -p "testing 1896" EnterNull
### II if
### In alternativa hai anche /tmp/xmluxe-ISeriese
			if [ ! -f /tmp/xmluxe-elementSeries ]; then

#			clear 

#                       java /usr/local/lib/xmlux/java/xmluxe/add/data/categoryDataset/seriesFileWriter7.java

			## III if
#			if [ -f /tmp/xmluxe-itemSinossi ]; then

#				echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-append

#				idNumericPiecePreviousSeries="$(cat /tmp/xmluxe-append)"

#				grep -n "<!-- end $idNumericPiecePreviousSeries -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#			else

				echo "$leggoIdRoot" | sed 's/ //g' > /tmp/xmluxe-append

				idNumericPiecePreviousSeries="$(cat /tmp/xmluxe-append)"

				grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
#read -p "testing 1921" EnterNull	
				### chiusura III if
#			fi
		
		else

			grep -n "<!-- end $leggoIdRoot$idNumericPiecePreviousSeries -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

### chiusura II if
			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoElement="Series"

#read -p "testing 1959" EnterNull
### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

	### III if
if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type content (at line n. 2) of the series to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type content (at line n. 2) of the series to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

### chiusura III if
fi

else

	### III if
	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type content (at line n. 3) of the series to add.
At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoElement ID=\"$leggoIDToAdd\">xmluxe: Add content to $leggoElement please</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

### chiusura III if
	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoElement $leggoIDToAdd added" > $targetFile.lmxe

## chiusura sinossi
#	fi

	## chiusua I if
fi

################# INIZIO CAPITOLO LMXE, LMX

	if test $leggoElementKind -eq 1

	then
		## l'elemento da aggiungere è un capitolo

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		if ! test $idNumericIIPiece -gt 10

		then
			echo 0$(echo $idNumericIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIPiecePrevious

			leggoIdNumericPiecePrevious="$(cat /tmp/xmluxe-idNumericIIPiecePrevious)"

			if test $leggoIdNumericPiecePrevious == "00"
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIPiecePrevious)

				## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi

		else
                        echo $(echo $idNumericIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIPiecePrevious

			leggoIdNumericPiecePrevious="$(cat /tmp/xmluxe-idNumericIIPiecePrevious)"

			if test $leggoIdNumericPiecePrevious == "0"
		
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild
				
				idNumericPreviousPiece="$idNumericIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi


		fi

			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece"

			grep -n "ID=\"$leggoIdRoot$idNumericPrevious\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			if [ ! -f /tmp/xmluxe-elementItem ]; then

			echo "I Item of a Series" > /tmp/xmluxe-firstElementITEM

				### first Item not of a Series but of the entire document

#			clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/categoryDataset/itemFileWriter7.java
			
			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

echo $leggoNumberLine + 1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus


else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

	fi

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
#echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
#echo $leggoNumberLine-2| bc > /tmp/xmluxe-numberLineMinusMinus


#	fi

			
leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoElement="Item"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type content (at line n. 2) of the item to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type content (at line n. 2), of the item to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type content (at line n. 2) of the item to add. At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoElement ID=\"$leggoIDToAdd\">xmluxe: Add content to $leggoElement please</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

### appendo a /tmp/pre
leggoElement="Item"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type content (at line n. 2) of the item to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type content (at line n. 2) of the item to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type content (at line n. 2) of the item to add. At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoElement ID=\"$leggoIDToAdd\">xmluxe: Add content to $leggoElement please</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

	fi

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoElement $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO SEZIONE LMXE, LMX

	if test $leggoElementKind -eq 2

	then
		## l'elemento da aggiungere è una sezione
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		if ! test $idNumericIIIPiece -gt 10

		then
			echo 0$(echo $idNumericIIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIIPiecePrevious

			leggoIdNumericPiecePreviousSeries="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousSeries == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIPiece"
			
			else
	
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi
		fi

		if test $idNumericIIIPiece -eq 10

		then
			echo 0$(echo $idNumericIIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIIPiecePrevious

			leggoIdNumericPiecePreviousSeries="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousSeries == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIPiece"
			
			else
	
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi


		if test $idNumericIIIPiece -gt 10

		then
                        echo $(echo $idNumericIIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIIPiecePrevious

			leggoIdNumericPiecePreviousSeries="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousSeries == "0"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild
				
				idNumericPreviousPiece="$idNumericIIPiece"
				
			else
		
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi

		## Appendo all'interno di un capitolo, ma non è obbligatorio avere un capitolo.
			if [ -f /tmp/xmluxe-Ichild ]; then

				## Verifico se esiste un capitolo

				if [ -f /tmp/xmluxe-elementItem ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece"
			
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

				else
	
			grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			## Non fare confusione tra I child e l'esistenza di ...-elementKey, il I child si riferisce
			## all'appartenza a uno specifico padre, mentre  ...-elementKey si riferisce all'esistenza
			## di un elemento 'section' all'interno di tutto il documento -- non all'interno di uno specifico padre --.
			if [ ! -f /tmp/xmluxe-elementKey ]; then

	
				echo "I Key or Value of an element" > /tmp/xmluxe-firstElementKeyOrValue

			
				### first section not of chapter but of the entire document

#			clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/categoryDataset/keyFileWriter7.java

			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

		
###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	if [ -f /tmp/xmluxe-elementItem ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </paragraph> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus

	else
	
	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine | bc > /tmp/xmluxe-numberLineMinusMinus

	fi


	fi


	echo "esiste già un elemento Key or Value" > /dev/null

leggoMinus=$(cat /tmp/xmluxe-numberLineMinus1)

leggoMinusMinus=$(cat /tmp/xmluxe-numberLineMinusMinus)

echo "$leggoMinus;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo


vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre


if [ -f /tmp/xmluxe-optionKey.lmx ]; then

### appendo a /tmp/pre
leggoElement="Key"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type content (at line n. 2) of the key element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type content (at line n. 2)  of the key element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type content (at line n. 3) of the key element to add.
At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<Key ID=\"$leggoIDToAdd\">xmluxe: Add content to Key please</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

	else

leggoElement="Value"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type value (at line n. 2) of the element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type value (at line n. 2)  of the element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type value (at line n. 2) of the element to add. At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<Value ID=\"$leggoIDToAdd\">xmluxe: Add content to Value please</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

fi
########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand


echo "1G$leggoMinusMinus;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

else

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1

leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)

echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand

###### elimino il <<;>> che ho usato prima come separatore
echo ":s/\;\(.*\)/\1/g
ZZ" > /tmp/xmluxe-delPointVirgo

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand

### elimino tutto ciò che è al di sotto della riga $leggoNumerLine

## backup file originale
cp $targetFile.lmx /tmp/xmluxe-pre

vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre

if [ -f /tmp/xmluxe-optionKey.lmx ]; then

### appendo a /tmp/pre
leggoElement="Key"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type content (at line n. 2) of the key element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type content (at line n. 2)  of the key element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type content (at line n. 3) of the key element to add.
At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<Key ID=\"$leggoIDToAdd\">xmluxe: Add content to Key please</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi


else

leggoElement="Value"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Type value (at line n. 2) of the element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Type value (at line n. 2)  of the element to add. At the end, save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


	echo "Type value (at line n. 2) of the element to add. At the end, save and exit.

" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<Value ID=\"$leggoIDToAdd\">xmluxe: Add content to Value please</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
		fi

		fi

########### II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>

cp $targetFile.lmx /tmp/xmluxe-post

echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1

vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post

cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx

	fi
echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoElement $leggoIDToAdd added" > $targetFile.lmxe

fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx


exit

