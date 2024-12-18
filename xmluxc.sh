#!/bin/bash

############################ Eseguibile per la compilazione
rm -fr /tmp/xmluxc*

## not recursively

#touch /tmp/xmluxc-allIDs

#touch /tmp/xmluxc-allElements

#touch /tmp/xmluxc-allTitles

#touch /tmp/xmluxc-itemsEtIDs

#touch /tmp/xmluxc-itemsEtIDsEtTitles

#touch /tmp/xmluxc-IDsEtTitles

#touch /tmp/xmluxc-itemsEtTitles

## recursively

#touch /tmp/xmluxc-allIDsRec

#touch /tmp/xmluxc-allElementsRec

#touch /tmp/xmluxc-allTitlesRec

#touch /tmp/xmluxc-itemsEtIDsRec

#touch /tmp/xmluxc-itemsEtIDsEtTitlesRec

#touch /tmp/xmluxc-IDsEtTitlesRec

#touch /tmp/xmluxc-itemsEtTitlesRec


rm -fr /tmp/xmluxcPseudoOptions

mkdir /tmp/xmluxcPseudoOptions

rm -fr /tmp/xmluxcPseudoOptionsSchemi

mkdir /tmp/xmluxcPseudoOptionsSchemi

## Possibile opzione/azione
leggo1="$(echo $1 > /tmp/xmluxcPseudoOptions/01)"

## Possibile opzione/azione  
leggo2="$(echo $2 > /tmp/xmluxcPseudoOptions/02)"

## Possibile opzione/azione  
leggo3="$(echo $3 > /tmp/xmluxcPseudoOptions/03)"

## Target: percorso e nome del file
leggo4="$(echo $4 >  /tmp/xmluxcPseudoOptions/04)"

rileggoInput1="$(cat /tmp/xmluxcPseudoOptions/01 2> /dev/null)"

if test "$rileggoInput1" == "-h"

then

	clear 
	
	echo " "
	echo " "	
	echo " "	
	echo " "	
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
	echo " "
echo "
NAme: xmluxc
Goal: To compile *.lmx files to have xml files.
	
help			-h


target file		--f='file name without extension'
wildcard * as -f entire value or partial value, is accepted.
If you have (into the project folder) one *.lmx only [together other xmlux files],
as default and as I suggest, just type one * [e.g. --f=*].


margin borders		--margin=true


usage
cd 'path of the project'
xmluxc -option --action --f='name of the file without extension'

e.g.:
xmluxc -fgreeting

xmluxc --margin=true --f=greeting

Copyright:
Copyright (C) 2023.09.23 Mario Fantini (ing.mariofantini@gmail.com).
Bash copyright applies to its Mario Fantini's BASH usage.
GNU copyright applies to its Mario Fantini's GNU tools usage.
XML copyright applies to its Mario Fantini's XML tools usage.
VIM copyright applies to its Mario Fantini's VIM usage.
Java copyright applies to its Mario Fantini's JAVA tools usage.
And so on.
"

rm -fr /tmp/xmluxc*

exit

fi

for a in $(ls /tmp/xmluxcPseudoOptions)

do

	grep "^--f=" /tmp/xmluxcPseudoOptions/$a > /tmp/xmluxcTargetFileOp

	stat --format %s /tmp/xmluxcTargetFileOp > /tmp/xmluxcTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxcTargetFileBytes)

	if test $leggoBytes -gt 1

	then

	cat /tmp/xmluxcPseudoOptions/$a | sed 's/--f=//g' > /tmp/xmluxcTargetFilePre

        fi
done

leggoTargetFilePre="$(cat /tmp/xmluxcTargetFilePre)"

ls $leggoTargetFilePre.lmx | cut -d. -f1,1 > /tmp/xmluxcTargetFile

targetFile="$(cat /tmp/xmluxcTargetFile)"

###### Caratteri

### L'istanza deve essere:
## xmluxc -f/home/mart/test3/3-xmlux/matter 
## non xmluxc -f/home/mart/test3/3-xmlux/matter.xml
#targetFile="/home/mart/test3/3-xmlux/matter"

