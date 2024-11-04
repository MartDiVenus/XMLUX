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

	########### inizio Series move

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

				touch /tmp/xmluxe-gradusIList

				for b in $(ls /tmp/xmluxe-gradusI)

				do

				leggoB="$(cat /tmp/xmluxe-gradusI/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIList

				done

				cat /tmp/xmluxe-gradusIList | sort > /tmp/xmluxe-gradusIListSorted

				cat /tmp/xmluxe-gradusIListSorted | tail -n1 > /tmp/xmluxe-gradusIListSortedMax0

				cat /tmp/xmluxe-gradusIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIListSortedMax01

				cat /tmp/xmluxe-gradusIListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-gradusIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
		
		echo \"$leggoIdRoot \$newValue\" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot 0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot \$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"
		
		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe


done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


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

				touch /tmp/xmluxe-gradusIList

				for b in $(ls /tmp/xmluxe-gradusI)

				do

				leggoB="$(cat /tmp/xmluxe-gradusI/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIList

				done

				cat /tmp/xmluxe-gradusIList | sort > /tmp/xmluxe-gradusIListSorted

					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

cat /tmp/xmluxe-gradusIList | sort > /tmp/xmluxe-gradusIListSorted

				cat /tmp/xmluxe-gradusIListSorted | tail -n1 > /tmp/xmluxe-gradusIListSortedMax0

				cat /tmp/xmluxe-gradusIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIListSortedMax01

				cat /tmp/xmluxe-gradusIListSortedMax01 | sed 's/'$leggoIdRoot'//g' > /tmp/xmluxe-gradusIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

			
echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi


		echo \"$leggoIdRoot \$newValue\" | sed 's/ //g' > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot 0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot \$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


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

############## fine gradusI move

