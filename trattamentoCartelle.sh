#!/bin/bash

## !! a volte /tmp/xmlux-fullName viene creato con uno spazio finale,
## in /usr/local/lib/xmlux/filesCartelle/directSelect/1/perChiaveAlfanumerica/files/files.sh
## ho rimosso tale problema, ma per non perdere tempo nel correggere gli "infiniti" miei script
## che generano /tmp/xmlux-fullName---correggo qui in trattamentoFiles.sh. 
cat /tmp/xmlux-fullName | sed 's/ //g' | sed 's/\/$//g' > /tmp/xmlux-fullNameCleaned

cat /tmp/xmlux-fullNameCleaned | sed 's/\// /g' > /tmp/xmlux-sostSlashBlank

sed 's/[^ ]//g' /tmp/xmlux-sostSlashBlank | awk '{ print length }' > /tmp/xmlux-colC.txt

numberOfColumn=$(cat /tmp/xmlux-colC.txt)

sed 's/[^/]//g' /tmp/xmlux-fullNameCleaned | awk '{ print length }' > /tmp/xmlux-countSlash


leggoCountSlash=$(cat /tmp/xmlux-countSlash)


#read -p "18 testing" EnterNull

if test $leggoCountSlash -eq 0

then

cat /tmp/xmlux-fullNameCleaned  > /tmp/xmlux-nomeCartellaIsolata

# testing
#echo " "
#echo "nome file isolato"
#cat /tmp/xmlux-nomeCartellaIsolata
stat --format %s /tmp/xmlux-nomeCartellaIsolata > /tmp/xmlux-cartellaIsolataBytes

leggoCartellaIsolataBytes=$(cat /tmp/xmlux-cartellaIsolataBytes)

if test $leggoCartellaIsolataBytes -eq 1
then

	## come cartella è stata dichiarata la radice
	echo "/" > /tmp/xmlux-nomeCartellaIsolata

	## per la radice non si può esprimere alcun percorso isolato
	exit

else


echo "$PWD" > /tmp/xmlux-percorsoIsolato

## ATTENZIONE!!!!!!!!!!!!!!!!
## per programmi come la copia diretta di files in xmlux, 
## occorre verificare:
## <if test "$leggoPercorsoIsolato" == "$PWD">>
## perché al posto di $PWD deve esserci la $path sorgente della copia.
## Lo stesso caso si presenta nella copia diretta di cartelle in xmlux,
## ma non occorre verificare con il condizionale $PWD perché verifico diversamente.
## Questo $PWD serve quando specifico file nella stessa posizione del terminale, e.g.
## luxdim --f=a.txt
## Quindi è corretto il codice di trattamentoFiles.sh, devi solo adeguare i codici
## che hanno bisogno delle proprie calibrazioni.
fi

#read -p "testing trattamentoFiles 53" EnterNull
else

if test $leggoCountSlash -eq 1

then


# dopo l'ultima /
# selezione il nome del file
cat /tmp/xmlux-fullNameCleaned |sed 's/.*\///' > /tmp/xmlux-nomeCartellaIsolata
# testing
#echo " "
#echo "nome file isoltato"
#cat /tmp/xmlux-nomeCartellaIsolata


### Percorso isolato

## devo capire se ho 
# e.g. a/b
# ho una slash e due colonne
# o e.g. /a
# ho una slash  1 colonna

## se eliminando il primo carattere, il numero di colonne cambia significa che lo spazio
# è all'inizio del file, quindi che il percorso è la radice del file system

cp /tmp/xmlux-sostSlashBlank /tmp/xmlux-sostSlashBlankRadix

vim -c ":1,1s/^.//g" /tmp/xmlux-sostSlashBlankRadix -c :w -c :q

sed 's/[^ ]//g' /tmp/xmlux-sostSlashBlankRadix | awk '{ print length }' > /tmp/xmlux-colCRadix.txt

	# qua 
numberOfColumnRadix=$(cat /tmp/xmlux-colCRadix.txt)

if test ! $numberOfColumn -eq $numberOfColumnRadix

then

	echo "/" > /tmp/xmlux-percorsoIsolato 
#read -p "testing trattamentoFiles 124" EnterNull

# testing
#echo " "
#echo "percorso isolato è la radice del file system e.g. /b"
#cat /tmp/xmlux-percorsoIsolato

else

	# il percorso è a sx della /

cat /tmp/xmlux-fullNameCleaned | cut -d/ -f1,"$numberOfColumn" > /tmp/xmlux-percorsoIsolato

#read -p "testing trattamentoFiles 137" EnterNull

# testing
#echo " "
#echo "percorso isolato e.g. a/b"
#cat /tmp/xmlux-percorsoIsolato

fi
	# testing 
#	 read -p "sto a 90" EnterNull
else
	## significa che il numero di slash è maggiore di 1


	## devo capire di nuovo se ho 
# e.g. a/b/c
# ho due slash e tre colonne
# o e.g. /a/b/c
# ho tre slash e tre colonna


## se eliminando il primo carattere, il numero di colonne cambia significa che lo spazio
# è all'inizio del file, quindi che il percorso è la radice del file system

cp /tmp/xmlux-sostSlashBlank /tmp/xmlux-sostSlashBlankRadix

vim -c ":1,1s/^.//g" /tmp/xmlux-sostSlashBlankRadix -c :w -c :q

sed 's/[^ ]//g' /tmp/xmlux-sostSlashBlankRadix | awk '{ print length }' > /tmp/xmlux-colCRadix.txt

	# qua 
numberOfColumnRadix=$(cat /tmp/xmlux-colCRadix.txt)



# dopo l'ultima /
# selezione il nome del file
cat /tmp/xmlux-fullNameCleaned |sed 's/.*\///' > /tmp/xmlux-nomeCartellaIsolata
## aka
########### Cartella isolata
    ## 1. elimino l'ultimo spazio a dx, se esiste
    ## 2. elimino l'ultima slash
    ## 3. sostituisco le slash con gli spazi
    ## 4. elimino tutto ciò che viene prima dell'ultimo spazio
#    cat /tmp/xmlux-fullNameCleaned | sed 's/ //g' | sed 's/\/$//g' | sed 's/\// /g' | sed 's/.* //g' > nomeCartellaIsolata

########## Percorso isolato
cat /tmp/xmlux-fullNameCleaned | sed 's/\/[^\/]*$//' > /tmp/xmlux-percorsoIsolato


### altro metodo
#field=$(($numberOfColumn - 1))
#cat /tmp/xmlux-sostSlashBlank | awk -v inizio=1 -v fine=$field '{for(i=inizio;i<=fine;i++) print " " $i}' | tr -d '\n' > /tmp/xmlux-percorsoIsolato00

#cat /tmp/xmlux-percorsoIsolato00 | sed 's/ /\//g' > /tmp/xmlux-percorsoIsolato

## sia per /a/b/c che per a/b/c crea sempre uno spazio davanti ad a,
# devo differenziare perché peer /a/b/c va bene in quanto sostituisco poi gli spazi con </>,
# ma per <a/b/c> non va bene.
   
fi

fi

exit

