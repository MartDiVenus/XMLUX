#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

grep "add" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionAdd

stat --format %s /tmp/xmluxe-actionAdd > /tmp/xmluxe-actionAddBytes

leggoBytes=$(cat /tmp/xmluxe-actionAddBytes)


## variabile già esistente
## leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

if test $leggoBytes -gt 0

then
	rm -f /tmp/xmluxe-optionW.lmx

	rm -f /tmp/xmluxe-optionKey.lmx


	for a in $(ls /tmp/xmluxePseudoOptions)

	do

	grep "^-w" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionW.lmx
	
	fi

	## Key or Value Element
	grep "^-k" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOpK

	stat --format %s /tmp/xmluxeTargetFileOpK > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionKey.lmx
	
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

	sed 's/[^.]//g' /tmp/xmluxe-elementToAdd | awk '{ print length }' > /tmp/xmluxe-elementKind

	leggoElementKind="$(cat /tmp/xmluxe-elementKind)"

	# I if
	if test $leggoElementKind -eq 0

	then

################# INIZIO ITEMS LMXE, LMX

		## l'elemento da aggiungere è una parte 
	
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericPiece

		idNumericPiece=$(cat /tmp/xmluxe-idNumericPiece)
## II if
		if test $idNumericPiece -lt 10

		then
			echo 0$(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousITEM

			leggoIdNumericPiecePreviousITEM=$(cat /tmp/xmluxe-idNumericPiecePreviousITEM)
### III if
			if test $leggoIdNumericPiecePreviousITEM == "00"
			then

				echo "è il primo ITEM del documento" > /tmp/xmluxe-Ichild

					else
				idNumericPiecePreviousITEM=$(cat /tmp/xmluxe-idNumericPiecePreviousITEM)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousITEM$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousITEM doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit
				
				fi
## chiusura IV if

			fi
## chiusura III if


		else

                        echo $(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousITEM

			leggoIdNumericPiecePreviousITEM=$(cat /tmp/xmluxe-idNumericPiecePreviousITEM)
### III if
			if test $leggoIdNumericPiecePreviousITEM == "0"
			 then

				 echo "è il primo ITEM del documento" > /tmp/xmluxe-IITEMe

			else
				idNumericPiecePreviousITEM=$(cat /tmp/xmluxe-idNumericPiecePreviousITEM)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousITEM$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousITEM doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
### chiusura III if
			fi
### chiusura II if
		fi
### II if

### In alternativa hai anche /tmp/xmluxe-IITEMe
			if [ ! -f /tmp/xmluxe-itemITEM ]; then

			# clear 

			#java /usr/local/lib/xmlux/java/xmluxe/add/data/pieDataset/itemFileWriter7.java

#			if [ -f /tmp/xmluxe-itemSinossi ]; then

#				echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-append

#				idNumericPiecePreviousITEM="$(cat /tmp/xmluxe-append)"

#				grep -n "<!-- end $idNumericPiecePreviousITEM -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#			else

				echo "$leggoIdRoot" | sed 's/ //g' > /tmp/xmluxe-append

				idNumericPiecePreviousITEM="$(cat /tmp/xmluxe-append)"

				grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
#	
#			fi
		
		else

			grep -n "<!-- end $leggoIdRoot$idNumericPiecePreviousITEM -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

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
leggoElement="Item"

### II if
		if [ -f /tmp/xmluxe-optionW.lmx ]; then

			echo "Insert title of the item to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoElement ID=\"$leggoIDToAdd\">$leggoW</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else

		echo "
<$leggoElement ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoElement please</$leggoElement>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
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


fi

################# INIZIO KEY or VALUE LMXE, LMX

	if test $leggoElementKind -eq 1

	then
		## l'elemento da aggiungere è un KEY o un Value

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		if test $idNumericIIPiece -lt 10

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

			if [ ! -f /tmp/xmluxe-itemKEYorVALUE ]; then

			echo "I item of a Key or Value" > /tmp/xmluxe-firstElementKEYorVALUE

				### first item not of a ITEM but of the entire document

			# clear 
			# /usr/local/lib/xmlux/java/xmluxe/add/data/pieDataset/keyFileWriter7.java

			# /usr/local/lib/xmlux/java/xmluxe/add/data/pieDataset/valueFileWriter7.java
			
			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

echo $leggoNumberLine + 1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

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


if [ -f /tmp/xmluxe-optionKey.lmx ]; then

### appendo a /tmp/pre
leggoElement="Key"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 2) of the key to add. At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\" name = \"Key $leggoIDToAdd\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else

		echo "
<Key ID=\"$leggoIDToAdd\" name = \"Key $leggoIDToAdd\">xmluxe: Add title to Key please</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

		fi

	else

### appendo a /tmp/pre
leggoElement="Value"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert value (at line n. 2) of the Element Value to add. At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx

			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\" name = \"Value $leggoIDToAdd\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else

		echo "
<Value ID=\"$leggoIDToAdd\" name = \"Value $leggoIDToAdd\">xmluxe: Add title to Value please</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

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

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert title (at line n. 2) of the Key Element to add. At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Key ID=\"$leggoIDToAdd\" name = \"Key $leggoIDToAdd\">$leggoW</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else

		echo "
<Key ID=\"$leggoIDToAdd\" name = \"Key $leggoIDToAdd\">xmluxe: Add title to Key please</Key>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

else

### appendo a /tmp/pre
leggoElement="Value"

	if [ -f /tmp/xmluxe-optionW.lmx ]; then

		echo "Insert value (at line n. 2) of the Value Element to add. At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<Value ID=\"$leggoIDToAdd\" name = \"Value $leggoIDToAdd\">$leggoW</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else

		echo "
<Value ID=\"$leggoIDToAdd\" name = \"Value $leggoIDToAdd\">xmluxe: Add title to Value please</Value>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre


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

fi

fi

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoElement $leggoIDToAdd added" > $targetFile.lmxe

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx

exit

