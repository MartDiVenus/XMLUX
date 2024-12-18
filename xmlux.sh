#!/bin/bash


rm -fr /tmp/xmluxPseudoOptions

mkdir /tmp/xmluxPseudoOptions

rm -fr /tmp/xmluxPseudoOptionsSchemi

mkdir /tmp/xmluxPseudoOptionsSchemi

### <-c> sta per <comprimere>; 
### <-d> sta per <destinazione del file compresso o del contenuto estratto.
### <-u> sta per <estrazione>.

### Siccome l'opzione <-c> non può esistere insieme alla <-u>, avrò al massimo
## due opzioni allo stesso tempo: <<<-c> e <-d>>> o <<<-u> e <-d>>>.

## Possibile opzione (-c o -ct o -ctx o -cz o -cj) -u o -d
leggo1="$(echo $1 > /tmp/xmluxPseudoOptions/01)"

## Possibile opzione  (-c o -ct o -ctx o -cz o -cj) o -u o -d
leggo2="$(echo $2 > /tmp/xmluxPseudoOptions/02)"

## Possibile opzione  (-c o -ct o -ctx o -cz o -cj) o -u o -d
leggo3="$(echo $3 > /tmp/xmluxPseudoOptions/03)"

## Target: percorso e nome del file
leggo4="$(echo $4 >  /tmp/xmluxPseudoOptions/04)"

rileggoInput1="$(cat /tmp/xmluxPseudoOptions/01 2> /dev/null)"

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
Name: xmlux

Goal: To handle xml files.

Version: xmlux-3.0.0

available document classes
matter book			--matter-book

matter article			--matter-article

brief book			--brief-book

brief article			--brief-article

septem gradus data		--data-seven

category dataset 01		--category-dataset01

category dataset 02		--category-dataset02

pie dataset			--pie-dataset

folder and files to create	--f='name of the file without extension'

help                                                            -h

Usage
xmlux '--document-class' --f='path and name (without extension) of new file'

wildcard * as --f='' entire value or partial value, is accepted.

e.g.
xmlux --matter-book --f=/home/beatrix/test/bea
or
cd /home/beatrix/test
xmlux --matter-book --f=bea


It applies to new file <bea.lmx> the matter-book document class
with css2 style, so the default preamble:

<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<?xml-stylesheet type=\"text/css\" href=\"bea.css\"?>
<!DOCTYPE a SYSTEM \"bea.dtd\">
<!-- matter book document class -->



Copyright:
Copyright (C) 2023.09.23 Mario Fantini (ing.mariofantini@gmail.com).
Bash copyright applies to its Mario Fantini's BASH usage.
GNU copyright applies to its Mario Fantini's GNU tools usage.
XML copyright applies to its Mario Fantini's XML tools usage.
VIM copyright applies to its Mario Fantini's VIM usage.
Java copyright applies to its Mario Fantini's JAVA tools usage.
And so on.
"

rm -f /tmp/inputLux*

exit

fi


for a in $(ls /tmp/xmluxPseudoOptions)

do

	grep "^--f=" /tmp/xmluxPseudoOptions/$a > /tmp/xmluxTargetFileOp

	stat --format %s /tmp/xmluxTargetFileOp > /tmp/xmluxTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxTargetFileBytes)

	if test $leggoBytes -gt 1

	then

		cat /tmp/xmluxPseudoOptions/$a | sed 's/--f=//g' > /tmp/xmluxTargetFile

		pathNameFile="$(cat /tmp/xmluxTargetFile)"

		echo $pathNameFile > /tmp/xmlux-fullName

                /usr/local/lib/xmlux/trattamentoFiles.sh

                nomeFile="$(cat /tmp/xmlux-nomeFileIsolato)"

               
		## questa rimozione potrebbe servirmi per ulteriori sviluppi
		rm /tmp/xmluxPseudoOptions/$a

fi

done

for b in $(ls /tmp/xmluxPseudoOptions)

do

