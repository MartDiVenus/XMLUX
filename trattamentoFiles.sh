#!/bin/bash

## !! a volte /tmp/xmlux-fullName viene creato con uno spazio finale,
## in /usr/local/lib/xmlux/filesCartelle/directSelect/1/perChiaveAlfanumerica/files/files.sh
## ho rimosso tale problema, ma per non perdere tempo nel correggere gli "infiniti" miei script
## che generano /tmp/xmlux-fullName---correggo qui in trattamentoFiles.sh. 
cat /tmp/xmlux-fullName | sed 's/ //g' > /tmp/xmlux-fullNameCleaned

cat /tmp/xmlux-fullNameCleaned | sed 's/\// /g' > /tmp/xmlux-sostSlashBlank

sed 's/[^ ]//g' /tmp/xmlux-sostSlashBlank | awk '{ print length }' > /tmp/xmlux-colC.txt

numberOfColumn=$(cat /tmp/xmlux-colC.txt)

sed 's/[^/]//g' /tmp/xmlux-fullNameCleaned | awk '{ print length }' > /tmp/xmlux-countSlash


leggoCountSlash=$(cat /tmp/xmlux-countSlash)


#read -p "18 testing" EnterNull

if test $leggoCountSlash -eq 0

then

cat /tmp/xmlux-fullNameCleaned  > /tmp/xmlux-nomeFileIsolato

# testing
#echo " "
#echo "nome file isolato"
#cat /tmp/xmlux-nomeFileIsolato


# nome file senza estensione
## non uso cut perché se il file avesse più punti, allora occorrerebbero altri accorgimenti.
cat /tmp/xmlux-nomeFileIsolato | sed 's/\./ /g' > /tmp/xmlux-nomeSenzaEstensionePre
## il I campo è il nome senza estensione
cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $1}' > /tmp/xmlux-nomeSenzaEstensione
cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $2}' > /tmp/xmlux-tipoEstensione


#read -p "43 testing" EnterNull


# testing
#echo " "
#echo "nome senza estensione"
#cat /tmp/xmlux-nomeSenzaEstensione

# testing
#echo " "

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

#read -p "testing trattamentoFiles 53" EnterNull
else

if test $leggoCountSlash -eq 1

then


# dopo l'ultima /
# selezione il nome del file
cat /tmp/xmlux-fullNameCleaned |sed 's/.*\///' > /tmp/xmlux-nomeFileIsolato
# testing
#echo " "
#echo "nome file isoltato"
#cat /tmp/xmlux-nomeFileIsolato


# nome file senza estensione
## non uso cut perché se il file avesse più punti, allora occorrerebbero altri accorgimenti.
cat /tmp/xmlux-nomeFileIsolato | sed 's/\./ /g' > /tmp/xmlux-nomeSenzaEstensionePre
## il I campo è il nome senza estensione
cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $1}' > /tmp/xmlux-nomeSenzaEstensione
cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $2}' > /tmp/xmlux-tipoEstensione
#read -p "testing 80" EnterNull

# testing
#echo " "
#echo "nome senza estensione"
#cat /tmp/xmlux-nomeSenzaEstensione


### Percorso isolato


## prima dell'ultima / non funziona in caso di più /, quindi ricorro al nome del file
# cat /tmp/xmlux-fullNameCleaned |sed 's/\/.*//' > /tmp/xmlux-percorsoIsolato


## esprimendo il nome del file non funziona in caso di omonimia tra nome file e una cartella,
# e.g. prova/prova
# seleziono il percorso privo del nome del file
# nomeFile="$(cat /tmp/xmlux-nomeFileIsolato)"
## l'ultimo sed elimina l'ultima /, comodo per esprimere la variabile $pathIsolato in codici esterni
## isolandola da ciò che viene a dx, e.g. $pathIsolato/prova.txt
#cat /tmp/xmlux-fullNameCleaned  |sed 's/'$nomeFile'.*//'  | sed 's/\/$//g' > /tmp/xmlux-percorsoIsolato


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
cat /tmp/xmlux-fullNameCleaned | sed 's/.*\///' > /tmp/xmlux-nomeFileIsolato
# testing
#echo " "
#echo "nome file isoltato"
#cat /tmp/xmlux-nomeFileIsolato
#read -p "testing 181" EnterNull

# nome file senza estensione
## non uso cut perché se il file avesse più punti, allora occorrerebbero altri accorgimenti.
#vi -s /usr/local/lib/backemerg/command-sost-pto /tmp/xmlux-nomeFileIsolato
cat /tmp/xmlux-nomeFileIsolato | sed 's/\./ /g' > /tmp/xmlux-nomeSenzaEstensionePre
#read -p "testing 187" EnterNull

## il I campo è il nome senza estensione
cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $1}' > /tmp/xmlux-nomeSenzaEstensione
cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $2}' > /tmp/xmlux-tipoEstensione

