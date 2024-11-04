#!/bin/bash

rm -fr /tmp/xmluxc-Multicolumns*

targetFile="$(cat /tmp/xmluxcTargetFile)"

leggoGroup="$(cat /tmp/xmluxc-GroupsNameOrder)"

leggoInizioPre=$(cat /tmp/xmluxc-GroupsStartOrder)

leggoFinePre=$(cat /tmp/xmluxc-GroupsEndOrder)


sleep 0.5

dateh=$(date +"%Y_%m_%d_%H_%M_%S_%N")


01-marcatori () {
cp $targetFile.lmxp /tmp/xmluxc-MulticolumnsTemp00

desinenzaS="s"
vim -c ":$leggoInizioPre$desinenzaS/^/xmluxcInizioBloccoXmluxc/g" /tmp/xmluxc-MulticolumnsTemp00 -c :w -c :q

vim -c ":$leggoFinePre$desinenzaS/^/xmluxcFineBloccoXmluxc/g" /tmp/xmluxc-MulticolumnsTemp00 -c :w -c :q

## L'effetto dei gruppi deve iniziare una riga sotto l'istanza dell'inizio del gruppo,
## e una riga prima della chiusura del gruppo.
leggoInizio=$(($leggoInizioPre + 1))

leggoFine=$(($leggoFinePre - 1))

cat /tmp/xmluxc-GroupsNameOrder | tr a-z A-Z > /tmp/xmluxc-startFunMaiuscolo

leggoFunMaiuscolo="$(cat /tmp/xmluxc-startFunMaiuscolo)"
}

01-marcatori

### Il multicolumns essendo un gruppo dell'ambito dei paragrafi a eseguito dopo gli altri gruppi,
## soprattutto dopo i gruppi di wrapLines. A differenza di LaTeX io non imposto i blocchi dal multicolumns,
## ma imposto i blocchi autonomamente e multicolumns li assorbe e basta.

02-memorizzazioneCimiceMulticolumn () {
## Inizio con Stock perché tale cartella non deve essere rimossa da tale script che viene avviato
## per ogni gruppo. Essa deve essere ripresa da xmluxc alla fine.
mkdir -p /tmp/xmluxc-StockMulticolumn/$dateh-multicolumn

## Ancora non ho pensato opzioni per multicolumn, tuttavia lascio il nome come per wrapLines
sed -n ''$leggoInizioPre'p' $targetFile.lmxp > /tmp/xmluxc-StockMulticolumn/$dateh-multicolumn/opzioniMulticolumn

}

02-memorizzazioneCimiceMulticolumn



## Devo rinominare l'inizio e la fine del gruppo altrimenti verrebbero eliminati da xmluxc.
## L'opzione gq la devo eseguire alla fine di xmluxc
03-rinominaGruppo () {

### Appendo le locuzioni
vim -c ":$leggoInizioPre$desinenzaS/^/stockInizioMulticolumns-$dateh/g" $targetFile.lmxp -c :w -c :q

vim -c ":$leggoFinePre$desinenzaS/^/stockFineMulticolumns-$dateh/g" $targetFile.lmxp -c :w -c :q

### Devo pulire ora altrimenti xmluxc elimina tutte le righe aventi \start e \finish, e quindi mi salterebbero
## i marcatori/cimici appena appesi (stockInizioMulticolumns-$dateh e stockFineMulticolumns-$dateh).
## Nel caso dovessi fare un giorno un codice con opzioni di default o senza opzioni
## codice attuali con opzioni
### Se un giorno dovessi aggiungere opzioni, allora mi servirebbe .*]
#vim -c ":$leggoInizioPre$desinenzaS/\\\start{multicolumn}.*]//g" $targetFile.lmxp -c :w -c :q
vim -c ":$leggoInizioPre$desinenzaS/\\\start{multicolumn}//g" $targetFile.lmxp -c :w -c :q

vim -c ":$leggoFinePre$desinenzaS/\\\finish{multicolumn}//g" $targetFile.lmxp -c :w -c :q


##\start{* e \finish{ li elimino in xmluxc
}

03-rinominaGruppo

#read -p "82 testing multicolumn" EnterNull


exit


