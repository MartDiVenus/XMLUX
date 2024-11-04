#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

	rm -f /tmp/xmluxe-optionW.lmx

	for a in $(ls /tmp/xmluxePseudoOptions)

	do

	grep "^-w$" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		touch /tmp/xmluxe-optionW.lmx
	
	fi

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

	sed 's/[^.]//g' /tmp/xmluxe-elementToAdd | awk '{ print length }' > /tmp/xmluxe-elementKind

	leggoElementKind="$(cat /tmp/xmluxe-elementKind)"

	# I if
	if test $leggoElementKind -eq 0

	then

################## INIZIO SINOSSI LMXE, LMX
#
#		grep "00" /tmp/xmluxe-elementToAdd > /tmp/xmluxe-sinossiOrNot
#
#		stat --format %s /tmp/xmluxe-sinossiOrNot > /tmp/xmluxe-sinossiOrNotBytes
#	
#		leggoBytesSinossi=$(cat /tmp/xmluxe-sinossiOrNotBytes)
#
#		## II if 
#		if test $leggoBytesSinossi -gt 0
#		then
#
#			## l'elemento da aggiungere è sinossi, la sinossi ha 00
#			# da fare
#
#			## Verifico che la sinossi davvero non esiste, e che quindi l'utente non stia sbagliando
#			# avolerla aggiungere
#
#			clear
#
#			java /usr/local/lib/xmlux/java/xmluxe/matter/synopsisFileWriter7.java
#
#			echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi
#
#			leggoIDToAdd="$(cat /tmp/xmluxe-idSinossi)"
#
#			grep -n "<$(cat /tmp/xmluxe-itemRoot) ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
#
#			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)
#
#			###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
###### è al di sotto di essa
#echo $leggoNumberLine+1| bc > /tmp/xmluxe-numberLinePlus1
#
#leggoAggiunta=$(cat /tmp/xmluxe-numberLinePlus1)
#
#echo "$leggoAggiunta;GdGZZ" > /tmp/xmluxe-precommand
#
####### elimino il <<;>> che ho usato prima come separatore
#echo ":s/\;\(.*\)/\1/g
#ZZ" > /tmp/xmluxe-delPointVirgo
#
#
#vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-precommand
#
#### elimino tutto ciò che è al di sotto della riga $leggoNumerLine
#
### backup file originale
#cp $targetFile.lmx /tmp/xmluxe-pre
#
#vim -s /tmp/xmluxe-precommand /tmp/xmluxe-pre
#
#### appendo a /tmp/pre
#leggoItem="$(cat /tmp/xmluxe-itemSinossi)"
#
#### III if
#		if [ -f /tmp/xmluxe-optionW.lmx ]; then
#
#			echo "Insert title (at line n. 3), and possible content (starting from line n. 4)
#of the synopsis to add. At the end save and exit.
#" >> /tmp/xmluxe-optionW.lmx
#
#			gvim -f /tmp/xmluxe-optionW.lmx
#
#			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
#
#			vim -s /usr/local/lib/xmlux/command-delFirstLine /tmp/xmluxe-optionW.lmx
#			
#			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"
#
#			echo "
#<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
#</$leggoItem>
#<!-- end $leggoIDToAdd -->
#" >> /tmp/xmluxe-pre
#
#else
#
#		echo "
#<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please
#
#</$leggoItem>
#<!-- end $leggoIDToAdd -->
#" >> /tmp/xmluxe-pre
#
#		fi
#### chiusura III if
#
############ II parte: Mi posiziono sulla I riga ed elimino tutto ciò che 
#### è al di sotto di essa ma fino alla riga $leggoNumerLine, quindi compreso <<%%BeginPageSsetup>>
#
#cp $targetFile.lmx /tmp/xmluxe-post
#
#echo "1G$leggoNumberLine;ddZZ" > /tmp/xmluxe-commandPost1
#
#vim -s /tmp/xmluxe-delPointVirgo /tmp/xmluxe-commandPost1
#
#vim -s /tmp/xmluxe-commandPost1 /tmp/xmluxe-post
#
#cat /tmp/xmluxe-pre /tmp/xmluxe-post > $targetFile.lmx
#
#echo "
#$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe
#
#	fi
	### chiusura II if

