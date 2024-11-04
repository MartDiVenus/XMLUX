#!/bin/bash


rm -fr /tmp/xmluxc-multicolumn*

rm -fr /tmp/xmluxc-Multicolumns*

targetFile="$(cat /tmp/xmluxcTargetFile)"

mkdir /tmp/xmluxc-multicolumnSplit

split -l1 /tmp/xmluxc-StockMulticolumnResp /tmp/xmluxc-multicolumnSplit/

01.cf () {
for a in $(ls /tmp/xmluxc-multicolumnSplit)

do

01.01-variabili () {
codiceIdentificativoPre=$(cat /tmp/xmluxc-multicolumnSplit/$a)

echo $codiceIdentificativoPre | cut -d- -f2,2 | cut -d/ -f2,2 > /tmp/xmluxc-multicolumnCodiceIdentificativo

codiceIdentificativo="$(cat /tmp/xmluxc-multicolumnCodiceIdentificativo)"

pathFileOpzioni="$(cat /tmp/xmluxc-multicolumnSplit/$a)"

}

01.01-variabili

01.02-individuazioneBlocchi () {

## Tutto ciò che c'è prima di  xmluxcInizioMulticolumns
#sed '/stockInizioMulticolumns-'$codiceIdentificativo'/q' $targetFile.xml > /tmp/xmluxc-Multic01

## Tutto ciò che c'è prima di  \multic
#sed '/\\multic/q' $targetFile.xml > /tmp/xmluxc-Multic02

#comm -3 /tmp/xmluxc-Multic01 /tmp/xmluxc-Multic02 | sed 's/^\(.\{1\}\)//' > /tmp/xmluxc-Multic03


## Tutto ciò che prima  xmluxcFineMulticolumns
#sed '/stockFineMulticolumns-'$codiceIdentificativo'/q' $targetFile.xml > /tmp/xmluxc-Multic04

grep -n "stockInizioMulticolumns-$codiceIdentificativo" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxc-MulticStart

grep -n "stockFineMulticolumns-$codiceIdentificativo" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxc-MulticFinish

leggoInizio=$(cat /tmp/xmluxc-MulticStart)

leggoFine=$(cat /tmp/xmluxc-MulticFinish)

sed -n ''$leggoInizio','$leggoFine'p' $targetFile.xml > /tmp/xmluxc-Multic01

## I pezzo
cat /tmp/xmluxc-Multic01 | sed '/\\multic/q' | sed '/\\multic/d' | sed 's/^ //g' | sed '/stockInizioMulticolumns-'$codiceIdentificativo'/d' > /tmp/xmluxc-Multic02

## Devo eliminare gli spazi bianchi a fine riga, altrimenti mi slittano la colonna adiacente.
## Io separo le colonne con i tab in esadeciamale, puoi scelgiere altre misure per separare: ma sempre
## in esadecimale mai con l'input da tastiera.
cat /tmp/xmluxc-Multic02 | sed 's/ $//g'  | sed 's/\ *$//g' | sed -r '/^\s*$/d' | sed '/^$/d' > /tmp/xmluxc-Multic02b

grep -n "\\\multic" /tmp/xmluxc-Multic01  | cut -d: -f1,1 >  /tmp/xmluxc-MulticRelativo

multicRelativo=$(cat /tmp/xmluxc-MulticRelativo)

grep -n "stockFineMulticolumns-$codiceIdentificativo" /tmp/xmluxc-Multic01 | cut -d: -f1,1 > /tmp/xmluxc-MulticFinishRelativo

finishRelativo=$(cat /tmp/xmluxc-MulticFinishRelativo)

## II pezzo
cat /tmp/xmluxc-Multic01 | sed -n ''$multicRelativo','$finishRelativo'p'  | sed 's/^ //g'  | sed '/\\multic/d' | sed '/stockFineMulticolumns-'$codiceIdentificativo'/d'>  /tmp/xmluxc-Multic03

## Un tab lo elimino sempre, e.g. se la colonna a dx è distanziata di due tab, uno alla prima riga lo elimino,
## per allineare. Ma ho pensato il seguente metodo automatico (quello non commentato).
#cat /tmp/xmluxc-Multic03 | sed 's/\ *$//g' | sed -r '/^\s*$/d' | sed '/^$/d' | sed '1s/\&#x9;//' > /tmp/xmluxc-Multic03b

cat /tmp/xmluxc-Multic03 | sed 's/\ *$//g' | sed -r '/^\s*$/d' | sed '/^$/d' > /tmp/xmluxc-Multic03b

awk '{ nlines++;  print nlines }' /tmp/xmluxc-Multic02b | tail -n1 > /tmp/xmluxc-Multic02bNLines

nLines02b=$(cat /tmp/xmluxc-Multic02bNLines)

awk '{ nlines++;  print nlines }' /tmp/xmluxc-Multic03b | tail -n1 > /tmp/xmluxc-Multic03bNLines

nLines03b=$(cat /tmp/xmluxc-Multic03bNLines)

## Se la colonna a dx ha un n. di righe maggiore rispetto a quella di sx:
## devo eliminare alla colonna di dx un tab per ogni riga, quante sono quelle di sx.
if test $nLines03b -gt $nLines02b

then
	cat /tmp/xmluxc-Multic03b | sed '1,'$nLines02b's/\&#x9;//' > /tmp/xmluxc-Multic03c

	cp /tmp/xmluxc-Multic03c /tmp/xmluxc-Multic03b

fi

## altrimenti, devo aggiungere alla colonna di dx tab.
if test $nLines03b -lt $nLines02b

then

desinenzaS="s"

vim -c ":1,$nLines03b$desinenzaS/^/\&#x9;/" /tmp/xmluxc-Multic03b -c :w -c :q

fi


paste -d{ /tmp/xmluxc-Multic02b /tmp/xmluxc-Multic03b > /tmp/xmluxc-Multic04

vim -c ":%s/{//g" /tmp/xmluxc-Multic04 -c :w -c :q

#read -p "testing 49 multicolumnsNow" EnterNull

## comm si porta via stockInizioMulticolumns-'$codiceIdentificativo', ma mi serve per l'iniezione
echo "stockInizioMulticolumns-$codiceIdentificativo" > /tmp/xmluxc-MulticolumnsTemp05

cat /tmp/xmluxc-MulticolumnsTemp05 /tmp/xmluxc-Multic04 > /tmp/xmluxc-Multic06

#read -p "testing 55 multicolumnsNow" EnterNull

}

01.02-individuazioneBlocchi


01.03-iniezione () {
## iniezione

## Tutto ciò che c'è prima di  xmluxcInizioMulticolumns
sed '/stockInizioMulticolumns-'$codiceIdentificativo'/q' $targetFile.xml > /tmp/xmluxc-Multic07

## Tutto ciò che c'è dopo di stockFineMulticolumns-'$codiceIdentificativo
cat $targetFile.xml| grep -A 1000000000000000000 "stockFineMulticolumns-$codiceIdentificativo" > /tmp/xmluxc-MulticolumnsTemp08

cat /tmp/xmluxc-Multic07 /tmp/xmluxc-Multic06 > /tmp/xmluxc-MulticolumnsTemp09

cat /tmp/xmluxc-MulticolumnsTemp09 /tmp/xmluxc-MulticolumnsTemp08 > /tmp/xmluxc-MulticolumnsTemp10

#read -p "testing 184" EnterNull

## Ho già pulito:
sed '/stockInizioMulticolumns-'$codiceIdentificativo'/d' /tmp/xmluxc-MulticolumnsTemp10 > /tmp/xmluxc-MulticolumnsTemp11

sed '/stockFineMulticolumns-'$codiceIdentificativo'/d' /tmp/xmluxc-MulticolumnsTemp11 > /tmp/xmluxc-MulticolumnsTemp12

#read -p "testing 82 multicolumnsNow" EnterNull


cp /tmp/xmluxc-MulticolumnsTemp12 $targetFile.xml

}

01.03-iniezione

#rm -r /tmp/xmluxc-multicolumnSplit/$a


done

}

01.cf


rm -f /tmp/xmluxc-StockMulticolumns

#### Il ciclo che chiudo prima dell'exit del testing di sviluppo, qua qui.
## done
#read -p "435 testing chiusura gq" EnterNull
###  Chiusura opzione gq
exit




