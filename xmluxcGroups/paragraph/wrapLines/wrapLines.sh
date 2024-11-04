#!/bin/bash

rm -fr /tmp/xmluxc-WrapLines*

targetFile="$(cat /tmp/xmluxcTargetFile)"

leggoGroup="$(cat /tmp/xmluxc-GroupsNameOrder)"

leggoInizioPre=$(cat /tmp/xmluxc-GroupsStartOrder)

leggoFinePre=$(cat /tmp/xmluxc-GroupsEndOrder)

01-marcatori () {
cp $targetFile.lmxp /tmp/xmluxc-WrapLinesTemp00

desinenzaS="s"
vim -c ":$leggoInizioPre$desinenzaS/^/xmluxcInizioBloccoXmluxc/g" /tmp/xmluxc-WrapLinesTemp00 -c :w -c :q

vim -c ":$leggoFinePre$desinenzaS/^/xmluxcFineBloccoXmluxc/g" /tmp/xmluxc-WrapLinesTemp00 -c :w -c :q

## L'effetto dei gruppi deve iniziare una riga sotto l'istanza dell'inizio del gruppo,
## e una riga prima della chiusura del gruppo.
leggoInizio=$(($leggoInizioPre + 1))

leggoFine=$(($leggoFinePre - 1))

cat /tmp/xmluxc-GroupsNameOrder | tr a-z A-Z > /tmp/xmluxc-startFunMaiuscolo

leggoFunMaiuscolo="$(cat /tmp/xmluxc-startFunMaiuscolo)"
}

01-marcatori

02-opzioni () {
## Opzioni

### Verifico se è stata espressa l'opzione, facoltativa, se non espressa essa si suppone [1].

if [ -f /tmp/xmluxc-GroupsNameWithOption ]; then

cat /tmp/xmluxc-GroupsNameWithOption | sed 's/.*\[//g' | sed 's/\]//g' > /tmp/xmluxc-WrapLinesOptionValue
## per WrapLines ho solo un opzione, il numero n di caratteri e.g. \start{ÆddTab}[1]

grep "," /tmp/xmluxc-GroupsNameWithOption > /tmp/xmluxc-GroupsNameWithOptionOneOrMore


stat --format %s /tmp/xmluxc-GroupsNameWithOptionOneOrMore > /tmp/xmluxc-GroupsNameWithOptionOneOrMoreBytes

leggoBytes=$(cat /tmp/xmluxc-GroupsNameWithOptionOneOrMoreBytes)


if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-GroupsNameWithOption |tr ',' '\n' | sed '/^$/d' | sed 's/.*\[//g' | sed 's/\]//g' > /tmp/xmluxc-GroupsNameWithOption01

else

cat /tmp/xmluxc-GroupsNameWithOption | sed 's/\]//g' > /tmp/xmluxc-GroupsNameWithOption01

fi



grep "width" /tmp/xmluxc-GroupsNameWithOption01 | cut -d= -f2,2 > /tmp/xmluxc-GroupsNameWithOptionWidth



WIDTH="$(cat /tmp/xmluxc-GroupsNameWithOptionWidth)"

grep "tab"  /tmp/xmluxc-GroupsNameWithOption01 | cut -d= -f2,2 > /tmp/xmluxc-GroupsNameWithOptionTABS

stat --format %s /tmp/xmluxc-GroupsNameWithOptionTABS > /tmp/xmluxc-GroupsNameWithOptionTABSBytes

leggoTABSBytes=$(cat /tmp/xmluxc-GroupsNameWithOptionTABSBytes)

if test $leggoTABSBytes -gt 0

then

	echo "esiste opzione Tab" > /tmp/xmluxc-WrapGroupsNameWithOptionTABSCimice
leggoTabValue=$(cat /tmp/xmluxc-GroupsNameWithOptionTABS)

fi


03-opzioneGq () {
#### OPZIONE GQ : spezzo con vim ->
grep "gq" /tmp/xmluxc-GroupsNameWithOption01 > /tmp/xmluxc-GroupsNameWithOptionGq

stat --format %s /tmp/xmluxc-GroupsNameWithOptionGq > /tmp/xmluxc-GroupsNameWithOptionGqBytes

leggoGqBytes=$(cat /tmp/xmluxc-GroupsNameWithOptionGqBytes)

## I if gq
if test $leggoGqBytes -gt 0

then

echo "L'opzione gq esiste" > /tmp/xmluxc-WrapLinesWrapGqExistsCimice

03.01-memorizzazioneCimiceGQ () {

sleep 0.5

dateh=$(date +"%Y_%m_%d_%H_%M_%S_%N")
## Inizio con Stock perché tale cartella non deve essere rimossa da tale script che viene avviato
## per ogni gruppo. Essa deve essere ripresa da xmluxc alla fine.
mkdir -p /tmp/xmluxc-StockWrapLinesGroups/$dateh-wrapLines_gq

## qua 
sed -n ''$leggoInizioPre'p' $targetFile.lmxp > /tmp/xmluxc-StockWrapLinesGroups/$dateh-wrapLines_gq/opzioniWrapGq

}

03.01-memorizzazioneCimiceGQ

## Devo rinominare l'inizio e la fine del gruppo altrimenti verrebbero eliminati da xmluxc.
## L'opzione gq la devo eseguire alla fine di xmluxc
03.02-rinominaGruppo () {

### Appendo le locuzioni
vim -c ":$leggoInizioPre$desinenzaS/^/stockInizioWrapLinesGq-$dateh/g" $targetFile.lmxp -c :w -c :q

vim -c ":$leggoFinePre$desinenzaS/^/stockFineWrapLinesGq-$dateh/g" $targetFile.lmxp -c :w -c :q

### Devo pulire ora altrimenti xmluxc elimina tutte le righe aventi \start e \finish, e quindi mi salterebbero
## i marcatori/cimici appena appesi (stockInizioWrapLinesGq-$dateh e stockFineWrapLinesGq-$dateh).
## Nel caso dovessi fare un giorno un codice con opzioni di default o senza opzioni
## codice attuali con opzioni
vim -c ":$leggoInizioPre$desinenzaS/\\\start{wrapLines}.*]//g" $targetFile.lmxp -c :w -c :q

vim -c ":$leggoFinePre$desinenzaS/\\\finish{wrapLines}//g" $targetFile.lmxp -c :w -c :q


##\start{* e \finish{ li elimino in xmluxc
}

03.02-rinominaGruppo

#read -p "435 testing chiusura gq" EnterNull

fi
}

03-opzioneGq
###  Chiusura opzione gq

fi
### Chiusura della Verifica: se è stata espressa l'opzione, facoltativa, se non espressa essa si suppone [1].

rm -f /tmp/xmluxc-GroupsNameWithOption01
}

02-opzioni


exit


