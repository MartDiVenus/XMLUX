#!/bin/bash

targetFile=$(cat /tmp/xmluxeTargetFile)

leggoIdRoot="$(cat /tmp/xmluxe-idRoot)"

	for render in {1}

	do

######### Render id block
grep "^--renderCss-id=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRenderedR

stat --format %s /tmp/xmluxe-actionRenderedR > /tmp/xmluxe-actionRenderedRBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderedRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionRenderedR | sed 's/.*=//g' > /tmp/xmluxe-idToRenderR

	idToRenderR="$(cat /tmp/xmluxe-idToRenderR)"


	## Invece di intervenire sul codice lmx, lavoro direttament sul xml.
#	grep -n "ID=\"$idToRenderR\"" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRenderRBeginLine

#nLineBeginIdToRenderR=$(cat /tmp/xmluxe-idToRenderRBeginLine)

#grep -n "<!-- end $idToRenderR -->" /tmp/xmluxe-css000 | cut -d: -f1,1 > /tmp/xmluxe-idToRenderREndLine

	
	grep -n "ID=\"$idToRenderR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderRBeginLine

nLineBeginIdToRenderR=$(cat /tmp/xmluxe-idToRenderRBeginLine)

grep -n "<!-- end $idToRenderR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderR=$(cat /tmp/xmluxe-idToRenderREndLine)

echo $nLineEndIdToRenderR - $nLineBeginIdToRenderR | bc > /tmp/xmluxe-linesToRender

linesToRenderR=$(cat /tmp/xmluxe-linesToRender)

linesToRenderRPlusComment=$(($linesToRenderR + 1))