### inizio gradusII move	
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

				touch /tmp/xmluxe-gradusIIList

				for b in $(ls /tmp/xmluxe-gradusII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIList

				done
### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-gradusIIPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-gradusIIPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-gradusIIList >  /tmp/xmluxe-gradusIIListToSort

				cat /tmp/xmluxe-gradusIIListToSort | sort > /tmp/xmluxe-gradusIIListSorted

				cat /tmp/xmluxe-gradusIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIListSortedMax0

				cat /tmp/xmluxe-gradusIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIListSortedMax01

				cat /tmp/xmluxe-gradusIIListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-gradusIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
		
		echo \"$leggoIdRoot$idNumericIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot$idNumericIPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot$idNumericIPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

				echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


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

				touch /tmp/xmluxe-gradusIIList

				for b in $(ls /tmp/xmluxe-gradusII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIList

				done

				### ti avviso che  per elementi inferiori al chapter avrai bisogno di comporre con più pezzi, e.g. per la sezione
## echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch
## Solo per il capitolo esiste tale alternativa commentata
#				cat /tmp/xmluxe-elementToMove | cut -d. -f1,1 > /tmp/xmluxe-gradusIIPrefixToMatch
				echo "$leggoIdRoot $idNumericIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIPrefixToMatch

				leggoChaPrefixToMatch="$(cat /tmp/xmluxe-gradusIIPrefixToMatch)"

				grep "$leggoChaPrefixToMatch" /tmp/xmluxe-gradusIIList >  /tmp/xmluxe-gradusIIListToSort

				cat /tmp/xmluxe-gradusIIListToSort | sort > /tmp/xmluxe-gradusIIListSorted

## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIListSortedMax0

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-gradusIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIListSortedMax01

				## ricordati di cambiare -f2,2 in numeri crescenti progresivamente per elementi inferiori al capitolo
				cat /tmp/xmluxe-gradusIIListSortedMax01 | cut -d. -f2,2 > /tmp/xmluxe-gradusIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi


		echo \"$leggoIdRoot$idNumericIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then

		echo \"$leggoIdRoot$idNumericIPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else

		echo \"$leggoIdRoot$idNumericIPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


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

### inizio gradusIII move	
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

				touch /tmp/xmluxe-gradusIIIList

				for b in $(ls /tmp/xmluxe-gradusIII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusIII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIIList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIIPrefixToMatch

				leggoKeyOrValuesPrefixToMatch="$(cat /tmp/xmluxe-gradusIIIPrefixToMatch)"

				grep "$leggoKeyOrValuesPrefixToMatch" /tmp/xmluxe-gradusIIIList > /tmp/xmluxe-gradusIIIListToSort

				cat /tmp/xmluxe-gradusIIIListToSort | sort > /tmp/xmluxe-gradusIIIListSorted

				cat /tmp/xmluxe-gradusIIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-gradusIIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIIListSortedMax01
				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-gradusIIIListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-gradusIIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=0

for n in {1..$nIterazioni}
do

var=\$var+1

originalValueN=\$(echo $leggoMaxValue -\$var + 1 | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN + $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.
		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN + $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN + $optionValue | bc)\"

		fi
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.0\$originalValueN\" > /tmp/xmluxe-idToMoveN

		else
		### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$originalValueN\" > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

		echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


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

				touch /tmp/xmluxe-gradusIIIList

				for b in $(ls /tmp/xmluxe-gradusIII)

				do

				leggoB="$(cat /tmp/xmluxe-gradusIII/$b)"
				
				echo "$leggoB" >> /tmp/xmluxe-gradusIIIList

				done
### ricordati di aggiungere $idNumericIIIPiece in subsection
				echo "$leggoIdRoot $idNumericIPiece.$idNumericIIPiece" | sed 's/ //g' > /tmp/xmluxe-gradusIIIPrefixToMatch

				leggoKeyOrValuesPrefixToMatch="$(cat /tmp/xmluxe-gradusIIIPrefixToMatch)"

				grep "$leggoKeyOrValuesPrefixToMatch" /tmp/xmluxe-gradusIIIList >  /tmp/xmluxe-gradusIIIListToSort

				cat /tmp/xmluxe-gradusIIIListToSort | sort > /tmp/xmluxe-gradusIIIListSorted
					
## se il primo ID della listaè inferiore a quello specificato dall'utente con --move='ID'
# allora non deve essere trattato. qua 

				cat /tmp/xmluxe-gradusIIIListSorted | tail -n1 > /tmp/xmluxe-gradusIIIListSortedMax0

				### ricordati di NON cambiare -f2,2 per elementi inferiori a section
				cat /tmp/xmluxe-gradusIIIListSortedMax0 | sed 's/>/ /g' | awk '$1 > 0 {print $1}' | cut -d= -f2,2 | sed 's/"//g' > /tmp/xmluxe-gradusIIIListSortedMax01

				### ricordati di cambiare -f3,3 in -f4,4 per la subsection
				cat /tmp/xmluxe-gradusIIIListSortedMax01 | cut -d. -f3,3 > /tmp/xmluxe-gradusIIIListSortedMax


				leggoMaxValuePre="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				if test $leggoMaxValuePre -lt 10

				then
					vim -c ":%s/^.//g" /tmp/xmluxe-gradusIIIListSortedMax -c :w -c :q

				fi

				leggoMaxValue="$(cat /tmp/xmluxe-gradusIIIListSortedMax)"

				nIterazioni=$(echo $leggoMaxValue - $originalValue +1 | bc)

echo "#!/bin/bash

declare -i var=-1

for n in {1..$nIterazioni}
do

var=\$var+1


originalValueN=\$(echo $originalValue +\$var | bc)

			if test \$originalValueN -lt 10

		then

		newValuePre=\"0\$(echo \$originalValueN - $optionValue | bc)\"
## devo creare una nuovo condizionale nel caso in cui in seguito alla somma, entrassi nella doppia cifra.

		if test \$newValuePre -lt 10

		then

			newValue=\"0\$(echo \$originalValueN - $optionValue | bc)\"

		else

			newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

		else

		newValue=\"\$(echo \$originalValueN - $optionValue | bc)\"

		fi

### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$newValue\" > /tmp/xmluxe-fullNewId

		fullNewID=\"\$(cat /tmp/xmluxe-fullNewId)\"

		if test \$originalValueN -lt 10

		then
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.0\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		else
### ricordati di aggiungere $idNumericIIIPiece in subsection
		echo \"$leggoIdRoot$idNumericIPiece.$idNumericIIPiece.\$originalValueN\" | sed 's/ //g' > /tmp/xmluxe-idToMoveN

		fi
		
		leggoIDToMoveN=\"\$(cat /tmp/xmluxe-idToMoveN)\"

		vim -c \":%s/\$leggoIDToMoveN/\$fullNewID/g\" $targetFile.lmx -c :w -c :q

			echo \"
$(date +\"%Y-%m-%d-%H-%M\")	\$leggoIDToMoveN moved to \$fullNewID\" >> $targetFile.lmxe

done

echo \" \"  >> $targetFile.lmxe

exit

" > cicloNIterazioni.sh

chmod uga+xr cicloNIterazioni.sh

./cicloNIterazioni.sh

rm cicloNIterazioni.sh


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

exit