###### Caratteri
### per non eseguire inutilmente sostituzioni inesistenti, seleziono
## solo quelle necessarie.

cp $targetFile.lmx $targetFile.lmxp

cp $targetFile.lmx $targetFile.lmx.back

#cat $targetFile.lmx.back | sed '/<!--/d' > $targetFile.lmx
#cp  $targetFile.lmx  $targetFile.lmxc

#cp  $targetFile.lmx  $targetFile.lmxpa

### Elimino spazi indicati da {}
#vim -c ":%s/{}//g" $targetFile.lmx -c :w -c :q
### Gruppi, ambienti, comandi
## Rispettare il rigoroso ordine cronologico. Non puoi elaborare prima i comandi
## e poi i gruppi.

01-gruppi () {
### Groups

01.01-individuazioneGruppi () {

grep "\\\start{" $targetFile.lmx | awk '$1 > 0 {print $1}' | sed 's/\\start{//g' | sed 's/}//g' > /tmp/xmluxc-groups

stat --format %s /tmp/xmluxc-groups > /tmp/xmluxc-groupBytes

leggoBytes=$(cat /tmp/xmluxc-groupBytes)

if test $leggoBytes -gt 0

then

mkdir /tmp/xmluxc-group

mkdir /tmp/xmluxc-groupSplit

split -l1 /tmp/xmluxc-groups /tmp/xmluxc-groupSplit/

cp $targetFile.lmx /tmp/xmluxc-$targetFile.lmx.01


declare -i var=0

for a in $(ls /tmp/xmluxc-groupSplit/)

do

var=var+1

cat /tmp/xmluxc-groupSplit/$a | sed 's/\[.*//g' > /tmp/xmluxc-GroupsNewForm

leggoGroup="$(cat /tmp/xmluxc-GroupsNewForm)"

## in caso di più gruppi, mi servo di head e tail per selezionarli uno alla volta.
grep -n "{$leggoGroup}" /tmp/xmluxc-$targetFile.lmx.01 | cut -d: -f1,1 | awk '$1 > 0 {print $1}' | head -n1 | tail -n1 > /tmp/xmluxc-groupNLine

leggoInizio=$(cat /tmp/xmluxc-groupNLine)

desinenza="s"

vim -c ":$leggoInizio$desinenza/^/perSelezionare /g" /tmp/xmluxc-$targetFile.lmx.01 -c :w -c :q

sintagma="perSelezionare "

cat /tmp/xmluxc-$targetFile.lmx.01 | grep -A 10000000000000000 "perSelezionare " > /tmp/xmluxc-After

grep -n "\\\finish{$leggoGroup}" /tmp/xmluxc-After | cut -d: -f1,1 | awk '$1 > 0 {print $1}' | head -n1 > /tmp/xmluxc-finishNLinePre

addendoPre=$(cat /tmp/xmluxc-finishNLinePre)

addendo=$(($addendoPre - 1))

leggoFine=$(($leggoInizio + $addendo))

mkdir /tmp/xmluxc-group/$var

cat /tmp/xmluxc-groupSplit/$a > /tmp/xmluxc-GroupsName

## devo ribattere la variabile per scrivere il gruppo comprensivo di opzioni
leggoGroupReale="$(cat /tmp/xmluxc-GroupsName)"

echo "$leggoInizio $leggoFine $leggoGroupReale" > /tmp/xmluxc-group/$var/info.txt

#read -p "testing xmluxc 232" EnterNull

## Non posso eliminare le righe per pulizia altrimenti mi sballa l'ordine.
##sed '/^perSelezionare /d' /tmp/xmluxc-$targetFile.lmx.01 > /tmp/xmluxc-$targetFile.lmx.02
##sed '/^perPulireFine /d' /tmp/xmluxc-$targetFile.lmx.02 > /tmp/xmluxc-$targetFile.lmx.01

## E` giusto invece tale metodo:
## Per aggiornare, elimino la riga appena scansionata per \start, creandone una con un commento descrittivo ->
## per non falsare i prossimi \start e \finish
cat /tmp/xmluxc-$targetFile.lmx.01 | sed ''$leggoInizio's/^.*/<!-- to del -->/g' > /tmp/xmluxc-$targetFile.lmx.02

## Per aggiornare, elimino la riga appena scansionata per \finish, creandone una con un commento descrittivo ->
## per non falsare i prossimi \start e \finish
cat /tmp/xmluxc-$targetFile.lmx.02 | sed ''$leggoFine's/^.*/<!-- to del -->/g' > /tmp/xmluxc-$targetFile.lmx.01

done

## Devo iniziare a elaborare dagli start finali, in modo da rispettare la precedenza:
## quelli interni vanno elaborati per primi. e.g. se dovessi formattare un paragrafo
## con i TAB, e volessi anche spezzarlo in lunghezze opportune: prima devo spezzarlo
## e poi devo applicare i TAB. Quindi il gruppo per spezzarlo deve essere interno
## a quello dei TAB, e il primo deve essere elaborato prima di quello dei TAB.

ls -1 /tmp/xmluxc-group/ > /tmp/xmluxc-startLs

awk '{ nlines++;  print nlines }' /tmp/xmluxc-startLs | tail -n1 > /tmp/xmluxc-startNLines

leggoNLines=$(cat /tmp/xmluxc-startNLines)

## per il contatore, per non avere alla fine var=0: aggiungo 1

leggoNLinesPlusUno=$(($leggoNLines + 1))

declare -i var=$leggoNLinesPlusUno

for b in $(ls /tmp/xmluxc-group)

do
	var=var-1
	
#	cat /tmp/xmluxc-startLs | head -n$var | tail -n1 > /tmp/xmluxc-startOrder-$var

cat /tmp/xmluxc-group/$var/info.txt | awk '$1 > 0 {print $1}' > /tmp/xmluxc-GroupsStartOrder

cat /tmp/xmluxc-group/$var/info.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-GroupsEndOrder

## con sed elimino eventuali opzioni: e.g. \start{addTab}[1]
grep "\[" /tmp/xmluxc-group/$var/info.txt > /tmp/xmluxc-GroupsOptionsOrNot


stat --format %s /tmp/xmluxc-GroupsOptionsOrNot > /tmp/xmluxc-GroupsOptionsOrNotBytes

leggoGroupsOptionsOrNotBytes=$(cat /tmp/xmluxc-GroupsOptionsOrNotBytes)

rm -f /tmp/xmluxc-GroupsNameWithOption

if test $leggoGroupsOptionsOrNotBytes -gt 0

then

cat /tmp/xmluxc-group/$var/info.txt | awk '$1 > 0 {print $3}' | sed 's/\[.*//g' > /tmp/xmluxc-GroupsNameOrder

## con sed elimino eventuali opzioni: e.g. \start{addTab}[1]
cat /tmp/xmluxc-group/$var/info.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-GroupsNameWithOption


else

cat /tmp/xmluxc-group/$var/info.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-GroupsNameOrder

fi

leggoGroupName="$(cat /tmp/xmluxc-GroupsNameOrder)"

find /usr/local/lib/xmlux/xmluxcGroups -name "$leggoGroupName.sh" > /tmp/xmluxc-groupScript

leggoGroupScript="$(cat /tmp/xmluxc-groupScript)"

#read -p "testing 308 avvio script xmluxc" EnterNull
$leggoGroupScript

done



############################

#cat /tmp/xmluxc-startSplit/$a | tr a-z A-Z > /tmp/xmluxc-startFunMaiuscolo

#leggoFunMaiuscolo="$(cat /tmp/xmluxc-startFunMaiuscolo)"
 
#find /usr/local/lib/xmlux/vimFunctions/groups -name $leggoFunMaiuscolo.vim > /tmp/xmluxc-startVim

#leggoVimScript="$(cat /tmp/xmluxc-startVim)"

#cp $leggoVimScript /home/$USER/.vim/vimScript/xmlux

#vim -c ":%s/%/$leggoInizio,$leggoFine/g" /home/$USER/.vim/vimScript/xmlux/$leggoFunMaiuscolo.vim -c :w -c :q


#vim -c ":runtime! vimScript/xmlux/$leggoFunMaiuscolo.vim" -c ":cal $leggoFunMaiuscolo#$leggoFunMaiuscolo()" $targetFile.lmxp -c :w -c :q

#done

sed '/\\start{/d' $targetFile.lmxp > /tmp/xmluxc-startDel

sed '/\\finish{/d' /tmp/xmluxc-startDel > /tmp/xmluxc-finishDel

cp /tmp/xmluxc-finishDel $targetFile.lmxp

fi

#### finish groups

}

01.01-individuazioneGruppi



### Elaborazione gruppi di paragrafi. Questi li devo elaborare alla fine perché
## occorre coerenza, e questa si può ottenere solo quando tutti i comandi e i restanti gruppi sono
## stati completati.

cp $targetFile.lmxp $targetFile.xml


01.02-gruppiParagrafi () {
## Per evitare che file senza gruppi vengano analizzati

if [ -d /tmp/xmluxc-group ]; then

01.02.01-wrapLinesGq () {
### GRUPPO WRAPLINES GQ
find /tmp/xmluxc-StockWrapLinesGroups/ -type d -name "*wrapLines_gq" > /tmp/xmluxc-StockWrapLines

stat --format %s /tmp/xmluxc-StockWrapLines > /tmp/xmluxc-StockWrapLinesBytes

leggoWrapLinesGq=$(cat /tmp/xmluxc-StockWrapLinesBytes)

#read -p "testing xmluxc 937" EnterNull
if test $leggoWrapLinesGq -gt 0

then
/usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/gqSh/wrapLines-gq.sh
fi

}

01.02.01-wrapLinesGq

01.02.02-multicolumn () {
### GRUPPO WRAPLINES GQ
find /tmp/xmluxc-StockMulticolumn/ -type d -name "*multicolumn" > /tmp/xmluxc-StockMulticolumnResp

stat --format %s /tmp/xmluxc-StockMulticolumnResp > /tmp/xmluxc-StockMulticolumnBytes

leggoWrapLinesGq=$(cat /tmp/xmluxc-StockMulticolumnBytes)

#read -p "testing xmluxc 937" EnterNull
if test $leggoWrapLinesGq -gt 0

then

	/usr/local/lib/xmlux/xmluxcGroups/paragraph/multicolumns/multicolumnNow.sh

fi

}

01.02.02-multicolumn


#read -p "testing xmluxc 947" EnterNull

fi

}

01.02-gruppiParagrafi

#read -p "testing xmluxc 953" EnterNull

}