## Rimuovo dalla I riga all'inizio del blocco da selezionare
echo $(($nLineBeginIdToRenderR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xmluxe-bloccoSelezionato

vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToRenderRPlus=$(($linesToRenderR + 1))

echo  "$linesToRenderRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xmluxe-intestazione

cat /tmp/xmluxe-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xmluxe-intestazione01

cp /tmp/xmluxe-intestazione01 /tmp/xmluxe-intestazione


/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xmluxe-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xmluxe-notKin_elements

vim -s /tmp/xmluxe-commandDelFirstEtLastLine /tmp/xmluxe-notKin_elements



cat /tmp/xmluxe-notKin_elements | sed '/^$/d' | uniq > /tmp/xmluxe-ToCTree

grep "$idToRenderR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-relativeElement

element=$(cat /tmp/xmluxe-relativeElement)
 

cat /tmp/xmluxe-ToCTree | grep -B 1000 "$element" > /tmp/xmluxe-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xmluxe-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure

rm -fr /tmp/xmluxe-ToCStructureSplit

mkdir  /tmp/xmluxe-ToCStructureSplit

split -l1 /tmp/xmluxe-ToCStructure /tmp/xmluxe-ToCStructureSplit/

declare -i var=0

for tocStructure in $(ls /tmp/xmluxe-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xmluxe-ToCStructureSplit/$tocStructure)

#	if test "$leggoToC" == "synopsis"

#	then
	
#	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione
#	echo "</$leggoToC>" >> /tmp/xmluxe-intestazione

#	else

	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione

	echo "$leggoToC" > /tmp/xmluxe-inverseOrderToC-$var

#	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xmluxe-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xmluxe-inverseOrderToC-$var /tmp/xmluxe-inverseOrder-$VarMenoUno > /tmp/xmluxe-inverseOrder-$var

		else
			cat /tmp/xmluxe-inverseOrderToC-$var > /tmp/xmluxe-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xmluxe-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xmluxe-inverseOrderToC-'n' per la synopsis.
done

rm -fr /tmp/xmluxe-inverseOrderToCSplit

mkdir /tmp/xmluxe-inverseOrderToCSplit

ls /tmp/xmluxe-inverseOrder-* | tail -n1 > /tmp/xmluxe-inverseOrder-finalLs

cat /tmp/xmluxe-inverseOrder-finalLs > /tmp/xmluxe-inverseOrder-final

inversedOrder=$(cat /tmp/xmluxe-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xmluxe-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xmluxe-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xmluxe-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xmluxe-bloccoSelezionato

done

cat /tmp/xmluxe-intestazione /tmp/xmluxe-bloccoSelezionato > /tmp/xmluxe-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xmluxe

mkdir /tmp/renderCss-xmluxe

cp -r . /tmp/renderCss-xmluxe/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xmluxe/*.back

rm /tmp/renderCss-xmluxe/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xmluxe/*.dtd

rm /tmp/renderCss-xmluxe/*.xml

rm /tmp/renderCss-xmluxe/*.lmx

rm -f /tmp/renderCss-xmluxe/*.lmxv

rm -fr /tmp/renderCss-xmluxe/*lmxv*

rm /tmp/renderCss-xmluxe/*.lmxp

rm -f /tmp/renderCss-xmluxe/*.lmxe

cp /tmp/xmluxe-bloccoSelezionatoIntestato /tmp/renderCss-xmluxe/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xmluxe/renderedCss.css



#cd /tmp/renderCss-xmluxe

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingChoice.java

scelta=$(cat /tmp/xmluxe-parsingChoice)

for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xmluxe/renderedCss.xml

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

break

fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xmluxe/renderedCss.xml

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

clear

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

break

fi

done

break

fi

######### Render name block
grep "^--renderCss-name=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRenderedR-name
stat --format %s /tmp/xmluxe-actionRenderedR-name > /tmp/xmluxe-actionRenderedR-nameBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderedR-nameBytes)

if test $leggoBytes -gt 0

then

	cat  /tmp/xmluxe-actionRenderedR-name | sed 's/.*=//g' > /tmp/xmluxe-idToRenderR-name
	nameToRender=$(cat /tmp/xmluxe-idToRenderR-name)

	/usr/local/bin/xmluxv -s --find-name="$nameToRender" --f=$targetFile

grep "\"$nameToRender\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToRenderR

idToRenderR="$(cat /tmp/xmluxe-idToRenderR)"

	grep -n "ID=\"$idToRenderR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderRBeginLine

nLineBeginIdToRenderR=$(cat /tmp/xmluxe-idToRenderRBeginLine)

grep -n "<!-- end $idToRenderR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderR=$(cat /tmp/xmluxe-idToRenderREndLine)

echo $nLineEndIdToRenderR - $nLineBeginIdToRenderR | bc > /tmp/xmluxe-linesToRender

linesToRenderR=$(cat /tmp/xmluxe-linesToRender)

linesToRenderRPlusComment=$(($linesToRenderR + 1))



## Rimuovo dalla I riga all'inizio del blocco da selezionare
echo $(($nLineBeginIdToRenderR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xmluxe-bloccoSelezionato

vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato


## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToRenderRPlus=$(($linesToRenderR + 1))

echo  "$linesToRenderRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xmluxe-intestazione

cat /tmp/xmluxe-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xmluxe-intestazione01

cp /tmp/xmluxe-intestazione01 /tmp/xmluxe-intestazione



/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xmluxe-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xmluxe-notKin_elements

vim -s /tmp/xmluxe-commandDelFirstEtLastLine /tmp/xmluxe-notKin_elements



cat /tmp/xmluxe-notKin_elements | sed '/^$/d' | uniq > /tmp/xmluxe-ToCTree

grep "$idToRenderR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-relativeElement

element=$(cat /tmp/xmluxe-relativeElement)
 

cat /tmp/xmluxe-ToCTree | grep -B 1000 "$element" > /tmp/xmluxe-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xmluxe-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure

rm -fr /tmp/xmluxe-ToCStructureSplit

mkdir  /tmp/xmluxe-ToCStructureSplit

split -l1 /tmp/xmluxe-ToCStructure /tmp/xmluxe-ToCStructureSplit/

declare -i var=0

for tocStructure in $(ls /tmp/xmluxe-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xmluxe-ToCStructureSplit/$tocStructure)

#	if test "$leggoToC" == "synopsis"

#	then
	
#	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione
#	echo "</$leggoToC>" >> /tmp/xmluxe-intestazione

#	else

	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione

	echo "$leggoToC" > /tmp/xmluxe-inverseOrderToC-$var

#	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xmluxe-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xmluxe-inverseOrderToC-$var /tmp/xmluxe-inverseOrder-$VarMenoUno > /tmp/xmluxe-inverseOrder-$var

		else
			cat /tmp/xmluxe-inverseOrderToC-$var > /tmp/xmluxe-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xmluxe-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xmluxe-inverseOrderToC-'n' per la synopsis.
done

rm -fr /tmp/xmluxe-inverseOrderToCSplit

mkdir /tmp/xmluxe-inverseOrderToCSplit

ls /tmp/xmluxe-inverseOrder-* | tail -n1 > /tmp/xmluxe-inverseOrder-finalLs

cat /tmp/xmluxe-inverseOrder-finalLs > /tmp/xmluxe-inverseOrder-final

inversedOrder=$(cat /tmp/xmluxe-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xmluxe-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xmluxe-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xmluxe-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xmluxe-bloccoSelezionato

done


cat /tmp/xmluxe-intestazione /tmp/xmluxe-bloccoSelezionato > /tmp/xmluxe-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xmluxe

mkdir /tmp/renderCss-xmluxe

cp -r . /tmp/renderCss-xmluxe/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xmluxe/*.back

rm /tmp/renderCss-xmluxe/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xmluxe/*.dtd

rm /tmp/renderCss-xmluxe/*.xml

rm /tmp/renderCss-xmluxe/*.lmx

rm -f /tmp/renderCss-xmluxe/*.lmxv

rm -fr /tmp/renderCss-xmluxe/*lmxv*

rm /tmp/renderCss-xmluxe/*.lmxp

rm -f /tmp/renderCss-xmluxe/*.lmxe

cp /tmp/xmluxe-bloccoSelezionatoIntestato /tmp/renderCss-xmluxe/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xmluxe/renderedCss.css


#cd /tmp/renderCss-xmluxe

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingChoice.java

scelta=$(cat /tmp/xmluxe-parsingChoice)

for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xmluxe/renderedCss.xml

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR alias name=$nameToRender rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

break

fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR alias name=$nameToRender rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

break

fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xmluxe/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)
	

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR alias name=$nameToRender rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

break

fi

done

break

fi

######### Render title block
grep "^--renderCss-title=" /tmp/xmluxePseudoOptions/* > /tmp/xmluxe-actionRenderedR-title

stat --format %s /tmp/xmluxe-actionRenderedR-title > /tmp/xmluxe-actionRenderedR-titleBytes

leggoBytes=$(cat /tmp/xmluxe-actionRenderedR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xmluxe-actionRenderedR-title | sed 's/.*=//g' > /tmp/xmluxe-idToRenderR-title
	titleToRender=$(cat /tmp/xmluxe-idToRenderR-title)

/usr/local/bin/xmluxv -s --find-title="$titleToRender" --f=$targetFile

grep "$titleToRender$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-idToRenderR

idToRenderR="$(cat /tmp/xmluxe-idToRenderR)"
	grep -n "ID=\"$idToRenderR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderRBeginLine

nLineBeginIdToRenderR=$(cat /tmp/xmluxe-idToRenderRBeginLine)

grep -n "<!-- end $idToRenderR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xmluxe-idToRenderREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderR=$(cat /tmp/xmluxe-idToRenderREndLine)

echo $nLineEndIdToRenderR - $nLineBeginIdToRenderR | bc > /tmp/xmluxe-linesToRender

linesToRenderR=$(cat /tmp/xmluxe-linesToRender)

linesToRenderRPlusComment=$(($linesToRenderR + 1))

echo $(($nLineBeginIdToRenderR - 2)) > /tmp/xmluxe-realFirstLine

realFirstLine=$(cat /tmp/xmluxe-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xmluxe-bloccoSelezionato

vim -s /tmp/xmluxe-command01-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

linesToRenderRPlus=$(($linesToRenderR + 1))

echo  "$linesToRenderRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xmluxe-command02-bloccoSelezionato


vim -s /tmp/xmluxe-command02-bloccoSelezionato /tmp/xmluxe-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xmluxe-intestazione

cat /tmp/xmluxe-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xmluxe-intestazione01

cp /tmp/xmluxe-intestazione01 /tmp/xmluxe-intestazione


/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xmluxe-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xmluxe-notKin_elements

vim -s /tmp/xmluxe-commandDelFirstEtLastLine /tmp/xmluxe-notKin_elements


cat /tmp/xmluxe-notKin_elements | sed '/^$/d' | uniq > /tmp/xmluxe-ToCTree

grep "$idToRenderR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xmluxe-relativeElement

element=$(cat /tmp/xmluxe-relativeElement)
 

cat /tmp/xmluxe-ToCTree | grep -B 1000 "$element" > /tmp/xmluxe-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xmluxe-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xmluxe-commandDelLastLine /tmp/xmluxe-ToCStructure

rm -fr /tmp/xmluxe-ToCStructureSplit

mkdir  /tmp/xmluxe-ToCStructureSplit

split -l1 /tmp/xmluxe-ToCStructure /tmp/xmluxe-ToCStructureSplit/

declare -i var=0
for tocStructure in $(ls /tmp/xmluxe-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xmluxe-ToCStructureSplit/$tocStructure)

#	if test "$leggoToC" == "synopsis"

#	then
	
#	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione
#	echo "</$leggoToC>" >> /tmp/xmluxe-intestazione

#	else

	echo "<$leggoToC>" >> /tmp/xmluxe-intestazione

	echo "$leggoToC" > /tmp/xmluxe-inverseOrderToC-$var

#	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xmluxe-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xmluxe-inverseOrderToC-$var /tmp/xmluxe-inverseOrder-$VarMenoUno > /tmp/xmluxe-inverseOrder-$var

		else
			cat /tmp/xmluxe-inverseOrderToC-$var > /tmp/xmluxe-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xmluxe-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xmluxe-inverseOrderToC-'n' per la synopsis.
done


rm -fr /tmp/xmluxe-inverseOrderToCSplit

mkdir /tmp/xmluxe-inverseOrderToCSplit

ls /tmp/xmluxe-inverseOrder-* | tail -n1 > /tmp/xmluxe-inverseOrder-finalLs

cat /tmp/xmluxe-inverseOrder-finalLs > /tmp/xmluxe-inverseOrder-final

inversedOrder=$(cat /tmp/xmluxe-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xmluxe-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xmluxe-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xmluxe-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xmluxe-bloccoSelezionato

done

cat /tmp/xmluxe-intestazione /tmp/xmluxe-bloccoSelezionato > /tmp/xmluxe-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xmluxe

mkdir /tmp/renderCss-xmluxe

cp -r . /tmp/renderCss-xmluxe/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xmluxe/*.back

rm /tmp/renderCss-xmluxe/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xmluxe/*.dtd

rm /tmp/renderCss-xmluxe/*.xml

rm /tmp/renderCss-xmluxe/*.lmx

rm -f /tmp/renderCss-xmluxe/*.lmxv

rm -fr /tmp/renderCss-xmluxe/*lmxv*

rm /tmp/renderCss-xmluxe/*.lmxp

rm -f /tmp/renderCss-xmluxe/*.lmxe

cp /tmp/xmluxe-bloccoSelezionatoIntestato /tmp/renderCss-xmluxe/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xmluxe/renderedCss.css


#cd /tmp/renderCss-xmluxe

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingChoice.java

scelta=$(cat /tmp/xmluxe-parsingChoice)


for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xmluxe/renderedCss.xml

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR alias title=$titleToRender rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR alias title=$titleToRender rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

break

fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xmluxe/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xmluxe/parsing/parsingPath.java

path=$(cat /tmp/xmluxe-parsingPath)

cp /tmp/renderCss-xmluxe/renderedCss.xml $path
cp /tmp/renderCss-xmluxe/renderedCss.css $path
sync

	echo "
$(date +"%Y-%m-%d-%H-%M")	ID=$idToRenderR alias title=$titleToRender rendered" >> $targetFile.lmxe
echo " " >> $targetFile.lmxe

fi

done

break

fi

done

exit