################# INIZIO PART LMXE, LMX

## I if
#		if test ! $leggoBytesSinossi -gt 0 
			
#		then 

		## l'elemento da aggiungere è una parte 
	
                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericPiece

		idNumericPiece=$(cat /tmp/xmluxe-idNumericPiece)
## II if
		if ! test $idNumericPiece -gt 10

		then
			echo 0$(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousGradusI

			leggoIdNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)
### III if
			if test $leggoIdNumericPiecePreviousGradusI == "00"
			then

				echo "è il primo gradusI del documento" > /tmp/xmluxe-Ichild

					else
				idNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousGradusI$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousGradusI doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit
				
				fi
## chiusura IV if

			fi
		else

                        echo $(echo $idNumericPiece - 1 | bc) > /tmp/xmluxe-idNumericPiecePreviousGradusI

			leggoIdNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)
### III if
			if test $leggoIdNumericPiecePreviousGradusI == "0"
			 then

				 echo "è il primo gradusI del documento" > /tmp/xmluxe-IGradusIe

			else
				idNumericPiecePreviousGradusI=$(cat /tmp/xmluxe-idNumericPiecePreviousGradusI)

					## verifico se l'id che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericPiecePreviousGradusI$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious

				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericPiecePreviousGradusI doesn't exist, but you would like to add
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

### In alternativa hai anche /tmp/xmluxe-IGradusIe
			if [ ! -f /tmp/xmluxe-itemGradusI ]; then

				## Gli elementi dei data-seven non possono essere cambiati
#			clear 

#                        java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusIFileWriter7.java

			## non è obbligatorio avere la sinossi nel documento, quindi se non esiste devo
			## appendere la gradusI subito dopo l'inizio di <root ID ...

#			if [ -f /tmp/xmluxe-itemSinossi ]; then

#				echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-append

#				idNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-append)"

#				grep -n "<!-- end $idNumericPiecePreviousGradusI -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#			else

				echo "$leggoIdRoot" | sed 's/ //g' > /tmp/xmluxe-append

				idNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-append)"

				grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
	
#			fi
		
		else

			grep -n "<!-- end $leggoIdRoot$idNumericPiecePreviousGradusI -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

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
leggoItem="$(cat /tmp/xmluxe-itemGradusI)"

### II if
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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

echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

## chiusura I if
#	fi

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

			## non è detto che esista un gradusI, non è obbligatorio
			if [ -f /tmp/xmluxe-itemGradusI ]; then

			grep -n "ID=\"$leggoIdRoot$idNumericPrevious\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			else

			## non è detto che esista una sinossi, non è obbligatoria
#			if [ -f /tmp/xmluxe-itemSinossi ]; then
			
#			echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi 

#			leggoIdSinossi="$(cat /tmp/xmluxe-idSinossi)"

#		  	grep -n "<!-- end $leggoIdSinossi -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#			else

			## se non esiste gradusI, allorra appendo subito dopo l'inizio di <root
			grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			# echo "append under root" > /tmp/xmluxe-appendUnderRoot
#
#			fi

			fi
			
			if [ ! -f /tmp/xmluxe-itemGradusII ]; then

			echo "I gradusII of a gradusI" > /tmp/xmluxe-firstElementGradusII

				### first gradusII not of a gradusI but of the entire document

#			clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusIIFileWriter7.java
			
			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

#	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

#echo $leggoNumberLine + 1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
#echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus


#else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

#	fi

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </gradusVI> e la <!-- end 'Id del paragrafo' -->
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
leggoItem="$(cat /tmp/xmluxe-itemGradusII)"