01-gruppi


02-comandiCaratteri () {

### Comandi
rm -f /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

rm -f /tmp/xmluxc-cValues

touch /tmp/xmluxc-cValues

echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

### RIPRISTINO PASSATA VERSIONE
### generic chars
grep -oh "\w*\\\clux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-01 | sort > /tmp/xmluxc-01sorted

cat /tmp/xmluxc-01sorted | uniq > /tmp/xmluxc-01uniq

cat /tmp/xmluxc-01uniq | sed 's/.*\\//g' > /tmp/xmluxc-01sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-01sed -c :w -c :q

rm -fr /tmp/xmluxc-02

mkdir /tmp/xmluxc-02

split -l1 /tmp/xmluxc-01sed /tmp/xmluxc-02/

for a in $(ls /tmp/xmluxc-02)

do
	leggoA=$(cat /tmp/xmluxc-02/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/genericChar/char.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

done

fi

### special chars

rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cslux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-01 | sort > /tmp/xmluxc-01sorted

cat /tmp/xmluxc-01sorted | uniq > /tmp/xmluxc-01uniq

cat /tmp/xmluxc-01uniq | sed 's/.*\\//g' > /tmp/xmluxc-01sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-01sed -c :w -c :q

rm -fr /tmp/xmluxc-02

mkdir /tmp/xmluxc-02

split -l1 /tmp/xmluxc-01sed /tmp/xmluxc-02/

for a in $(ls /tmp/xmluxc-02)

do
	leggoA=$(cat /tmp/xmluxc-02/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/specialChar/charS.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

done

fi

### paragraph chars
rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cplux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-01 | sort > /tmp/xmluxc-01sorted

cat /tmp/xmluxc-01sorted | uniq > /tmp/xmluxc-01uniq

cat /tmp/xmluxc-01uniq | sed 's/.*\\//g' > /tmp/xmluxc-01sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-01sed -c :w -c :q

rm -fr /tmp/xmluxc-02

mkdir /tmp/xmluxc-02

split -l1 /tmp/xmluxc-01sed /tmp/xmluxc-02/

for a in $(ls /tmp/xmluxc-02)

do
	leggoA=$(cat /tmp/xmluxc-02/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/paragraphChar/charP.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

done

fi

### math chars
rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cmlux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-01 | sort > /tmp/xmluxc-01sorted

cat /tmp/xmluxc-01sorted | uniq > /tmp/xmluxc-01uniq

cat /tmp/xmluxc-01uniq | sed 's/.*\\//g' > /tmp/xmluxc-01sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-01sed -c :w -c :q

rm -fr /tmp/xmluxc-02

mkdir /tmp/xmluxc-02

split -l1 /tmp/xmluxc-01sed /tmp/xmluxc-02/

for a in $(ls /tmp/xmluxc-02)

do
	leggoA=$(cat /tmp/xmluxc-02/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/mathChar/charM.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

done

fi

### physical chars

rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cflux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-01 | sort > /tmp/xmluxc-01sorted

cat /tmp/xmluxc-01sorted | uniq > /tmp/xmluxc-01uniq

cat /tmp/xmluxc-01uniq | sed 's/.*\\//g' > /tmp/xmluxc-01sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-01sed -c :w -c :q

## eventuali {} attaccati li ho eliminati con sed direttamente prima
# vim -c ":%s/{}//g" /tmp/xmluxc-01uniq -c :w -c :q

rm -fr /tmp/xmluxc-02

mkdir /tmp/xmluxc-02

split -l1 /tmp/xmluxc-01sed /tmp/xmluxc-02/

for a in $(ls /tmp/xmluxc-02)

do
	leggoA=$(cat /tmp/xmluxc-02/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/physicalChar/charF.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

done

fi

### chemical chars

rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cclux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-01 | sort > /tmp/xmluxc-01sorted

cat /tmp/xmluxc-01sorted | uniq > /tmp/xmluxc-01uniq

cat /tmp/xmluxc-01uniq | sed 's/.*\\//g' > /tmp/xmluxc-01sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-01sed -c :w -c :q

rm -fr /tmp/xmluxc-02

mkdir /tmp/xmluxc-02

split -l1 /tmp/xmluxc-01sed /tmp/xmluxc-02/

for a in $(ls /tmp/xmluxc-02)

do
	leggoA=$(cat /tmp/xmluxc-02/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/chemicalChar/charC.txt | awk '$1 > 0 {print $3}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":silent! %s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

done

fi

cat /tmp/xmluxc-cValues | sort > /tmp/xmluxc-cValuesSort

cat /tmp/xmluxc-cValuesSort | uniq > /tmp/xmluxc-cValuesUniq

cat /tmp/xmluxc-cValuesUniq >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

## uso il silent perché alcuni comandi potrebbero essere stati già 
## sostituiti con le funzioni dei gruppi di paragrafi.
vim -c ": runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" $targetFile.xml -c :w -c :q

}

02-comandiCaratteri


03-comandiPattern () {
#### Pattern

rm -f /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

rm -f /tmp/xmluxc-pValues

touch /tmp/xmluxc-pValues

echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

# paragraph pattern
grep -oh "\w*\\\pplux\w*" $targetFile.xml | sed 's/{}//g' > /tmp/xmluxc-04

# decorative pattern
grep -oh "\w*\\\pdlux\w*" $targetFile.xml | sed 's/{}//g' >> /tmp/xmluxc-04

stat --format %s /tmp/xmluxc-04 > /tmp/xmluxc-04Bytes

leggoBytes=$(cat /tmp/xmluxc-04Bytes)

if test $leggoBytes -gt 0

then

cat /tmp/xmluxc-04 | sort > /tmp/xmluxc-04sorted

cat /tmp/xmluxc-04sorted | uniq > /tmp/xmluxc-04uniq

cat /tmp/xmluxc-04uniq | sed 's/.*\\//g' > /tmp/xmluxc-04sed

vim -c "%s/^/\\\/g" /tmp/xmluxc-04sed -c :w -c :q

## eventuali {} attaccati li ho eliminati con sed direttamente prima
#vim -c ":%s/{}//g" /tmp/xmluxc-01uniq -c :w -c :q

rm -fr /tmp/xmluxc-05

mkdir /tmp/xmluxc-05

split -l1 /tmp/xmluxc-04sed /tmp/xmluxc-05/

for b in $(ls /tmp/xmluxc-05)

do
	cat /tmp/xmluxc-05/$b | sed 's/\\//g' > /tmp/xmluxc-06

	leggoBSedded="$(cat /tmp/xmluxc-06)"

	find /usr/local/lib/xmlux/pattern/paragraphCommands -name "$leggoBSedded" > /tmp/xmluxc-pfound
	
	leggoPatternFile="$(cat /tmp/xmluxc-pfound)"

	leggoValue="$(cat $leggoPatternFile)"

	echo ":silent! %s/\\\\$leggoBSedded/$leggoValue/g" >> /tmp/xmluxc-pValues

done

cat /tmp/xmluxc-pValues | sort > /tmp/xmluxc-pValuesSort

cat /tmp/xmluxc-pValuesSort | uniq > /tmp/xmluxc-pValuesUniq
 
cat /tmp/xmluxc-pValuesUniq >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

vim -c ":runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" $targetFile.xml -c :w -c :q

fi


### Elimino spazi indicati da {}

}

03-comandiPattern


vim -c ":%s/{}//g" $targetFile.xml -c :w -c :q &> /dev/null



04-costruzioneCss () {
####### Costruzione del file *.css, e del file *.dtd

grep -R  "^--margin=true" /tmp/xmluxcPseudoOptions > /tmp/xmluxcMarginTrue

stat --format %s /tmp/xmluxcMarginTrue > /tmp/xmluxcMarginTrueBytes

leggoBytesMarginTrue=$(cat /tmp/xmluxcMarginTrueBytes)

rm -f $targetFile.css

touch $targetFile.css

rm -f $targetFile.dtd

touch $targetFile.dtd

### Il file *.dtd non + un file xml
## echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $targetFile.dtd

## Tutti gli id che iniziano con <a>, ossia il capitolo a.
# è troppo vincolante utilizzare la chiave <a>.
#grep -o "ID=\"a*.*" $targetFile.lmx > /tmp/xmluxc-css01

# In questo modo puoi scrivere ID anche nel preambolo, perché quest'ultimo escluso.
cat $targetFile.lmx | sed -n '/<!-- begin radix/,$p' > /tmp/xmluxc-css0000

## mi serve la coerenza di numero di righe tra il file lmx in cui effettuerò le iniezioni
## e il file selezionato in cui ho escluso il preambolo.
grep -n "<!-- begin radix" $targetFile.lmx | cut -d: -f1 > /tmp/xmluxc-nLineaBeginRadix

leggoNBeginRadix=$(cat /tmp/xmluxc-nLineaBeginRadix)

righeEsatte=$(($leggoNBeginRadix - 1))

touch /tmp/xmluxc-IpezzoCoerenzaBeginRadixLmx

declare -i var=0

while ((k++ <$righeEsatte))
  do
  var=$var+1
  echo "riga per coerenza con il file lmx n. $var" >> /tmp/xmluxc-IpezzoCoerenzaBeginRadixLmx
done 

cat /tmp/xmluxc-IpezzoCoerenzaBeginRadixLmx /tmp/xmluxc-css0000 > /tmp/xmluxc-css000

## Il I ID è sempre quello del root, io non specifico nulla nel preambolo xml. 
grep "ID=*" /tmp/xmluxc-css000 | head -n 1 > /tmp/xmluxc-css00

## leggo il valore di root
cat /tmp/xmluxc-css00 | cut -d= -f2,2 | sed 's/"//g' | sed 's/>/ /' | awk '$1 > 0 {print $1}' > /tmp/xmluxc-idRoot

leggoIdRoot="$(cat /tmp/xmluxc-idRoot)"

## ora posso selezionare tutti gli ID appartenenti al root
grep "ID=\"$leggoIdRoot" /tmp/xmluxc-css000 | awk '$1 > 0 {print $2}' > /tmp/xmluxc-css01

cat /tmp/xmluxc-css01 | sort > /tmp/xmluxc-css02

cat /tmp/xmluxc-css02 | uniq > /tmp/xmluxc-css03

### Individuazione document class
for c in {1}

do

grep "^<\!-- matter book document class -->" $targetFile.lmx > /tmp/xmlux-matterBookDocumentClassGrep


stat --format %s /tmp/xmlux-matterBookDocumentClassGrep > /tmp/xmlux-matterBookDocumentClassGrepBytes

leggoMatterBookDocumentClassGrepBytes=$(cat /tmp/xmlux-matterBookDocumentClassGrepBytes)


if test $leggoMatterBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/matter/matter-book/xmluxcMatter-book.sh

break

fi

grep "^<\!-- matter article document class -->" $targetFile.lmx > /tmp/xmlux-matterArticleDocumentClassGrep

stat --format %s /tmp/xmlux-matterArticleDocumentClassGrep > /tmp/xmlux-matterArticleDocumentClassGrepBytes

leggoMatterArticleDocumentClassGrepBytes=$(cat /tmp/xmlux-matterArticleDocumentClassGrepBytes)


if test $leggoMatterArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/matter/matter-article/xmluxcMatter-article.sh

break

fi

grep "^<\!-- brief book document class -->" $targetFile.lmx > /tmp/xmlux-briefBookDocumentClassGrep

stat --format %s /tmp/xmlux-briefBookDocumentClassGrep > /tmp/xmlux-briefBookDocumentClassGrepBytes

leggoBriefBookDocumentClassGrepBytes=$(cat /tmp/xmlux-briefBookDocumentClassGrepBytes)


if test $leggoBriefBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/brief/brief-book/xmluxcBrief-book.sh

break

fi

grep "^<\!-- brief article document class -->" $targetFile.lmx > /tmp/xmlux-briefArticleDocumentClassGrep

stat --format %s /tmp/xmlux-briefArticleDocumentClassGrep > /tmp/xmlux-briefArticleDocumentClassGrepBytes

leggoBriefArticleDocumentClassGrepBytes=$(cat /tmp/xmlux-briefArticleDocumentClassGrepBytes)


if test $leggoBriefArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/brief/brief-article/xmluxcBrief-article.sh

break

fi

grep "^<\!-- septem gradus data document class -->" $targetFile.lmx > /tmp/xmlux-sevenLevelsDataDocumentClassGrep

stat --format %s /tmp/xmlux-sevenLevelsDataDocumentClassGrep > /tmp/xmlux-sevenLevelsDataDocumentClassGrepBytes

leggoSevenLevelsDataDocumentClassGrepBytes=$(cat /tmp/xmlux-sevenLevelsDataDocumentClassGrepBytes)

if test $leggoSevenLevelsDataDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/data/data-seven/xmluxcData-seven.sh

break

fi

grep "^<\!-- category dataset 01 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset01DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset01DataDocumentClassGrep > /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes

categoryDataset01DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes)

if test $categoryDataset01DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/data/categoryDataset/xmluxcData-categoryDataset01.sh

break

fi


grep "^<\!-- category dataset 02 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset02DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset02DataDocumentClassGrep > /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes

categoryDataset02DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes)

if test $categoryDataset02DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/data/categoryDataset/xmluxcData-categoryDataset02.sh

break

fi

grep "^<\!-- pie dataset document class -->" $targetFile.lmx > /tmp/xmlux-pieDatasetDataDocumentClassGrep

stat --format %s /tmp/xmlux-pieDatasetDataDocumentClassGrep > /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes

pieDatasetDocumentClassGrepBytes=$(cat /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes)

if test $pieDatasetDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxcDocumentClass/data/pieDataset/xmluxcData-pieDataset.sh
break

fi




done

}

04-costruzioneCss


rm -fr /home/$USER/.vim/vimScript/xmlux/*

rm -fr /tmp/xmluxc*


exit

