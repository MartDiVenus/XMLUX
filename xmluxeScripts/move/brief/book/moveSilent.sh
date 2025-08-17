#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"


	mkdir /tmp/xmluxe-allIDsContainer
	
	split -l1 /tmp/xmluxe-allIDs /tmp/xmluxe-allIDsContainer/

### after -> vuoi scalare un id  in avanti
	grep "^-a" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 0

	then

		touch /tmp/xmluxe-optionA

		cat /tmp/xmluxeTargetFileOp | cut -d: -f2,2 | sed 's/-a//g' > /tmp/xmluxe-afterValue

		optionValue=$(cat /tmp/xmluxe-afterValue)

	fi
### before -> vuoi scalare un id  indietro
	grep "^-b" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 0

	then

		touch /tmp/xmluxe-optionB

		cat /tmp/xmluxeTargetFileOp | cut -d: -f2,2 | sed 's/-b//g' > /tmp/xmluxe-beforeValue

		optionValue=$(cat /tmp/xmluxe-beforeValue)

	fi


	cat /tmp/xmluxe-actionMove | cut -d= -f2,2 > /tmp/xmluxe-elementToMove

	leggoIDToMove="$(cat /tmp/xmluxe-elementToMove)"

	grep "$leggoIDToMove$" /tmp/xmluxe-allIDs > /tmp/xmluxe-verificoEsistenzaID

	stat --format %s /tmp/xmluxe-verificoEsistenzaID > /tmp/xmluxe-verificoEsistenzaIDBytes

	leggoBytesEsistenzaID=$(cat /tmp/xmluxe-verificoEsistenzaIDBytes)

	if test ! $leggoBytesEsistenzaID -gt 0

	then
		exit

	fi


## leggo la frequenza dei pti.
	sed 's/[^.]//g' /tmp/xmluxe-elementToMove | awk '{ print length }' > /tmp/xmluxe-elementKind

	leggoElementKind="$(cat /tmp/xmluxe-elementKind)"

	## per la sinossi non ha senso eseguire xmluxe --move, quindi parto direttamente da 1 [ossia dalle parti]

	########### inizio part move

	if test $leggoElementKind -eq 0

	then

	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-LastPiece

	originalValue=$(cat /tmp/xmluxe-LastPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-partsList

				for b in $(ls /tmp/xmluxe-parts)

				do

				leggoB="$(cat /tmp/xmluxe-parts/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-partsList

				done

				cat /tmp/xmluxe-partsList | sort > /tmp/xmluxe-partsListSorted

				cat /tmp/xmluxe-partsListSorted | tail -n1 > /tmp/xmluxe-partsListSortedMax0

				cat /tmp/xmluxe-partsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-partsListSortedMax01

				cat /tmp/xmluxe-partsListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-partsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-partsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-partsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-partsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

				declare -i var=0

				for n in seq `$nIterazioni`

				do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
		
		echo "$leggoIdRoot $newValue" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then

		echo "$leggoIdRoot 0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo "$leggoIdRoot $originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"
		
		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe


done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		
		echo "$leggoIdRoot $newValue" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
		
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	#	fi
## qua legge anche il capitolo, invece qui devo stare nel blocco delle parti
	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)
## I if qua 
			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-partsList

				for b in $(ls /tmp/xmluxe-parts)

				do

				leggoB="$(cat /tmp/xmluxe-parts/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-partsList

				done

				cat /tmp/xmluxe-partsList | sort > /tmp/xmluxe-partsListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

cat /tmp/xmluxe-partsList | sort > /tmp/xmluxe-partsListSorted

				cat /tmp/xmluxe-partsListSorted | tail -n1 > /tmp/xmluxe-partsListSortedMax0

				cat /tmp/xmluxe-partsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-partsListSortedMax01

				cat /tmp/xmluxe-partsListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-partsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-partsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-partsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-partsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)
			
declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi


		echo "$leggoIdRoot $newValue" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then

		echo "$leggoIdRoot 0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo "$leggoIdRoot $originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		
		## IV if
		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		
		echo "$leggoIdRoot $newValue" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
  	
		exit
		
		fi

		done
	
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe


		fi

		fi

		fi
	