grep "^--matter-book" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxMatter-book

	stat --format %s /tmp/xmluxMatter-book > /tmp/xmluxMatter-bookBytes

	leggoBytes=$(cat /tmp/xmluxMatter-bookBytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/matter/matter-book/xmluxMatter-book.sh

break
	fi

grep "^--matter-article" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxMatter-article

	stat --format %s /tmp/xmluxMatter-article > /tmp/xmluxMatter-articleBytes

	leggoBytes=$(cat /tmp/xmluxMatter-articleBytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/matter/matter-article/xmluxMatter-article.sh

break
	fi

grep "^--brief-book" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxBrief-book

	stat --format %s /tmp/xmluxBrief-book > /tmp/xmluxBrief-bookBytes

	leggoBytes=$(cat /tmp/xmluxBrief-bookBytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/brief/brief-book/xmluxBrief-book.sh

break
	fi

grep "^--brief-article" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxBrief-article

	stat --format %s /tmp/xmluxBrief-article > /tmp/xmluxBrief-articleBytes

	leggoBytes=$(cat /tmp/xmluxBrief-articleBytes)

	if test $leggoBytes -gt 1

	then

/usr/local/lib/xmlux/xmluxDocumentClass/brief/brief-article/xmluxBrief-article.sh

break
	fi

grep "^--data-seven" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxData-seven

	stat --format %s /tmp/xmluxData-seven > /tmp/xmluxData-sevenBytes

	leggoBytes=$(cat /tmp/xmluxData-sevenBytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/data/data-seven/xmluxData-seven.sh

break
	fi


grep "^--category-dataset01" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxData-categoryDataset01

	stat --format %s /tmp/xmluxData-categoryDataset01 > /tmp/xmluxData-categoryDataset01Bytes

	leggoBytes=$(cat /tmp/xmluxData-categoryDataset01Bytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/data/categoryDataset/xmluxData-categoryDataset01.sh

break
	fi

grep "^--category-dataset02" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxData-categoryDataset02

	stat --format %s /tmp/xmluxData-categoryDataset02 > /tmp/xmluxData-categoryDataset02Bytes

	leggoBytes=$(cat /tmp/xmluxData-categoryDataset02Bytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/data/categoryDataset/xmluxData-categoryDataset02.sh

break
	fi

grep "^--pie-dataset" /tmp/xmluxPseudoOptions/$b > /tmp/xmluxData-pieDataset

	stat --format %s /tmp/xmluxData-pieDataset > /tmp/xmluxData-pieDatasetBytes

	leggoBytes=$(cat /tmp/xmluxData-pieDatasetBytes)

	if test $leggoBytes -gt 1

	then
/usr/local/lib/xmlux/xmluxDocumentClass/data/pieDataset/xmluxData-pieDataset.sh

break
	fi
done
rm -r /tmp/xmlux*

exit

################### Parte da sviluppare
### Dev section

for c in $(ls /tmp/xmluxPseudoOptions)

do
		
	option=$(cat /tmp/xmluxPseudoOptions/$c)

	echo $option > /tmp/xmluxPreambleOption

	#preamble="$(cat /tmp/xmluxPreambleOption)"

	grep "^-v" /tmp/xmluxPreambleOption > /tmp/xmlux-v

	stat --format %s /tmp/xmlux-v > /tmp/xmlux-vBytes

	leggoVBytes=$(cat /tmp/xmlux-vBytes)

	if test $leggoV1Bytes -gt 0
	
	then

	cat /tmp/xmluxPreambleOption | sed 's/-v//g' > /tmp/xmluxVersion

	version=$(cat /tmp/xmluxVersion)
	fi

######### azione --stand

	grep "^--stand" /tmp/xmluxPreambleOption > /tmp/xmlux-stand

	stat --format %s /tmp/xmlux-stand > /tmp/xmlux-standBytes

	leggoStandBytes=$(cat /tmp/xmlux-standBytes)

	if test $leggoStandBytes -gt 0
	
	then

	cat /tmp/xmluxPreambleOption | sed 's/--stand=//g' > /tmp/xmluxStand

	stand="$(cat tmp/xmluxStand)"
 
	fi

######### azione --encoding

	grep "^--encoding" /tmp/xmluxPreambleOption > /tmp/xmlux-encoding

	stat --format %s /tmp/xmlux-encoding > /tmp/xmlux-encodingBytes

	leggoEncodingBytes=$(cat /tmp/xmlux-encodingBytes)

	if test $leggoEncodingBytes -gt 0
	
	then

	cat /tmp/xmluxPreambleOption | sed 's/--encoding=//g' > /tmp/xmluxEncoding

	enc="$(cat tmp/xmluxEncoding)"
 
	fi


######### azione --style

	grep "^--style" /tmp/xmluxPreambleOption > /tmp/xmlux-style

	stat --format %s /tmp/xmlux-style > /tmp/xmlux-styleBytes

	leggoStyleBytes=$(cat /tmp/xmlux-styleBytes)

	if test $leggoStyleBytes -gt 0
	
	then

	cat /tmp/xmluxPreambleOption | sed 's/--style=//g' > /tmp/xmluxStyle

	style="$(cat /tmp/xmluxStyle)"

	find /usr/local/lib/xmlux/documentClasses/style -name $style > /tmp/xmluxDetailStyle

	leggoDetailStyle="$(cat /tmp/xmluxDetailStyle)" 

	cat /tmp/xmluxDetailStyle | cut -d. -f2,2 > /tmp/xmluxStyleType

	leggoStyleType="$(cat /tmp/xmluxStyleType)"

	if test $leggoStyleType == "css"

	then
		styleType="css"

		## ancora non ho studiato lo stile XLS
		#else

                #styleType="xls" boh?

	fi

fi


done


	### Devo fare la stessa cosa anche nelle altre modalità di xmlux, ossia quando non scelgo --matter;
	## ora non ho tempo.

	#	vim -c ":%s/matter.css/$nomeFile.css/g" $percorsoIsolato/$nomeFile-xmlux/$nomeFile.lmx -c :w -c :q

        #       vim -c ":%s/matter.dtd/$nomeFile.dtd/g" $percorsoIsolato/$nomeFile-xmlux/$nomeFile.lmx -c :w -c :q

if [ -f /tmp/xmlux-percorsoIsolato ]; then

                percorsoIsolato="$(cat /tmp/xmlux-percorsoIsolato)"

if [ -f /tmp/xmlux-stand]; then

if [ -f /tmp/xmlux-encoding]; then

echo "<?xml version=\"1.0\" encoding=\"$enc\" standalone=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $percorsoIsolato/$nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-encoding

else

echo "<?xml version=\"1.0\" standalone=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $percorsoIsolato/$nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-stand

fi

fi


if [ -f /tmp/xmlux-encoding]; then

if [ -f /tmp/xmlux-stand]; then

echo "<?xml version=\"1.0\" encoding=\"$enc\" standalone=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $percorsoIsolato/$nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-stand

else

echo "<?xml version=\"1.0\" encoding=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $percorsoIsolato/$nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-encoding

fi

fi

cp $leggoDetailStyle $percorsoIsolato/$nomeFile-xmlux/

sudo chown -R $USER:$USER $percorsoIsolato/$nomeFile-xmlux/

sudo chmod -R ugao-xrw $percorsoIsolato/$nomeFile-xmlux/

sudo chmod uga+x $percorsoIsolato/$nomeFile-xmlux/

sudo chmod -R uga+rw $percorsoIsolato/$nomeFile-xmlux/

else

if [ -f /tmp/xmlux-stand]; then

if [ -f /tmp/xmlux-encoding]; then

echo "<?xml version=\"1.0\" encoding=\"$enc\" standalone=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-encoding

else

echo "<?xml version=\"1.0\" standalone=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-stand

fi

fi


if [ -f /tmp/xmlux-encoding]; then

if [ -f /tmp/xmlux-stand]; then

echo "<?xml version=\"1.0\" encoding=\"$enc\" standalone=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-stand

else

echo "<?xml version=\"1.0\" encoding=\"$stand\"?>
<?xml-stylesheet type=\"text/$styleType\" href=\"$style\"?>
" > $nomeFile-xmlux/$nomeFile

rm /tmp/xmlux-encoding

fi

fi

cp $leggoDetailStyle $nomeFile-xmlux/

sudo chown -R $USER:$USER $nomeFile-xmlux/

sudo chmod -R ugao-xrw $nomeFile-xmlux/

sudo chmod uga+x $nomeFile-xmlux/

sudo chmod -R uga+rw $nomeFile-xmlux/

fi





exit



# _Dev section, not supplied by this version.
# e.g.

# xmlux -v1.0 --stand=no --encoding=UTF-8 --style=css2 --f=greeting

# It applies to new file <greeting.lmx> the preamble:
# <
# version=1.0
# encoding=UTF-8
# standalone=no
# stylesheet type=\"text/css\" href=\"greeting.css\"
# >