if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
leggoItem="$(cat /tmp/xmluxe-itemGradusII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

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

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
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


		else

                        echo $(echo $idNumericIIIPiece - 1 | bc) > /tmp/xmluxe-idNumericIIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
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

				if [ -f /tmp/xmluxe-itemGradusII ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece"
			
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

				else
					## se il capitolo non esiste, posso appendere dopo la sinossi se questa esiste,
					## non è obbligatorio che la sinossi esista.

#					if [ -f /tmp/xmluxe-itemSinossi ]; then

#						echo "$leggoIdRoot 00" | sed 's/ //g' > /tmp/xmluxe-idSinossi

				#		leggoIdSinossi="$(cat /tmp/xmluxe-idSinossi)"
#
#					grep -n "<!-- end $leggoIdSinossi -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

#						else
						## siccome non è obbligatorio che la sinossi esista, allora appendo all'interno di root
						## quindi in tal caso non esiste né il capitolo, né la sinossi; la parte non la testo
						## perché se non esiste il capitolo non esiste nemmeno la parte.
	
					grep -n "ID=\"$leggoIdRoot\"" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine
#
#					fi
			fi

			## Non fare confusione tra I child e l'esistenza di ...-itemGradusIII, il I child si riferisce
			## all'appartenza a uno specifico padre, mentre  ...-itemGradusIII si riferisce all'esistenza
			## di un elemento 'gradusIII' all'interno di tutto il documento -- non all'interno di uno specifico padre --.
			if [ ! -f /tmp/xmluxe-itemGradusIII ]; then

	
				echo "I gradusIII of an element" > /tmp/xmluxe-firstElementGradusIII

			
				### first gradusIII not of gradusII but of the entire document

#			clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusIIIFileWriter7.java

			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericPreviousPiece"

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			fi

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

		
###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	if [ -f /tmp/xmluxe-itemGradusII ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </gradusVI> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus

	else
	
#	if [ ! -f /tmp/xmluxe-itemSinossi ]; then

#	if [ -f /tmp/xmluxe-appendUnderRoot ]; then

#echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
#echo $leggoNumberLine  > /tmp/xmluxe-numberLineMinusMinus

#else

echo $leggoNumberLine +1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine | bc > /tmp/xmluxe-numberLineMinusMinus

#	fi


	fi


	echo "esiste già un elemento gradusIII" > /dev/null

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
leggoItem="$(cat /tmp/xmluxe-itemGradusIII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
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

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusIII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO SOTTOSEZIONE LMXE, LMX
	if test $leggoElementKind -eq 3

	then

## l'elemento da aggiungere è una sottosezione

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		## Controllo coerenza locale, se non esiste il padre (element gradusIII)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No gradusIII element exists to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi

		if ! test $idNumericIVPiece -gt 10

		then
			echo 0$(echo $idNumericIVPiece - 1 | bc) > /tmp/xmluxe-idNumericIVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIVPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		else

                        echo $(echo $idNumericIVPiece - 1 | bc) > /tmp/xmluxe-idNumericIVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericIVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIIIPiece"
					else
				
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericIVPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi

		fi
		


			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece"

			if [ ! -f /tmp/xmluxe-itemGradusIV ]; then

				echo "I gradusIV of an element" > /tmp/xmluxe-firstElementGradusIV

				### first gradusIV not of a gradusIII but of the entire document

#				clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusIVFileWriter7.java
			
			fi
			
		 	else
				
			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericPreviousPiece"


			fi

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </gradusVI> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus
			
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
leggoItem="$(cat /tmp/xmluxe-itemGradusIV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
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

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusIV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusIV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO SOTTOSOTTOSEZIONE LMXE, LMX

	if test $leggoElementKind -eq 4

	then
	## L'elemento da aggiungere è una sottosottosezione

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

		idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

			## Controllo coerenza locale, se non esiste il padre (element gradusIII)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No gradusIV element $leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece exists
to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi


		if ! test $idNumericVPiece -gt 10

		then
			echo 0$(echo $idNumericVPiece - 1 | bc) > /tmp/xmluxe-idNumericVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIVPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVPiecePrevious)

	## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add 
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi


		else

                        echo $(echo $idNumericVPiece - 1 | bc) > /tmp/xmluxe-idNumericVPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericIVPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVPiecePrevious)

					## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)

				## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if

			fi

		fi
		
	
			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece"