#		exit

#		fi
		### con questo fi ho finito il blocco dell'elemento 'part', ora tocca al capitolo.

#else
#	echo "la frequenza è un'altra" > /dev/null

# fi

## I if chiuso

############## fine part move

### inizio chapter move	
if test $leggoElementKind -eq 1

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece
## ricordati di aggiungere pezzi progressivamente per elementi inferiori al capitolo
## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericIIPiece /tmp/xmluxe-LastPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	if test $idNumericIIPiece -lt 10

	then


	originalValue=$(cat /tmp/xmluxe-idNumericIIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-chaptersList

				for b in $(ls /tmp/xmluxe-chapters)

				do

				leggoB="$(cat /tmp/xmluxe-chapters/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-chaptersList

				done
### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-chaptersPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-chaptersPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-chaptersList >  /tmp/xmluxe-chaptersListToSort

				cat /tmp/xmluxe-chaptersListToSort | sort > /tmp/xmluxe-chaptersListSorted

				cat /tmp/xmluxe-chaptersListSorted | tail -n1 > /tmp/xmluxe-chaptersListSortedMax0

				cat /tmp/xmluxe-chaptersListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-chaptersListSortedMax01

				cat /tmp/xmluxe-chaptersListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-chaptersListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-chaptersListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-chaptersListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-chaptersListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=0

for n in seq `$nIterazioni`

do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
		
		echo "$leggoIdRoot$idNumericIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then

		echo "$leggoIdRoot$idNumericIPiece.0$originalValueN" > /tmp/xmluxe-idToMoveN

		else

		echo "$leggoIdRoot$idNumericIPiece.$originalValueN" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

				echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		
		echo "$leggoIdRoot$idNumericIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-chaptersList

				for b in $(ls /tmp/xmluxe-chapters)

				do

				leggoB="$(cat /tmp/xmluxe-chapters/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-chaptersList

				done

				### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-chaptersPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-chaptersPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-chaptersPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-chaptersList >  /tmp/xmluxe-chaptersListToSort

				cat /tmp/xmluxe-chaptersListToSort | sort > /tmp/xmluxe-chaptersListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-chaptersListSorted | tail -n1 > /tmp/xmluxe-chaptersListSortedMax0

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-chaptersListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-chaptersListSortedMax01

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-chaptersListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-chaptersListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-chaptersListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-chaptersListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-chaptersListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi


		echo "$leggoIdRoot$idNumericIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then

		echo "$leggoIdRoot$idNumericIPiece.0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo "$leggoIdRoot$idNumericIPiece.$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		
		echo "$leggoIdRoot$idNumericIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
	### con questo fi ho finito il blocco dell'elemento 'capitolo', ora tocca alla sezione.

### inizio sections move	
if test $leggoElementKind -eq 2

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"
## ricordati di aggiungere pezzi progressivamente per elementi inferiori al sezione
## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericIIIPiece /tmp/xmluxe-LastPiece

	if test $idNumericIIIPiece -lt 10

	then

## ricordati di cambiare IIIPiece in IVPiece nel prox blocco subsection
	originalValue=$(cat /tmp/xmluxe-idNumericIIIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-sectionsList

				for b in $(ls /tmp/xmluxe-sections)

				do

				leggoB="$(cat /tmp/xmluxe-sections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-sectionsList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-sectionsPrefixToMatch

				leggoSectionsPrefixToMatch="$(cat /tmp/xmluxe-sectionsPrefixToMatch)"

				grep "$leggoSectionsPrefixToMatch" /tmp/xmluxe-sectionsList > /tmp/xmluxe-sectionsListToSort

				cat /tmp/xmluxe-sectionsListToSort | sort > /tmp/xmluxe-sectionsListSorted

				cat /tmp/xmluxe-sectionsListSorted | tail -n1 > /tmp/xmluxe-sectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-sectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-sectionsListSortedMax01
				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-sectionsListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-sectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-sectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-sectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-sectionsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=0

for n in seq `$nIterazioni`

do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.0$originalValueN" > /tmp/xmluxe-idToMoveN

		else
		### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$originalValueN" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe



		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere $idNumericIIIPiece in subsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-sectionsList

				for b in $(ls /tmp/xmluxe-sections)

				do

				leggoB="$(cat /tmp/xmluxe-sections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-sectionsList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-sectionsPrefixToMatch

				leggoSectionsPrefixToMatch="$(cat /tmp/xmluxe-sectionsPrefixToMatch)"

				grep "$leggoSectionsPrefixToMatch" /tmp/xmluxe-sectionsList >  /tmp/xmluxe-sectionsListToSort

				cat /tmp/xmluxe-sectionsListToSort | sort > /tmp/xmluxe-sectionsListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-sectionsListSorted | tail -n1 > /tmp/xmluxe-sectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-sectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-sectionsListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-sectionsListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-sectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-sectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-sectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-sectionsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericIIIPiece in subsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
### con questo fi ho finito il blocco dell elemento sezione, ora tocca alla sottosezione.

################# fine section move

### inizio subsections move	
if test $leggoElementKind -eq 3

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

## ricordati di aggiungere VPiece a sottosottosezione
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

	idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericIVPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare IVPiece in VPiece in sottosottosezione
	if test $idNumericIVPiece -lt 10

	then

## ricordati di cambiare IVPiece in VPiece nel prox blocco subsubsection
	originalValue=$(cat /tmp/xmluxe-idNumericIVPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-subsectionsList

				for b in $(ls /tmp/xmluxe-subsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsectionsList

				done
### ricordati di aggiungere $idNumericIVPiece NON VPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" | sed 's/ //g' > /tmp/xmluxe-subsectionsPrefixToMatch

				leggoSubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsectionsPrefixToMatch)"

				grep "$leggoSubsectionsPrefixToMatch" /tmp/xmluxe-subsectionsList > /tmp/xmluxe-subsectionsListToSort

				cat /tmp/xmluxe-subsectionsListToSort | sort > /tmp/xmluxe-subsectionsListSorted

				cat /tmp/xmluxe-subsectionsListSorted | tail -n1 > /tmp/xmluxe-subsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsection
				cat /tmp/xmluxe-subsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsectionsListSortedMax01
				### ricordati di cambiare -f4,4 in -f5,5 per la subsubsection
				cat /tmp/xmluxe-subsectionsListSortedMax01 | cut -d. -f4,4 > /tmp/xmluxe-subsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=0

for n in seq `$nIterazioni`

do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
### ricordati di aggiungere $idNumericIVPiece in subsubsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIVPiece in subsubsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.0$originalValueN" > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$originalValueN" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere $idNumericIIIPiece in subsubsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-subsectionsList

				for b in $(ls /tmp/xmluxe-subsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsectionsList

				done
### ricordati di aggiungere alla sottosottosezione $idNumericIVPiece NON VPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece" | sed 's/ //g' > /tmp/xmluxe-subsectionsPrefixToMatch

				leggoSubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsectionsPrefixToMatch)"

				grep "$leggoSubsectionsPrefixToMatch" /tmp/xmluxe-subsectionsList >  /tmp/xmluxe-subsectionsListToSort

				cat /tmp/xmluxe-subsectionsListToSort | sort > /tmp/xmluxe-subsectionsListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-subsectionsListSorted | tail -n1 > /tmp/xmluxe-subsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsection
				cat /tmp/xmluxe-subsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsectionsListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsubsection
				cat /tmp/xmluxe-subsectionsListSortedMax01 | cut -d. -f4,4 > /tmp/xmluxe-subsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsectionsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

### ricordati di aggiungere $idNumericIVPiece per la sottosottosezione
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIVPiece per la sottosottosezione
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericIVPiece per la sottosottosezione
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericIVPiece in subsubsection	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
### con questo fi ho finito il blocco dell elemento sezione, ora tocca alla sottosezione.

################# fine subsection

################# inizio subsubsections
### inizio subsubsections move	
## ricordati di cambiare 4 in 5 in paragraph
if test $leggoElementKind -eq 4

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

	idNumericLessRoot=$(cat /tmp/xmluxe-idNumericLessRoot)

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f1,1 > /tmp/xmluxe-idNumericIPiece

	idNumericIPiece="$(cat /tmp/xmluxe-idNumericIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f2,2 > /tmp/xmluxe-idNumericIIPiece

	idNumericIIPiece="$(cat /tmp/xmluxe-idNumericIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f3,3 > /tmp/xmluxe-idNumericIIIPiece

	idNumericIIIPiece="$(cat /tmp/xmluxe-idNumericIIIPiece)"

	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f4,4 > /tmp/xmluxe-idNumericIVPiece

	idNumericIVPiece="$(cat /tmp/xmluxe-idNumericIVPiece)"

## ricordati di aggiungere VIPiece a paragraph
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f5,5 > /tmp/xmluxe-idNumericVPiece

	idNumericVPiece="$(cat /tmp/xmluxe-idNumericVPiece)"

## ricordati di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericVPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare VPiece in VIPiece in paragraph
	if test $idNumericVPiece -lt 10

	then

## ricordati di cambiare VPiece in VIPiece nel prox blocco paragraph
	originalValue=$(cat /tmp/xmluxe-idNumericVPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-subsubsectionsList

				for b in $(ls /tmp/xmluxe-subsubsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsubsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsubsectionsList

				done
### ricordati di aggiungere $idNumericVPiece NON VIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" | sed 's/ //g' > /tmp/xmluxe-subsubsectionsPrefixToMatch

				leggoSubsubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsubsectionsPrefixToMatch)"

				grep "$leggoSubsubsectionsPrefixToMatch" /tmp/xmluxe-subsubsectionsList > /tmp/xmluxe-subsubsectionsListToSort

				cat /tmp/xmluxe-subsubsectionsListToSort | sort > /tmp/xmluxe-subsubsectionsListSorted

				cat /tmp/xmluxe-subsubsectionsListSorted | tail -n1 > /tmp/xmluxe-subsubsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubsection
				cat /tmp/xmluxe-subsubsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsubsectionsListSortedMax01
				### ricordati di cambiare -f5,5 in -f6,6 per il paragraph
				cat /tmp/xmluxe-subsubsectionsListSortedMax01 | cut -d. -f5,5 > /tmp/xmluxe-subsubsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsubsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=0

for n in seq `$nIterazioni`

do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
### ricordati di aggiungere $idNumericVPiece in paragraph
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVPiece in paragraph
echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.0$originalValueN" > /tmp/xmluxe-idToMoveN


		else
### ricordati di aggiungere $idNumericVPiece in paragraph
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$originalValueN" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere un pezzo a paragraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-subsubsectionsList

				for b in $(ls /tmp/xmluxe-subsubsections)

				do

				leggoB="$(cat /tmp/xmluxe-subsubsections/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subsubsectionsList

				done
### ricordati di aggiungere a paragraph $idNumericVPiece NON VIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece" | sed 's/ //g' > /tmp/xmluxe-subsubsectionsPrefixToMatch

				leggoSubsubsectionsPrefixToMatch="$(cat /tmp/xmluxe-subsubsectionsPrefixToMatch)"

				grep "$leggoSubsubsectionsPrefixToMatch" /tmp/xmluxe-subsubsectionsList >  /tmp/xmluxe-subsubsectionsListToSort

				cat /tmp/xmluxe-subsubsectionsListToSort | sort > /tmp/xmluxe-subsubsectionsListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-subsubsectionsListSorted | tail -n1 > /tmp/xmluxe-subsubsectionsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubsection
				cat /tmp/xmluxe-subsubsectionsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subsubsectionsListSortedMax01

				### ricordati di cambiare -f5,5 in -f6,6 per la subsubsubsection
				cat /tmp/xmluxe-subsubsectionsListSortedMax01 | cut -d. -f5,5 > /tmp/xmluxe-subsubsectionsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subsubsectionsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subsubsectionsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

### ricordati di aggiungere $idNumericVPiece per il paragrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVPiece per il paragrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericVPiece per il paragrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericVPiece in paragraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	
### con questo fi ho finito il blocco dell elemento sezione, ora tocca alla sottosezione.

################# fine subsubsection

################# inizio paragraph
### inizio paragraphs move	
## ricordati di cambiare 5 in 6 in subparagraph
if test $leggoElementKind -eq 5

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

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

	## ricordati di aggiungere VIIPiece a subparagraph
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f6,6 > /tmp/xmluxe-idNumericVIPiece

	idNumericVIPiece="$(cat /tmp/xmluxe-idNumericVIPiece)"

## ricordati in subparagraph di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericVIPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare VIPiece in VIIPiece in subparagraph
	if test $idNumericVIPiece -lt 10

	then

## ricordati di cambiare VIPiece in VIIPiece nel prox blocco subparagraph
	originalValue=$(cat /tmp/xmluxe-idNumericVIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-paragraphsList

				for b in $(ls /tmp/xmluxe-paragraphs)

				do

				leggoB="$(cat /tmp/xmluxe-paragraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-paragraphsList

				done
### ricordati di aggiungere in subparagraph $idNumericVIPiece NON VIIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" | sed 's/ //g' > /tmp/xmluxe-paragraphsPrefixToMatch

				leggoParagraphsPrefixToMatch="$(cat /tmp/xmluxe-paragraphsPrefixToMatch)"

				grep "$leggoParagraphsPrefixToMatch" /tmp/xmluxe-paragraphsList > /tmp/xmluxe-paragraphsListToSort

				cat /tmp/xmluxe-paragraphsListToSort | sort > /tmp/xmluxe-paragraphsListSorted

				cat /tmp/xmluxe-paragraphsListSorted | tail -n1 > /tmp/xmluxe-paragraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subparagraph
				cat /tmp/xmluxe-paragraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-paragraphsListSortedMax01
				### ricordati di cambiare -f6,6 in -f7,7 per il paragraph
				cat /tmp/xmluxe-paragraphsListSortedMax01 | cut -d. -f6,6 > /tmp/xmluxe-paragraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-paragraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=0

for n in seq `$nIterazioni`

do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
### ricordati di aggiungere $idNumericVIPiece in subparagraph
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVIPiece in subparagraph
echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.0$originalValueN" > /tmp/xmluxe-idToMoveN


		else
### ricordati di aggiungere $idNumericVPiece in paragraph
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$originalValueN" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe



		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere un pezzo a subparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-paragraphsList

				for b in $(ls /tmp/xmluxe-paragraphs)

				do

				leggoB="$(cat /tmp/xmluxe-paragraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-paragraphsList

				done
### ricordati di aggiungere a subparagraph $idNumericVIPiece NON VIIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece" | sed 's/ //g' > /tmp/xmluxe-paragraphsPrefixToMatch

				leggoParagraphsPrefixToMatch="$(cat /tmp/xmluxe-paragraphsPrefixToMatch)"

				grep "$leggoParagraphsPrefixToMatch" /tmp/xmluxe-paragraphsList >  /tmp/xmluxe-paragraphsListToSort

				cat /tmp/xmluxe-paragraphsListToSort | sort > /tmp/xmluxe-paragraphsListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-paragraphsListSorted | tail -n1 > /tmp/xmluxe-paragraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a parapraph
				cat /tmp/xmluxe-paragraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-paragraphsListSortedMax01

				### ricordati di cambiare -f6,6 in -f7,7 per subparagraph
				cat /tmp/xmluxe-paragraphsListSortedMax01 | cut -d. -f6,6 > /tmp/xmluxe-paragraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-paragraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-paragraphsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

### ricordati di aggiungere $idNumericVIPiece per il subparagrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVIPiece per il subparagrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericVIPiece per il subparagrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe

		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericVIPiece in subparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	

################# fine paragraph

################# inizio subparagraph
################# inizio subparagraph
### inizio subparagraphs move	
## ricordati di cambiare 6 in 7 nel livello inferiore a subsubparagraph
if test $leggoElementKind -eq 6

	then
	leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"
	
	cat /tmp/xmluxe-elementToMove | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-idNumericLessRoot

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

	## ricordati di aggiungere VIIIPiece nel livello inferiore a subsubparagraph
	cat /tmp/xmluxe-idNumericLessRoot | cut -d. -f7,7 > /tmp/xmluxe-idNumericVIIPiece

	idNumericVIIPiece="$(cat /tmp/xmluxe-idNumericVIIPiece)"

## ricordati nell livello inferiore a subsubparagraph di copiare l'ultimo pezzo in /tmp/xmluxe-LastPiece
	cp /tmp/xmluxe-idNumericVIIPiece /tmp/xmluxe-LastPiece

## ricordati di cambiare VIIPiece in VIIIPiece nel livello inferiore a subsubparagraph
	if test $idNumericVIIPiece -lt 10

	then

## ricordati di cambiare VIIPiece in VIIIPiece nel livello inferiore a subsubparagraph
	originalValue=$(cat /tmp/xmluxe-idNumericVIIPiece)

		### Se l'opzione fosse -a di after
		if [ -f	/tmp/xmluxe-optionA ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-subparagraphsList

				for b in $(ls /tmp/xmluxe-subparagraphs)

				do

				leggoB="$(cat /tmp/xmluxe-subparagraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subparagraphsList

				done
### ricordati di aggiungere nel livello inferiore al subsubparagraph $idNumericVIIPiece NON VIIIPiece perché qui serve il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" | sed 's/ //g' > /tmp/xmluxe-subparagraphsPrefixToMatch

				leggoSubparagraphsPrefixToMatch="$(cat /tmp/xmluxe-subparagraphsPrefixToMatch)"

				grep "$leggoSubparagraphsPrefixToMatch" /tmp/xmluxe-subparagraphsList > /tmp/xmluxe-subparagraphsListToSort

				cat /tmp/xmluxe-subparagraphsListToSort | sort > /tmp/xmluxe-subparagraphsListSorted

				cat /tmp/xmluxe-subparagraphsListSorted | tail -n1 > /tmp/xmluxe-subparagraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subsubparagraph
				cat /tmp/xmluxe-subparagraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subparagraphsListSortedMax01
				### ricordati di cambiare -f7,7 in -f8,8 nel livello inferiore a subparagraph
				cat /tmp/xmluxe-subparagraphsListSortedMax01 | cut -d. -f7,7 > /tmp/xmluxe-subparagraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subparagraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

declare -i var=0

for n in seq `$nIterazioni`
do

var=$var+1

originalValueN=$(echo $leggoMaxValue -$var + 1 | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN + $optionValue | bc)"

		else

			newValue="$(echo $originalValueN + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN + $optionValue | bc)"

		fi
### ricordati che nel livello inferiore a subparagraph devi aggiungere $idNumericVIIPiece
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati che nel livello inferiore a subparagraph devi aggiungere $idNumericVIIPiece
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.0$originalValueN" > /tmp/xmluxe-idToMoveN


		else
### ricordati che nel livello inferiore a subparagraph devi aggiungere $idNumericVIIPiece
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$originalValueN" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else
### modalità senza -end
			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue + $optionValue | bc)"

		else

			newValue="$(echo $originalValue + $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValue + $optionValue | bc)"
		
		fi
		### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore a subsubparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		 done

		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe
		
		fi

		fi

	### Se l'opzione fosse -b di before
		if [ -f	/tmp/xmluxe-optionB ]; then

			## se fosse stata espressa anche l'opzione -end

			grep "^-end" /tmp/xmluxePseudoOptions/* > /tmp/xmluxeTargetFileOpAll

			stat --format %s /tmp/xmluxeTargetFileOpAll > /tmp/xmluxeTargetFileBytesAll

			leggoBytesAll=$(cat /tmp/xmluxeTargetFileBytesAll)

			if test $leggoBytesAll -gt 0

			then

				touch /tmp/xmluxe-subparagraphsList

				for b in $(ls /tmp/xmluxe-subparagraphs)

				do

				leggoB="$(cat /tmp/xmluxe-subparagraphs/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-subparagraphsList

				done
### ricordati nel livello ingeriore a subparagraph di aggiungere $idNumericVIPiece NON VIIPiece perché qui serve solo il prefisso
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece" | sed 's/ //g' > /tmp/xmluxe-subparagraphsPrefixToMatch

				leggoSubparagraphsPrefixToMatch="$(cat /tmp/xmluxe-subparagraphsPrefixToMatch)"

				grep "$leggoSubparagraphsPrefixToMatch" /tmp/xmluxe-subparagraphsList >  /tmp/xmluxe-subparagraphsListToSort

				cat /tmp/xmluxe-subparagraphsListToSort | sort > /tmp/xmluxe-subparagraphsListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-subparagraphsListSorted | tail -n1 > /tmp/xmluxe-subparagraphsListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a subparapraph
				cat /tmp/xmluxe-subparagraphsListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-subparagraphsListSortedMax01

				### ricordati di cambiare -f7,7 in -f8,8 nel livello inferiore a subsubparagraph
				cat /tmp/xmluxe-subparagraphsListSortedMax01 | cut -d. -f7,7 > /tmp/xmluxe-subparagraphsListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-subparagraphsListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-subparagraphsListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)


declare -i var=-1

for n in seq `$nIterazioni`

do

var=$var+1


originalValueN=$(echo $originalValue +$var | bc)

			if test $originalValueN -lt 10

		then

		newValuePre="0$(echo $originalValueN - $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValueN - $optionValue | bc)"

		else

			newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

		else

		newValue="$(echo $originalValueN - $optionValue | bc)"

		fi

### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore al subparagrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		if test $originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore al subparagrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.0$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore al subparagrafo
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$originalValueN" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN="$(cat /tmp/xmluxe-idToMoveN)"

		vim -c ":%s/$leggoIDToMoveN/$fullNewID/g" $targetFile.lmx -c :w -c :q

			echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMoveN moved to $fullNewID" >> $targetFile.lmxe

done

echo " "  >> $targetFile.lmxe


		else

			## IV if
		if test $originalValue -lt 10

		then

		newValuePre="0$(echo $originalValue + $optionValue | bc)"
## devo creare una nuovo condizionale nel caso in cui in seguito alla differenza, entrassi nella doppia cifra.
		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi

		if test $originalValue -lt 10

		then

		newValue="0$(echo $originalValue - $optionValue | bc)"

		else

		newValuePre="$(echo $originalValue - $optionValue | bc)"

		## devo creare un nuovo condizionale nel caso in cui a seguito della differenza entrassi nella singola cifra

		if test $newValuePre -lt 10

		then

			newValue="0$(echo $originalValue - $optionValue | bc)"

		else

			newValue="$(echo $originalValue - $optionValue | bc)"

		fi

		fi
		### ricordati di aggiungere $idNumericVIIPiece nel livello inferiore a subsubparagraph	
		echo "$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.$idNumericIIIPiece.$idNumericIVPiece.$idNumericVPiece.$idNumericVIPiece.$newValue" > /tmp/xmluxe-fullNewId

		fullNewID="$(cat /tmp/xmluxe-fullNewId)"

		for a in $(ls /tmp/xmluxe-allIDsContainer/)

		do

		leggoA="$(cat /tmp/xmluxe-allIDsContainer/$a)"

		if test "$fullNewID" == "$leggoA"

		then
	
		exit
		
		fi

		done
		
		vim -c ":%s/$leggoIDToMove/$fullNewID/g" $targetFile.lmx -c :w -c :q

		echo "
$(date +"%Y-%m-%d-%H-%M")	$leggoIDToMove moved to $fullNewID" >> $targetFile.lmxe

echo " " >> $targetFile.lmxe

		fi

		fi
	
		fi
fi	

################# fine subparagraph

exit

