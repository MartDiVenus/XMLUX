#!/bin/bash


rm -fr /tmp/xmluxc-wrapLines*

rm -fr /tmp/xmluxc-WrapLines*

targetFile="$(cat /tmp/xmluxcTargetFile)"


mkdir /tmp/xmluxc-wrapLinesSplit

split -l1 /tmp/xmluxc-StockWrapLines /tmp/xmluxc-wrapLinesSplit/

01.00-cf () {
for a in $(ls /tmp/xmluxc-wrapLinesSplit)

do

01.01-variabili () {
codiceIdentificativoPre=$(cat /tmp/xmluxc-wrapLinesSplit/$a)

echo $codiceIdentificativoPre | cut -d- -f2,2 | cut -d/ -f2,2 > /tmp/xmluxc-wrapLinesCodiceIdentificativo

codiceIdentificativo="$(cat /tmp/xmluxc-wrapLinesCodiceIdentificativo)"

pathFileOpzioni="$(cat /tmp/xmluxc-wrapLinesSplit/$a)"

#opzioniWrapGq="$(cat $pathFileOpzioni/opzioniWrapGq)"

#read -p "fpr do \$a = /tmp/xmluxc-wrapLinesSplit/$a" EnterNull

}

01.01-variabili

01.02-estrazioneContenuto () {

#grep -n "^stockInizioWrapLinesGq-$codiceIdentificativo" $targetFile.xml | cut -d: -f1 > /tmp/xmluxc-wrapLinesGroupsStartOrder

#grep -n "^stockFineWrapLinesGq-$codiceIdentificativo" $targetFile.xml | cut -d: -f1 > /tmp/xmluxc-wrapLinesGroupsFinishOrder

#leggoInizioPre=$(cat /tmp/xmluxc-GroupsStartOrder)

#leggoFinePre=$(cat /tmp/xmluxc-wrapLinesGroupsFinishOrder)

cp $targetFile.xml /tmp/xmluxc-WrapLinesTemp00

## Tutto ciò che c'è prima di  xmluxcInizioBloccoXmluxc
sed '/^stockInizioWrapLinesGq-'$codiceIdentificativo'/q' /tmp/xmluxc-WrapLinesTemp00 > /tmp/xmluxc-WrapLinesTemp01
## Tutto ciò che c'è prima di  xmluxcFineBloccoXmluxc
sed '/^stockFineWrapLinesGq-'$codiceIdentificativo'/q' /tmp/xmluxc-WrapLinesTemp00 > /tmp/xmluxc-WrapLinesTemp02

comm -3 /tmp/xmluxc-WrapLinesTemp01 /tmp/xmluxc-WrapLinesTemp02 | sed 's/^\(.\{1\}\)//' > /tmp/xmluxc-WrapLinesTemp03

## comm si porta via /tmp/xmluxc-WrapLinesTemp03
echo "stockInizioWrapLinesGq-$codiceIdentificativo" > /tmp/xmluxc-WrapLinesTemp04

cat /tmp/xmluxc-WrapLinesTemp04 /tmp/xmluxc-WrapLinesTemp03 > /tmp/xmluxc-WrapLinesTemp02

cp /tmp/xmluxc-WrapLinesTemp02 /tmp/xmluxc-WrapLinesTemp03

vim -c ":g/stockInizioWrapLinesGq-$codiceIdentificativo/,/stockFineWrapLinesGq-$codiceIdentificativo/j" /tmp/xmluxc-WrapLinesTemp03 -c :w -c :q

#read -p "testing 76 gq /tmp/xmluxc-WrapLinesTemp03" EnterNull

vim -c ":%s/stockInizioWrapLinesGq-$codiceIdentificativo//g" /tmp/xmluxc-WrapLinesTemp03 -c :w -c :q
vim -c ":%s/stockFineWrapLinesGq-$codiceIdentificativo//g" /tmp/xmluxc-WrapLinesTemp03 -c :w -c :q


## elimino tutti gli spazi (dopo \finish) della riga
vim -c ":silent! s/[ ]*$//g" /tmp/xmluxc-WrapLinesTemp03 -c :w -c :q

# elimino le linee vuote
sed -r '/^\s*$/d' /tmp/xmluxc-WrapLinesTemp03 > /tmp/xmluxc-WrapLinesTemp02

# elimino il I spazio bianco che si crea alla I riga
vim -c ":1s/^.//g" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

}

01.02-estrazioneContenuto

01.03-opzioni () {

cat $pathFileOpzioni/opzioniWrapGq |tr ',' '\n' | sed '/^$/d' | sed 's/.*\[//g' | sed 's/\]//g' > /tmp/xmluxc-WrapLinesOptionValue

grep "width" /tmp/xmluxc-WrapLinesOptionValue | cut -d= -f2,2 > /tmp/xmluxc-WrapLinesOptionWidth

WIDTH="$(cat /tmp/xmluxc-WrapLinesOptionWidth)"


grep "tab" /tmp/xmluxc-WrapLinesOptionValue | cut -d= -f2,2 > /tmp/xmluxc-WrapLinesOptionTABS

stat --format %s /tmp/xmluxc-WrapLinesOptionTABS > /tmp/xmluxc-WrapLinesOptionTABSBytes

leggoTABSBytes=$(cat /tmp/xmluxc-WrapLinesOptionTABSBytes)

if test $leggoTABSBytes -gt 0

then

	echo "esiste opzione Tab" > /tmp/xmluxc-WrapLinesOptionTABSCimice
leggoTabValue=$(cat /tmp/xmluxc-WrapLinesOptionTABS)

fi

grep "just" /tmp/xmluxc-WrapLinesOptionValue | cut -d= -f2,2 > /tmp/xmluxc-WrapLinesOptionJust

stat --format %s /tmp/xmluxc-WrapLinesOptionJust > /tmp/xmluxc-WrapLinesOptionJustBytes

leggoJustBytes=$(cat /tmp/xmluxc-WrapLinesOptionJustBytes)

if test $leggoJustBytes -gt 0

then

	echo "esiste opzione Justify" > /tmp/xmluxc-WrapLinesOptionJustCimice

leggoJustValue=$(cat /tmp/xmluxc-WrapLinesOptionJust)

fi

rm /tmp/xmluxc-WrapLinesOptionValue
}

01.03-opzioni


01.04-sostituzioneUTF8 () {
rm -f /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

rm -f /tmp/xmluxc-cValues

touch /tmp/xmluxc-cValues


rm -f /tmp/xmluxc-pValues

touch /tmp/xmluxc-pValues

echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

### Non posso spezzare con le sequenze dei comandi di xmlux o dei codici esadecimali,
## ma devo spezzare con i caratteri utf8 che compariranno con il browser. Ovviamente
## per i tab, e altri caratteri non riproducibili approssimo.
rm -f /tmp/xmluxc-cValues

rm -f /tmp/xmluxc-03-Stock-generic

rm -f /tmp/xmluxc-03-Stock-special

rm -f /tmp/xmluxc-03-Stock-paragraph

rm -f /tmp/xmluxc-03-Stock-math

rm -f /tmp/xmluxc-03-Stock-physical

rm -f /tmp/xmluxc-03-Stock-chemical


01.04.01-genericChars () {
### generic chars
grep -oh "\w*\\\clux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-01

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

	grep "$leggoA" /usr/local/lib/xmlux/char/genericChar/char.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

	grep "$leggoA" /usr/local/lib/xmlux/char/genericChar/char.txt | awk '$1 > 0 {print $3}' >> /tmp/xmluxc-03-Stock-generic

done

fi
}

01.04.01-genericChars


01.04.02-specialChars () {
### special chars
rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cslux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-01

stat --format %s /tmp/xmluxc-01 > /tmp/xmluxc-01Bytes

leggoBytes=$(cat /tmp/xmluxc-01Bytes)

#read -p "testing 190 gq special chars" EnterNull
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

	grep "$leggoA" /usr/local/lib/xmlux/char/specialChar/charS.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

	grep "$leggoA" /usr/local/lib/xmlux/char/specialChar/charS.txt | awk '$1 > 0 {print $3}' >> /tmp/xmluxc-03-Stock-special

done

#read -p "testing 223 gq special chars" EnterNull

fi

}

01.04.02-specialChars


01.04.03-paragraphChars () {
### paragraph chars
rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cplux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-01

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

	grep "$leggoA" /usr/local/lib/xmlux/char/paragraphChar/charP.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

	grep "$leggoA" /usr/local/lib/xmlux/char/paragraphChar/charP.txt | awk '$1 > 0 {print $3}' >> /tmp/xmluxc-03-Stock-paragraph

done

fi

}

01.04.03-paragraphChars

01.04.04-mathChars () {
### math chars
rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cmlux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-01

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

	grep "$leggoA" /usr/local/lib/xmlux/char/mathChar/charM.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

	grep "$leggoA" /usr/local/lib/xmlux/char/math/charM.txt | awk '$1 > 0 {print $3}' >> /tmp/xmluxc-03-Stock-math

done

fi
}

01.04.04-mathChars

01.04.05-physicalChars () {
### physical chars

rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cflux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-01

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

	grep "$leggoA" /usr/local/lib/xmlux/char/physicalChar/charF.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":%s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

	grep "$leggoA" /usr/local/lib/xmlux/char/physical/charF.txt | awk '$1 > 0 {print $3}' >> /tmp/xmluxc-03-Stock-physical

done

fi

}

01.04.05-physicalChars


01.04.06-chemicalChars () {
### chemical chars
rm -f /tmp/xmluxc-01

grep -oh "\w*\\\cclux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-01

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

	grep "$leggoA" /usr/local/lib/xmlux/char/chemicalChar/charC.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-03

	leggoValue="$(cat /tmp/xmluxc-03)"

	echo ":silent! %s/\\$leggoA/\\$leggoValue/g" >> /tmp/xmluxc-cValues

	grep "$leggoA" /usr/local/lib/xmlux/char/chemical/charC.txt | awk '$1 > 0 {print $3}' >> /tmp/xmluxc-03-Stock-chemical

done

fi

}

01.04.06-chemicalChars

01.04.07-sostituzione () {
if [ -f /tmp/xmluxc-cValues ]; then 

cat /tmp/xmluxc-cValues | sort > /tmp/xmluxc-cValuesSort

cat /tmp/xmluxc-cValuesSort | uniq > /tmp/xmluxc-cValuesUniq

cat /tmp/xmluxc-cValuesUniq >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

vim -c ":runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

#read -p "testing 842 gq controlla simboli utf8 in /tmp/xmluxc-WrapLinesTemp02" EnterNull

fi
}

01.04.07-sostituzione

### Ho trovato la soluzione, ora non ho tempo di implementarla: vedi
## il file istruzioni di sviluppo nella directory.
##01.04.08-pattern () {
###### Pattern
#### Da testare
##
##rm -f /tmp/xmluxc-pStock
##
##rm -f /tmp/xmluxc-pValues
##
##rm -f /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##rm -f /tmp/xmluxc-pValues
##
##touch /tmp/xmluxc-pValues
##
##echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
### paragraph pattern
##grep -oh "\w*\\\pplux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-04Paragraph
##
### decorative pattern
##grep -oh "\w*\\\pdlux\w*" /tmp/xmluxc-WrapLinesTemp02 | sed 's/{}//g' > /tmp/xmluxc-04Decorative
##
##stat --format %s /tmp/xmluxc-04Paragraph > /tmp/xmluxc-04BytesParagraph
##
##leggoBytes=$(cat /tmp/xmluxc-04BytesParagraph)
##
##if test $leggoBytes -gt 0
##
##then
##
##cat /tmp/xmluxc-04Paragraph | sort > /tmp/xmluxc-04sorted
##
##cat /tmp/xmluxc-04sorted | uniq > /tmp/xmluxc-04uniq
##
##cat /tmp/xmluxc-04uniq | sed 's/.*\\//g' > /tmp/xmluxc-04sed
##
##vim -c "%s/^/\\\/g" /tmp/xmluxc-04sed -c :w -c :q
##
#### eventuali {} attaccati li ho eliminati con sed direttamente prima
###vim -c ":%s/{}//g" /tmp/xmluxc-01uniq -c :w -c :q
##
##rm -fr /tmp/xmluxc-05
##
##mkdir /tmp/xmluxc-05
##
##split -l1 /tmp/xmluxc-04sed /tmp/xmluxc-05/
##
##for b in $(ls /tmp/xmluxc-05)
##
##do
##	cat /tmp/xmluxc-05/$b | sed 's/\\//g' > /tmp/xmluxc-06
##
##	leggoBSedded="$(cat /tmp/xmluxc-06)"
##
##### Di regola i pattern di paragrafo non possono andare in un gruppo wrap, ma visto che ho già
#### preparato il codice, offro anche tale possibilità.
##	find /usr/local/lib/xmlux/pattern/paragraphReverse -name "$leggoBSedded" > /tmp/xmluxc-pfound
##	
##	leggoPatternFile="$(cat /tmp/xmluxc-pfound)"
##
##	leggoValue="$(cat $leggoPatternFile)"
##
##	echo ":silent! %s/\\\\$leggoBSedded/$leggoValue/g" >> /tmp/xmluxc-pValues
##
##	echo "$leggoValue" >> /tmp/xmluxc-pStock
##
##done
##
##fi
##
##stat --format %s /tmp/xmluxc-04Decorative > /tmp/xmluxc-04BytesDecorative
##
##leggoBytes=$(cat /tmp/xmluxc-04BytesDecorative)
##
##if test $leggoBytes -gt 0
##
##then
##
##cat /tmp/xmluxc-04decorative | sort > /tmp/xmluxc-04sorted
##
##cat /tmp/xmluxc-04sorted | uniq > /tmp/xmluxc-04uniq
##
##cat /tmp/xmluxc-04uniq | sed 's/.*\\//g' > /tmp/xmluxc-04sed
##
##vim -c "%s/^/\\\/g" /tmp/xmluxc-04sed -c :w -c :q
##
#### eventuali {} attaccati li ho eliminati con sed direttamente prima
###vim -c ":%s/{}//g" /tmp/xmluxc-01uniq -c :w -c :q
##
##rm -fr /tmp/xmluxc-05
##
##mkdir /tmp/xmluxc-05
##
##split -l1 /tmp/xmluxc-04sed /tmp/xmluxc-05/
##
##for b in $(ls /tmp/xmluxc-05)
##
##do
##	cat /tmp/xmluxc-05/$b | sed 's/\\//g' > /tmp/xmluxc-06
##
##	leggoBSedded="$(cat /tmp/xmluxc-06)"
##
##### Di regola i pattern di paragrafo non possono andare in un gruppo wrap, ma visto che ho già
#### preparato il codice, offro anche tale possibilità.
##	find /usr/local/lib/xmlux/pattern/decorativeReverse -name "$leggoBSedded" > /tmp/xmluxc-pfound
##	
##	leggoPatternFile="$(cat /tmp/xmluxc-pfound)"
##
##	leggoValue="$(cat $leggoPatternFile)"
##
##	echo ":silent! %s/\\\\$leggoBSedded/$leggoValue/g" >> /tmp/xmluxc-pValues
##
##	echo "$leggoValue" >> /tmp/xmluxc-pStock
##
##done
##
##fi
##
##if [ -f /tmp/xmluxc-pValues ]; then
##
##cat /tmp/xmluxc-pValues | sort > /tmp/xmluxc-pValuesSort
##
##cat /tmp/xmluxc-pValuesSort | uniq > /tmp/xmluxc-pValuesUniq
## 
##cat /tmp/xmluxc-pValuesUniq >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##vim -c ":runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q
##
##fi
##
##}
##
##01.04.08-pattern

}

01.04-sostituzioneUTF8

### spezzo

01.05-spezzo () {

## Occorre pulire dai {} prima di spezzare, per rispettare la reale width desiderata
vim -c ":silent! %s/{}//g" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/gq/WRAPLINES.vim.back /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/gq/WRAPLINES.vim

vim -c ":%s/varWidth/$WIDTH/g" /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/gq/WRAPLINES.vim -c :w -c :q

rm -f /home/$USER/.vim/vimScript/xmlux/*

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/gq/WRAPLINES.vim /home/$USER/.vim/vimScript/xmlux

vim -c ":runtime! vimScript/xmlux/WRAPLINES.vim" -c ":cal WRAPLINES#WRAPLINES()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

}

01.05-spezzo

01.06-justify () {

if [ -f /tmp/xmluxc-WrapLinesOptionJustCimice ]; then

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/just/WRAPLINES.vim.back /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/just/WRAPLINES.vim

vim -c ":%s/varWidth/$WIDTH/g" /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/just/WRAPLINES.vim -c :w -c :q

rm -f /home/$USER/.vim/vimScript/xmlux/*

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/just/WRAPLINES.vim /home/$USER/.vim/vimScript/xmlux

vim -c ":runtime! vimScript/xmlux/WRAPLINES.vim" -c ":cal WRAPLINES#WRAPLINES()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

rm -f /home/$USER/.vim/vimScript/xmlux/*

rm -f /tmp/xmluxc-WrapLinesOptionJustCimice

fi

}

01.06-justify


01.07-sostituzioniCommands () {

rm -f /tmp/xmluxc-rcValues

touch /tmp/xmluxc-rcValues


01.07.01-genericChars () {

### Prima ho trasformato dai comandi di xmluxc a simboli utf8,
### ora trasformando da utf8 in esadeciamale, non ho bisogno di considerare 
##à i delimitatori per gli spazi {} perché essi si conservano automaticamente
### e verranno eliminati alla fine.


### generic chars


if [ -f /tmp/xmluxc-03-Stock-generic ]; then

cat /tmp/xmluxc-03-Stock-generic | sort > /tmp/xmluxc-03-Stock-generic01

cat /tmp/xmluxc-03-Stock-generic01 | uniq > /tmp/xmluxc-03-Stock-generic

mkdir /tmp/xmluxc-reverse

split -l1 /tmp/xmluxc-03-Stock-generic /tmp/xmluxc-reverse/

for a in $(ls /tmp/xmluxc-reverse)

do
	leggoA=$(cat /tmp/xmluxc-reverse/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/genericChar/char.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-rev

	leggoValue="$(cat /tmp/xmluxc-rev)"

	echo ":%s/$leggoValue/\\$leggoA/g" >> /tmp/xmluxc-rcValues

done

rm -r /tmp/xmluxc-reverse

fi

}

01.07.01-genericChars


01.07.02-specialChars () {
### special chars
if [ -f /tmp/xmluxc-03-Stock-special ]; then

#read -p "testing 668 special char reverse" EnterNull

cat /tmp/xmluxc-03-Stock-special | sort > /tmp/xmluxc-03-Stock-special01

cat /tmp/xmluxc-03-Stock-special01 | uniq > /tmp/xmluxc-03-Stock-special


mkdir /tmp/xmluxc-reverse

split -l1 /tmp/xmluxc-03-Stock-special /tmp/xmluxc-reverse/

for a in $(ls /tmp/xmluxc-reverse)

do
	leggoA=$(cat /tmp/xmluxc-reverse/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/specialChar/charS.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-rev

	leggoValue="$(cat /tmp/xmluxc-rev)"

	echo ":%s/$leggoValue/\\$leggoA/g" >> /tmp/xmluxc-rcValues

done

rm -r /tmp/xmluxc-reverse

#read -p "testing 694 special char reverse" EnterNull

fi

}

01.07.02-specialChars


01.07.03-paragraphChars () {
### paragraph chars

if [ -f /tmp/xmluxc-03-Stock-paragraph ]; then

cat /tmp/xmluxc-03-Stock-paragraph | sort > /tmp/xmluxc-03-Stock-paragraph01

cat /tmp/xmluxc-03-Stock-paragraph01 | uniq > /tmp/xmluxc-03-Stock-paragraph


mkdir /tmp/xmluxc-reverse

split -l1 /tmp/xmluxc-03-Stock-paragraph /tmp/xmluxc-reverse/

for a in $(ls /tmp/xmluxc-reverse)

do
	leggoA=$(cat /tmp/xmluxc-reverse/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/paragraphChar/charP.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-rev

	leggoValue="$(cat /tmp/xmluxc-rev)"

	echo ":%s/$leggoValue/\\$leggoA/g" >> /tmp/xmluxc-rcValues

done

rm -r /tmp/xmluxc-reverse

fi

}

01.07.03-paragraphChars

01.07.04-mathChars () {
### math chars
if [ -f /tmp/xmluxc-03-Stock-math ]; then

cat /tmp/xmluxc-03-Stock-math | sort > /tmp/xmluxc-03-Stock-math01

cat /tmp/xmluxc-03-Stock-math01 | uniq > /tmp/xmluxc-03-Stock-math

mkdir /tmp/xmluxc-reverse

split -l1 /tmp/xmluxc-03-Stock-math /tmp/xmluxc-reverse/

for a in $(ls /tmp/xmluxc-reverse)

do
	leggoA=$(cat /tmp/xmluxc-reverse/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/mathChar/charM.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-rev

	leggoValue="$(cat /tmp/xmluxc-rev)"

	echo ":%s/$leggoValue/\\$leggoA/g" >> /tmp/xmluxc-rcValues

done

rm -r /tmp/xmluxc-reverse

fi

}

01.07.04-mathChars

01.07.05-physicalChars () {
### physical chars
if [ -f /tmp/xmluxc-03-Stock-physical ]; then

cat /tmp/xmluxc-03-Stock-physical | sort > /tmp/xmluxc-03-Stock-physical01

cat /tmp/xmluxc-03-Stock-physical01 | uniq > /tmp/xmluxc-03-Stock-physical


mkdir /tmp/xmluxc-reverse

split -l1 /tmp/xmluxc-03-Stock-physical /tmp/xmluxc-reverse/

for a in $(ls /tmp/xmluxc-reverse)

do
	leggoA=$(cat /tmp/xmluxc-reverse/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/phisicalChar/charF.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-rev

	leggoValue="$(cat /tmp/xmluxc-rev)"

	echo ":%s/$leggoValue/\\$leggoA/g" >> /tmp/xmluxc-rcValues

done

rm -r /tmp/xmluxc-reverse

fi

}

01.07.05-physicalChars


01.07.06-chemicalChars () {

if [ -f /tmp/xmluxc-03-Stock-chemical ]; then

cat /tmp/xmluxc-03-Stock-chemical | sort > /tmp/xmluxc-03-Stock-chemical01

cat /tmp/xmluxc-03-Stock-chemical01 | uniq > /tmp/xmluxc-03-Stock-chemical01

mkdir /tmp/xmluxc-reverse

split -l1 /tmp/xmluxc-03-Stock-chemical /tmp/xmluxc-reverse/

for a in $(ls /tmp/xmluxc-reverse)

do
	leggoA=$(cat /tmp/xmluxc-reverse/$a)

	grep "$leggoA" /usr/local/lib/xmlux/char/chemicalChar/charC.txt | awk '$1 > 0 {print $2}' > /tmp/xmluxc-rev

	leggoValue="$(cat /tmp/xmluxc-rev)"

	echo ":%s/$leggoValue/\\$leggoA/g" >> /tmp/xmluxc-rcValues

done

rm -r /tmp/xmluxc-reverse

fi

}

01.07.06-chemicalChars

01.07.07-sostituzione () {

if [ -f /tmp/xmluxc-rcValues ]; then

cat /tmp/xmluxc-rcValues | sort > /tmp/xmluxc-rcValuesSort

cat /tmp/xmluxc-rcValuesSort | uniq > /tmp/xmluxc-rcValuesUniq

rm -f  /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

cat /tmp/xmluxc-rcValuesUniq >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim

vim -c ":runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

#read -p "testing 842 gq controlla codici esadecimali in /tmp/xmluxc-WrapLinesTemp02" EnterNull

fi

}

01.07.07-sostituzione

rm -f /tmp/xmluxc-rpValues

### Ho trovato la soluzione, ora non ho tempo di implementarla: vedi
## il file istruzioni di sviluppo nella directory.
##01.07.08-pattern () {
###### Pattern
##### Da testare
##
### paragraph pattern
##if [ -f /tmp/xmluxc-pfound ]; then
##
##cat /tmp/xmluxc-pStock | sort > /tmp/xmluxc-04sorted
##
##cat /tmp/xmluxc-04sorted | uniq > /tmp/xmluxc-04uniq
##
##rm -fr /tmp/xmluxc-05
##
##mkdir /tmp/xmluxc-05
##
##split -l1 /tmp/xmluxc-04uniq /tmp/xmluxc-05/
##
##for b in $(ls /tmp/xmluxc-05)
##
##do
##	cat /tmp/xmluxc-05/$b > /tmp/xmluxc-06
##
##	leggoB="$(cat /tmp/xmluxc-06)"
##
##	find /usr/local/lib/xmlux/pattern/ready -name "$leggoB" > /tmp/xmluxc-pfound
##	
##	leggoPatternFile="$(cat /tmp/xmluxc-pfound)"
##
##	leggoValue="$(cat $leggoPatternFile)"
##
##	echo ":silent! %s/$leggoB/\\\\$leggoValueSedded/g" >> /tmp/xmluxc-rpValues
##
##done
##
##cat /tmp/xmluxc-pValues | sort > /tmp/xmluxc-pValuesSort
##
##cat /tmp/xmluxc-pValuesSort | uniq > /tmp/xmluxc-pValuesUniq
##
##rm -f /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##touch /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##rm -f /tmp/xmluxc-pValues
##
##touch /tmp/xmluxc-pValues
##
##echo "fun! XMLUXTMP#XMLUXTMP()" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##cat /tmp/xmluxc-pValuesUniq >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##echo " " >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##echo "endfun" >> /home/$USER/.vim/vimScript/xmlux/XMLUXTMP.vim
##
##vim -c ":runtime! vimScript/xmlux/XMLUXTMP.vim" -c ":cal XMLUXTMP#XMLUXTMP()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q
##
##fi
##
##}
##
##01.07.08-pattern

}

01.07-sostituzioniCommands



01.08-tab () {
if [ -f /tmp/xmluxc-WrapLinesOptionTABSCimice ]; then

### Tab iniziale solo alla prima riga
cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/tab/tabInizioRigaIniziale/$leggoTabValue/WRAPLINES.vim.back /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/tab/tabInizioRigaIniziale/$leggoTabValue/WRAPLINES.vim 

cat /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/tab/tabInizioRigaIniziale/$leggoTabValue/WRAPLINES.vim | sed 's/xs/%s/g' > /tmp/xmluxc-WrapLinesWrapTab

cp /tmp/xmluxc-WrapLinesWrapTab /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/tab/tabInizioRigaIniziale/$leggoTabValue/WRAPLINES.vim

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/tab/tabInizioRigaIniziale/$leggoTabValue/WRAPLINES.vim /home/$USER/.vim/vimScript/xmlux

#read -p "148
#/usr/local/lib/xmlux/xmluxcGroups/paragraph/wrapLines/vimFun/tab/$leggoTabValue/WRAPLINES.vim" EnterNull

vim -c ":runtime! vimScript/xmlux/WRAPLINES.vim" -c ":cal WRAPLINES#WRAPLINES()" /tmp/xmluxc-WrapLinesTemp02 -c :w -c :q

cat /tmp/xmluxc-WrapLinesTemp02 | sed 's/\\cpluxtab{}/\&#x9;/g' > /tmp/xmluxc-WrapLinesTemp03

rm -f /tmp/xmluxc-WrapLinesOptionTABSCimice

fi


}

01.08-tab

01.09-iniezione () {
## iniezione

## Tutto ciò che c'è prima di stockInizioWrapLinesGq-'$codiceIdentificativo'
sed '/^stockInizioWrapLinesGq-'$codiceIdentificativo'/q' /tmp/xmluxc-WrapLinesTemp00 > /tmp/xmluxc-WrapLinesTemp04

## Tutto ciò che c'è dopo di stockFineWrapLinesGq-'$codiceIdentificativo
cat /tmp/xmluxc-WrapLinesTemp00 | grep -A 1000000000000000000 "stockFineWrapLinesGq-$codiceIdentificativo" > /tmp/xmluxc-WrapLinesTemp05

cat /tmp/xmluxc-WrapLinesTemp04 /tmp/xmluxc-WrapLinesTemp03 > /tmp/xmluxc-WrapLinesTemp06

cat /tmp/xmluxc-WrapLinesTemp06 /tmp/xmluxc-WrapLinesTemp05 > /tmp/xmluxc-WrapLinesTemp07

#read -p "testing 184" EnterNull

## Ho già pulito:
sed '/stockInizioWrapLinesGq-'$codiceIdentificativo'/d' /tmp/xmluxc-WrapLinesTemp07 > /tmp/xmluxc-WrapLinesTemp08

sed '/stockFineWrapLinesGq-'$codiceIdentificativo'/d' /tmp/xmluxc-WrapLinesTemp08 > /tmp/xmluxc-WrapLinesTemp09

cp /tmp/xmluxc-WrapLinesTemp09 $targetFile.xml

}

01.09-iniezione

#rm -r /tmp/xmluxc-wrapLinesSplit/$a

done

}

01.00-cf


rm -f /tmp/xmluxc-StockWrapLines

#### Il ciclo che chiudo prima dell'exit del testing di sviluppo, qua qui.
## done
#read -p "435 testing chiusura gq" EnterNull
###  Chiusura opzione gq
exit



