#!/bin/bash

rm -fr /tmp/xmlux*
rm -fr /tmp/xtextus*

mkdir /tmp/xtextusPseudoOptions

leggo1=$(echo $1 > /tmp/xtextusPseudoOptions/input1)

leggo2=$(echo $2 > /tmp/xtextusPseudoOptions/input2)

for ante in {1}

do

grep "^-h" /tmp/xtextusPseudoOptions/* > /tmp/xtextus--optionHelp

stat --format %s /tmp/xtextus--optionHelp > /tmp/xtextus--optionHelpBytes

leggoBytes=$(cat /tmp/xtextus--optionHelpBytes)

if test $leggoBytes -gt 0

then
echo " "
echo "xtextus 

Goal: View and/or edit *.xml or *.lmx by xml vim syntax, tags (to do), and my vim
colours.
jump*, select*, parse*, render* are common actions for xtextus and xmluxe, but
xtextus doesn't log anything of them.
xtextus doesn't supply some other xmluxe's powerful actions.
An other difference is the speed of execution, xtextus is few milliseconds faster than
xmluxe.

For xtextus and xmluxe common actions, see xmluxe help or xmluxe README section.

	
help                                                      -h


target file 						    
wildcard * as --f entire value or partial value, is accepted.
For jump*, select*, parse*, render* actions 		  --f='Value without extension'
For -o, -p, -st, -view options				  --f='Value with or without extension'
P.S. -view option reads only xml files.

open file						  -o

print in ps and pdf, with xml fancy syntax		  -p

Only for septem gradus data (data-seven):
make a structure for the first gradusI
(e.g. a01) and its children. 		                  -st

Usage:
cd 'path of the project'

xtextus 'option' --f='Value with or without extension'

xtextus 'action' --f='Value without extension'

e.g.

cd greeting-xmlux

xtextus -o --f=greeting.xml

xtextus -o --f=greeting.lmx

xtextus -o --f=greeting

xtextus -p --f=greeting.xml

xtextus -p --f=greeting.lmx

xtextus -p --f=greeting


xtextus -st --f=greeting.lmx


xtextus -view --f=greeting
aka
xtextus -view --f=greeting.xml
aka
xtextus -view --f=*


xtextus --jump-id=a01.01 --f=greeting
xtextus --jump-id=a01.01 --f=*

xtextus --selectR-name=\"happy\" --f=greeting
xtextus --selectR-name=\"happy\" --f=*

xtextus --selectW-id=\"a01.01.01\" --f=greeting
xtextus --selectW-id=\"a01.01.01\" --f=*

xtextus --parse-title=\"Sunny\" --f=greeting
xtextus --parse-title=\"Sunny\" --f=*

xtextus --renderCss-id=\"a02\" --f=greeting
xtextus --renderCss-id=\"a02\" --f=*


Copyright:
Copyright (C) 2023.09.23 Mario Fantini (marfant7@gmail.com).
Bash copyright applies to its Mario Fantini's BASH usage.
GNU copyright applies to its Mario Fantini's GNU tools usage.
XML copyright applies to its Mario Fantini's XML tools usage.
VIM copyright applies to its Mario Fantini's VIM usage.
Java copyright applies to its Mario Fantini's JAVA tools usage.
And so on.
"

rm -fr /tmp/xtextus-*

exit

break

fi

grep "^-char$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-optionChar

stat --format %s /tmp/xtextus-optionChar > /tmp/xtextus-optionCharBytes

leggoBytes=$(cat /tmp/xtextus-optionCharBytes)

if test $leggoBytes -gt 0

then

	gvim /usr/local/lib/xmlux/char/

	rm -fr /tmp/xtextus*

	exit

	break

fi

grep "^-pattern$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-optionPattern

stat --format %s /tmp/xtextus-optionPattern > /tmp/xtextus-optionPatternBytes

leggoBytes=$(cat /tmp/xtextus-optionPatternBytes)

if test $leggoBytes -gt 0

then

	gvim /usr/local/lib/xmlux/pattern/

	rm -fr /tmp/xtextus*

	exit

	break

fi


done




for a in $(ls /tmp/xtextusPseudoOptions)

do

	grep "^--f=" /tmp/xtextusPseudoOptions/$a > /tmp/xtextus-TargetFileOp

	stat --format %s /tmp/xtextus-TargetFileOp > /tmp/xtextus-TargetFileBytes

	leggoBytes=$(cat /tmp/xtextus-TargetFileBytes)

	if test $leggoBytes -gt 1

	then

	cat /tmp/xtextusPseudoOptions/$a | sed 's/--f=//g' > /tmp/xtextus-TargetFilePre

	break

        fi
done

leggoTargetFilePre="$(cat /tmp/xtextus-TargetFilePre)"


grep "\.lmx$" /tmp/xtextus-TargetFilePre > /tmp/xtextus-lmx

	stat --format %s /tmp/xtextus-lmx > /tmp/xtextus-lmxBytes

	bytesEstensione=$(cat /tmp/xtextus-lmxBytes)

	if test $bytesEstensione -gt 0

	then

ls $leggoTargetFilePre > /tmp/xtextus-TargetFile

tOrig=$(cat /tmp/xtextus-TargetFile)

echo "$tOrig" > /tmp/xmlux-fullName

/usr/local/lib/xmlux/trattamentoFiles.sh

targetFile=$(cat /tmp/xmlux-nomeSenzaEstensione)

touch /tmp/xtextus-estensioneLmx


else


	grep "\.xml$" /tmp/xtextus-TargetFilePre > /tmp/xtextus-lmx

	stat --format %s /tmp/xtextus-lmx > /tmp/xtextus-lmxBytes

	bytesEstensioneXml=$(cat /tmp/xtextus-lmxBytes)

	if test $bytesEstensioneXml -gt 0

	then

ls $leggoTargetFilePre > /tmp/xtextus-TargetFile

tOrig=$(cat /tmp/xtextus-TargetFile)

echo "$tOrig" > /tmp/xmlux-fullName

/usr/local/lib/xmlux/trattamentoFiles.sh

targetFile=$(cat /tmp/xmlux-nomeSenzaEstensione)

touch /tmp/xtextus-estensioneXml

else

tOrig=$(cat /tmp/xtextus-TargetFilePre)

echo "$tOrig" > /tmp/xmlux-fullName

/usr/local/lib/xmlux/trattamentoFiles.sh

targetFile=$(cat /tmp/xtextus-TargetFilePre)

touch /tmp/xtextus-nessunaEstensione

	fi

	fi


##### Il profilo dei colori che vuoi utilizzare
#### i.e. desert.vim
#### Lascia a me tale scelta, occorre modificare
#### /usr/local/lib/xmlux/xtesto/.../etc/vimrc.local,
#### /usr/local/lib/xmlux/xtesto/.../etc/gvimrc.local
#### /usr/share/vim/vim90/colors
#### in base a essa.
prColors="mart.vim"



rm -f /home/$USER/.vimrc
rm -f /home/$USER/.gvimrc

sudo cp /etc/vim/vimrc.local /etc/vim/vimrc.local.back

sudo cp /etc/vim/gvimrc.local /etc/vim/gvimrc.local.back

## Se il file esistesse dovrei leggere l'estensione per aprirlo con la sintassi e colorazione opportuna
## Se il file non esistesse allora dovrei scegliere la sintassi e la colorazione.


### Individuazione document class
for c in {1}

do

grep "^<\!-- matter book document class -->" $targetFile.lmx > /tmp/xmlux-matterBookDocumentClassGrep


stat --format %s /tmp/xmlux-matterBookDocumentClassGrep > /tmp/xmlux-matterBookDocumentClassGrepBytes

leggoMatterBookDocumentClassGrepBytes=$(cat /tmp/xmlux-matterBookDocumentClassGrepBytes)

#read -p "614 testing" EnterNull

if test $leggoMatterBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/matter/matter-book/xtextusMatter-book.sh

break

fi

grep "^<\!-- matter article document class -->" $targetFile.lmx > /tmp/xmlux-matterArticleDocumentClassGrep

stat --format %s /tmp/xmlux-matterArticleDocumentClassGrep > /tmp/xmlux-matterArticleDocumentClassGrepBytes

leggoMatterArticleDocumentClassGrepBytes=$(cat /tmp/xmlux-matterArticleDocumentClassGrepBytes)

#read -p "637 testing" EnterNull

if test $leggoMatterArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/matter/matter-article/xtextusMatter-article.sh

break

fi

grep "^<\!-- brief book document class -->" $targetFile.lmx > /tmp/xmlux-briefBookDocumentClassGrep

stat --format %s /tmp/xmlux-briefBookDocumentClassGrep > /tmp/xmlux-briefBookDocumentClassGrepBytes

leggoBriefBookDocumentClassGrepBytes=$(cat /tmp/xmlux-briefBookDocumentClassGrepBytes)

#read -p "655 testing" EnterNull

if test $leggoBriefBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/brief/brief-book/xtextusBrief-book.sh

break

fi

grep "^<\!-- brief article document class -->" $targetFile.lmx > /tmp/xmlux-briefArticleDocumentClassGrep

stat --format %s /tmp/xmlux-briefArticleDocumentClassGrep > /tmp/xmlux-briefArticleDocumentClassGrepBytes

leggoBriefArticleDocumentClassGrepBytes=$(cat /tmp/xmlux-briefArticleDocumentClassGrepBytes)


if test $leggoBriefArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/brief/brief-article/xtextusBrief-article.sh

break

fi

grep "^<\!-- septem gradus data document class -->" $targetFile.lmx > /tmp/xmlux-sevenLevelsDataDocumentClassGrep

stat --format %s /tmp/xmlux-sevenLevelsDataDocumentClassGrep > /tmp/xmlux-sevenLevelsDataDocumentClassGrepBytes

leggoSevenLevelsDataDocumentClassGrepBytes=$(cat /tmp/xmlux-sevenLevelsDataDocumentClassGrepBytes)

if test $leggoSevenLevelsDataDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/data/data-seven/xtextusData-seven.sh

break

fi

grep "^<\!-- category dataset 01 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset01DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset01DataDocumentClassGrep > /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes

categoryDataset01DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes)

if test $categoryDataset01DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/data/categoryDataset/xtextusData-categoryDataset01.sh

break

fi


grep "^<\!-- category dataset 02 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset02DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset02DataDocumentClassGrep > /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes

categoryDataset02DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes)

if test $categoryDataset02DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/data/categoryDataset/xtextusData-categoryDataset02.sh

break

fi

grep "^<\!-- pie dataset document class -->" $targetFile.lmx > /tmp/xmlux-pieDatasetDataDocumentClassGrep

stat --format %s /tmp/xmlux-pieDatasetDataDocumentClassGrep > /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes

pieDatasetDocumentClassGrepBytes=$(cat /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes)

if test $pieDatasetDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xtextusDocumentClass/data/pieDataset/xtextusData-pieDataset.sh

break

fi


done

rm -fr /tmp/xtextus*

exit