## prima del 19 ottobre, non va bene perché non viene rispettato l'eventuale contenuto della sezione.
		#	grep -n "ID=\"$leggoIdRoot$idNumericPrevious\"" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxe-numberLine

			if [ ! -f /tmp/xmluxe-itemGradusV ]; then

				echo "I gradusV of an element" > /tmp/xmluxe-firstElementGradusV
			
				### first gradusV not of a gradusIII but of the entire document

#				clear 
	
#				java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusVFileWriter7.java

			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericPreviousPiece"

			fi

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine


			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </gradusVI> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1 | bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine -2 | bc > /tmp/xmluxe-numberLineMinusMinus
			
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
leggoItem="$(cat /tmp/xmluxe-itemGradusV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
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

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusV)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusV to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

################# INIZIO PARAGRAPH LMXE, LMX

	if test $leggoElementKind -eq 5

	then
	# l'elemento da aggiungere è un gradusVI

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

		idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

		idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

			## Controllo coerenza locale, se non esiste il padre (element gradusIII)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No gradusV element $leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece exists
to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi



		if ! test $idNumericVIPiece -gt 10

		then
			echo 0$(echo $idNumericVIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVPiece"
					else
				idNumericPreviousPiece="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"
				## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
		
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIPiecePrevious)
			fi


		else

                        echo $(echo $idNumericVIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then
				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIPiecePrevious)

				## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi
		
			if [ -f /tmp/xmluxe-Ichild ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece"

			if [ ! -f /tmp/xmluxe-itemGradusVI ]; then

				echo "I gradusVI of an element" > /tmp/xmluxe-firstElementGradusVI

				### first gradusVI not of an gradusV but of the entire document

#				clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusVIFileWriter7.java
                        
			fi

			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericPreviousPiece"

			fi

			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </gradusVI> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine-2| bc > /tmp/xmluxe-numberLineMinusMinus
			
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
leggoItem="$(cat /tmp/xmluxe-itemGradusVI)"
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
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

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusVI)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVI to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe
	
fi

################# INIZIO SUBPARAGRAPH LMXE, LMX

	if test $leggoElementKind -eq 6

	then
	## l'elemento da aggiungere è un gradusVII

                cat /tmp/xmluxe-elementToAdd | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

		idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

		idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

		idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

		idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

		idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

		idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

		idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

		cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f7,7 > /tmp/xmluxe-idNumericVIIPiece

		idNumericVIIPiece="$(cat /tmp/xmluxe-idNumericVIIPiece)"

			## Controllo coerenza locale, se non esiste il padre (element gradusIII)
		## non puoi aggiungere il figlio (element sottosezione).
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" > /tmp/xmluxe-fatherElement

		leggoFatherElement="$(cat /tmp/xmluxe-fatherElement)"

		grep "$leggoFatherElement$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-fatherElementExists

		stat --format %s /tmp/xmluxe-fatherElementExists > /tmp/xmluxe-fatherElementExistsBytes
		
		leggoBytes=$(cat /tmp/xmluxe-fatherElementExistsBytes)

		if test $leggoBytes -eq 0

		then
			clear 

			echo "No gradusVI element $leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece exists
to have the child $leggoIDToAdd you would like to add."

			echo "Forced exit."

			exit

		fi

		if ! test $idNumericVIIPiece -gt 10

		then
			echo 0$(echo $idNumericVIIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "00"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVIPiece"
					else

				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)

			## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add 
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
	
			fi


		else

                        echo $(echo $idNumericVIIPiece - 1 | bc) > /tmp/xmluxe-idNumericVIIPiecePrevious

			leggoIdNumericPiecePreviousGradusI="$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)"

			if test $leggoIdNumericPiecePreviousGradusI == "0"
			
			then

				echo "è il primo child" > /tmp/xmluxe-Ichild

				idNumericPreviousPiece="$idNumericVIPiece"
					else
				idNumericPreviousPiece=$(cat /tmp/xmluxe-idNumericVIIPiecePrevious)

			## verifico se l'id del capitolo che l'utente vuole aggiungere ha un omologo precedente
				grep "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece$" /tmp/xmluxe-itemsEtIDs > /tmp/xmluxe-verificaEsistenzaPrevious
				stat --format %s /tmp/xmluxe-verificaEsistenzaPrevious > /tmp/xmluxe-verificaEsistenzaPreviousBytes

				leggoBytes=$(cat /tmp/xmluxe-verificaEsistenzaPreviousBytes)