########## Percorso isolato
cat /tmp/xmlux-fullNameCleaned | sed 's/\/[^\/]*$//' > /tmp/xmlux-percorsoIsolato

#read -p "testing 205
#cat nomeFileIsolatoEchoed = $(cat /tmp/xmlux-nomeIsolatoDotEchoed)
#cat /tmp/xmlux-percorsoIsolato00 = $(cat /tmp/xmlux-percorsoIsolato00)
#" EnterNull

##<</home/mart/test3/a/>>
### OK 2024.05.04
#else

#cat /tmp/xmlux-fullName | sed 's/'$nomeFileIsolatoEchoed'//g' > /tmp/xmlux-percorsoIsolato00

#cat /tmp/xmlux-percorsoIsolato00 | sed 's/\/$//g' > /tmp/xmlux-percorsoIsolato

#fi
# dopo l'ultima /
# selezione il nome del file
#cat /tmp/xmlux-fullNameCleaned |sed 's/.*\///' > /tmp/xmlux-nomeFileIsolato
# testing
#echo " "
#echo "nome file isoltato"
#cat /tmp/xmlux-nomeFileIsolato


# nome file senza estensione
## non uso cut perché se il file avesse più punti, allora occorrerebbero altri accorgimenti.
## non uso cut perché se il file avesse più punti, allora occorrerebbero altri accorgimenti.
#cat /tmp/xmlux-nomeFileIsolato | sed 's/\./ /g' > /tmp/xmlux-nomeSenzaEstensionePre
## il I campo è il nome senza estensione
#cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $1}' > /tmp/xmlux-nomeSenzaEstensione
#cat /tmp/xmlux-nomeSenzaEstensionePre | awk '$1 > 0 {print $2}' > /tmp/xmlux-tipoEstensione


# testing
#echo " "
#echo "nome senza estensione"
#cat /tmp/xmlux-nomeSenzaEstensione


### Percorso isolato

## prima dell'ultima / non funziona in caso di più /, quindi ricorro al nome del file
# cat /tmp/xmlux-fullNameCleaned |sed 's/\/.*//' > /tmp/xmlux-percorsoIsolato


## esprimendo il nome del file non funziona in caso di omonimia tra nome file e una cartella,
# e.g. prova/prova
# seleziono il percorso privo del nome del file
# nomeFile="$(cat /tmp/xmlux-nomeFileIsolato)"
## l'ultimo sed elimina l'ultima /, comodo per esprimere la variabile $pathIsolato in codici esterni
## isolandola da ciò che viene a dx, e.g. $pathIsolato/prova.txt
#cat /tmp/xmlux-fullNameCleaned  |sed 's/'$nomeFile'.*//'  | sed 's/\/$//g' > /tmp/xmlux-percorsoIsolato


#cat /tmp/xmlux-fullNameCleaned | sed 's/\// /g' > /tmp/xmlux-sostSlashBlank

# e.g. a/b
# ho una slash e due colonne
# e.g. /a
# ho una slash  1 colonna

## In tal caso va numberOfColumn
#echo $numberOfColumn - 1| bc > /tmp/xmlux-nCampiMinusLast

#nColonneMinusLast=$(cat /tmp/xmlux-nCampiMinusLast)

# stampo i campi dal I al penultimo, sulla stessa linea (I tr)
#cat /tmp/xmlux-sostSlashBlank | awk -v inizio=1 -v fine=$nColonneMinusLast '{for(i=inizio;i<=fine;i++) print $i}' > /tmp/xmlux-pathBlanked
#cat /tmp/xmlux-sostSlashBlank | awk -v inizio=1 -v fine=$numberOfColumn '{for(i=inizio;i<=fine;i++) print $i}' > /tmp/xmlux-pathBlanked


## inserisco le / alla fine di ogni riga
#vim -c ":%s/$/\//g" /tmp/xmlux-pathBlanked -c :w -c :q
# read -p "sto a 143" EnterNull

## porto tutto sulla stella linea
#cat /tmp/xmlux-pathBlanked | tr -d '\n' > /tmp/xmlux-percorsoIsolato
# read -p "sto a 147" EnterNull

# read -p "sto a 152" EnterNull
## elimino l'ultima / perché è comodo scrivere in script esterni: $pathIsolato/bla 
#vim -c ":%s/\/$//g" /tmp/xmlux-percorsoIsolato -c :w -c :q
#read -p "testing trattamentoFiles 328" EnterNull

#read -p "testing 314" EnterNull

	# il percorso è a sx della /
# testing
#echo " "
#echo "percorso isolato e.g. a/b/C"
#cat /tmp/xmlux-percorsoIsolato

#fi
	# testing 
#	 read -p "sto a 90" EnterNull



fi

fi

exit