## IV if
				if test $leggoBytes -eq 0

				then
				
				clear

				echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece doesn't exist, but you would like to add
$leggoIDToAdd."

				echo "Forced exit."

				exit

				fi

				### chiusura IV if
			fi

		fi
		
			if [ -f /tmp/xmluxe-Ichild ]; then
			
			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece"
	
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			echo "I gradusVII of an element" > /tmp/xmluxe-firstElementGradusVII

			

			if [ ! -f /tmp/xmluxe-itemGradusVII ]; then

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece"


				### first gradusVII not of a gradusVI but of the entire document
#				clear 

#			java /usr/local/lib/xmlux/java/xmluxe/add/data/data-seven/gradusVIIFileWriter7.java

			fi


			else

			idNumericPrevious="$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$idNumericPreviousPiece"
			
			fi
			
			grep -n "<!-- end $leggoIdRoot$idNumericPrevious -->" /tmp/xmluxe-css000 | cut -d: -f1 > /tmp/xmluxe-numberLine

			leggoNumberLine=$(cat /tmp/xmluxe-numberLine)


if [ -f /tmp/xmluxe-Ichild ]; then

	## -2 in modo da rispettare l'eventuale contenuto del paragrafo, e inserire il
	# subparagrafo appena dopo di esso quindi appena prima della chiusura del paragrafo.
	# La chiusura del paragrafo consiste di 2 linee, la </gradusVI> e la <!-- end 'Id del paragrafo' -->
echo $leggoNumberLine -1| bc > /tmp/xmluxe-numberLineMinus1

###### I parte: mi posiziono sulla riga $leggoNumberLine ed elimino tutto ciò che 
##### è al di sotto di essa
echo $leggoNumberLine-2| bc > /tmp/xmluxe-numberLineMinusMinus
			
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
leggoItem="$(cat /tmp/xmluxe-itemGradusVII)"
if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

	fi

## chiusura II if
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

### appendo a /tmp/pre
leggoItem="$(cat /tmp/xmluxe-itemGradusVII)"

if [ -f /tmp/xmluxe-optionW.lmx ]; then

if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)

	
			echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

else


echo "Insert title of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre

fi

else

	if [ -f /tmp/xmluxe-optionName.lmx ]; then

	java /usr/local/lib/xmlux/java/xmluxe/insert/insertName.java

	name=$(cat /tmp/xmluxe-insertName)


echo "Insert content of the gradusVII to add, starting from line number 3.
At the end save and exit.
" >> /tmp/xmluxe-optionW.lmx

			gvim -f /tmp/xmluxe-optionW.lmx

			cat /tmp/xmluxe-optionW.lmx | sed '1,2d' > /tmp/xmluxe-optionWSed

			cp /tmp/xmluxe-optionWSed /tmp/xmluxe-optionW.lmx
			
			leggoW="$(cat /tmp/xmluxe-optionW.lmx)"

			echo "
<$leggoItem ID=\"$leggoIDToAdd\" name=\"$name\">$leggoW
</$leggoItem>
<!-- end $leggoIDToAdd -->
" >> /tmp/xmluxe-pre
	
else
	echo "
<$leggoItem ID=\"$leggoIDToAdd\">xmluxe: Add title to $leggoItem please

</$leggoItem>
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
$(date +"%Y-%m-%d-%H-%M")	$leggoItem $leggoIDToAdd added" > $targetFile.lmxe

fi

cat -s $targetFile.lmx > /tmp/xmluxe-catS

cp /tmp/xmluxe-catS $targetFile.lmx


exit

