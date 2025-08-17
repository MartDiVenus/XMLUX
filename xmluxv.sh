#!/bin/bash

sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/vimrc.local /etc/vim/

sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/gvimrc.local /etc/vim/

if [ ! -f /usr/share/vim/vim90/syntax/lmx.vim ]; then
  sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim90/syntax/lmx.vim /usr/share/vim/vim90/syntax
  sudo chown root:root /usr/share/vim/vim90/syntax/lmx.vim
  sudo chmod ugao-xrw /usr/share/vim/vim90/syntax/lmx.vim
  sudo chmod u+w /usr/share/vim/vim90/syntax/lmx.vim
  sudo chmod uga+r /usr/share/vim/vim90/syntax/lmx.vim
  sudo chmod ug+r /usr/share/vim/vim90/syntax/lmx.vim
fi

if [ ! -d /home/$USER/.vim/autoload ]; then
  mkdir /home/$USER/.vim/autoload
  cp /usr/local/lib/xmlux/xtextus/lmx/functions/* /home/$USER/.vim/autoload 2> /dev/null
  chown -R $USER:$USER /home/$USER/.vim/autoload
  chmod -R ug+r /home/$USER/.vim/autoload
  else
  cp /usr/local/lib/xmlux/xtextus/lmx/functions/* /home/$USER/.vim/autoload 2> /dev/null
  chown -R $USER:$USER /home/$USER/.vim/autoload
  chmod -R ug+r /home/$USER/.vim/autoload
fi

if [ ! -f /usr/share/vim/vim90/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim90/colors/mart.vim /usr/share/vim/vim90/colors
   sudo chown root:root /usr/share/vim/vim90/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim90/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim90/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim90/colors/mart.vim
fi

############################ Eseguibile per la compilazione
rm -fr /tmp/xmluxv*

### Begin trees logs

touch /tmp/xmluxv-allIDs

touch /tmp/xmluxv-allElements

touch /tmp/xmluxv-allTitles

touch /tmp/xmluxv-itemsEtIDs

touch /tmp/xmluxv-itemsEtIDsEtTitles

touch /tmp/xmluxv-IDsEtTitles

touch /tmp/xmluxv-itemsEtTitles

## kin

touch /tmp/xmluxv-allIDsRec

touch /tmp/xmluxv-allElementsRec

touch /tmp/xmluxv-allTitlesRec

touch /tmp/xmluxv-itemsEtIDsRec

touch /tmp/xmluxv-itemsEtIDsEtTitlesRec

touch /tmp/xmluxv-IDsEtTitlesRec

touch /tmp/xmluxv-itemsEtTitlesRec

##### End trees logs

rm -fr /tmp/xmluxvPseudoOptions

mkdir /tmp/xmluxvPseudoOptions

rm -fr /tmp/xmluxvPseudoOptionsSchemi

mkdir /tmp/xmluxvPseudoOptionsSchemi

## Possibile opzione/azione
leggo1="$(echo $1 > /tmp/xmluxvPseudoOptions/01)"

## Possibile opzione/azione  
leggo2="$(echo $2 > /tmp/xmluxvPseudoOptions/02)"

## Possibile opzione/azione  
leggo3="$(echo $3 > /tmp/xmluxvPseudoOptions/03)"

## Target: percorso e nome del file
leggo4="$(echo $4 >  /tmp/xmluxvPseudoOptions/04)"

rileggoInput1="$(cat /tmp/xmluxvPseudoOptions/01 2> /dev/null)"

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
Name: xmluxv"
echo "
Goal: To view lists of elements, ids, titles of *.lmx files."
echo " "
		echo "Version: xmluxv-2.0.0"
		echo " "
echo "help				         				-h"
echo ""
echo ""
echo "target file								--f='file name without extension'"
echo "wildcard * as --f entire value or partial value, is accepted."
echo "If you have (into the project folder) one *.lmx only [together other xmlux files],
as default and as I suggest, just type one * [e.g. --f=*]."

echo ""
echo "silent mode: prints only output file.					-s"
echo ""
echo "view IDs list								-id"
echo "" 
echo "view names list								-n"
echo ""
echo "view elements list 							-e"
echo ""
echo "view titles list 							-t"
echo ""
echo "view IDs and names list 						-in"
echo ""
echo "view IDs  and elements list 						-ie"
echo ""
echo "view IDs and titles list 						-it"
echo ""
echo "view elements and titles list 						-et"
echo ""
echo "view IDs, elements and names list					-ien"
echo ""
echo "view IDs, elements and names list					-int"
echo ""
echo "view IDs, elements and titles list					-iet"
echo ""
echo "view IDs, elements, names and titles list 				-all"
echo " "
echo " "
echo " "
echo "find/match IDs or names or titles, and their relations:"
echo " "
echo "find/match IDs								--find-id='ID'"
echo "							or equally	--find-id=\"'ID'\""
echo " "
echo "find/match name						only		--find-name=\"'name'\""
echo " "
echo "find/match title					only		--find-title=\"'title'\""
echo " "
echo " "
echo " "
echo "Usage:
cd 'path of the project'

xmluxv -option --action --f<Value without extension>"
echo " "
echo "e.g."
echo "xmluxv -s -all --f=bea"
echo " "
echo "xmluxv -all --f=bea"
echo " "
echo " "
echo "xmluxv --find-id='ID' --f=bea"
echo "or equally"
echo "xmluxv --find-id=\"'ID'\" --f=bea"
echo ""
echo "for name attribute, only double-quoted value is accepted:"
echo "xmluxv --find-name=\"'name'\" --f=bea"
echo ""
echo "for title, only double-quoted value is accepted:"
echo "xmluxv --find-title=\"'title'\" --f=bea"
echo " "
echo " "
echo " "
echo "Copyright:
Copyright (C) 2023.09.23 Mario Fantini (marfant7@gmail.com).
Bash copyright applies to its Mario Fantini's BASH usage.
GNU copyright applies to its Mario Fantini's GNU tools usage.
XML copyright applies to its Mario Fantini's XML tools usage.
VIM copyright applies to its Mario Fantini's VIM usage.
Java copyright applies to its Mario Fantini's JAVA tools usage.
And so on.
"

rm -fr /tmp/xmluxv*

exit

fi

for a in $(ls /tmp/xmluxvPseudoOptions)

do

	grep "^--f=" /tmp/xmluxvPseudoOptions/$a > /tmp/xmluxvTargetFileOp

	stat --format %s /tmp/xmluxvTargetFileOp > /tmp/xmluxvTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxvTargetFileBytes)

	if test $leggoBytes -gt 1

	then

	cat /tmp/xmluxvPseudoOptions/$a | sed 's/--f=//g' > /tmp/xmluxvTargetFilePre

        fi
done

leggoTargetFilePre="$(cat /tmp/xmluxvTargetFilePre)"

ls $leggoTargetFilePre.lmx | cut -d. -f1,1 > /tmp/xmluxvTargetFile

targetFile="$(cat /tmp/xmluxvTargetFile)"

cp $targetFile.lmx $targetFile.lmx.back

### Individuazione document class
for c in {1}

do

grep "^<\!-- matter book document class -->" $targetFile.lmx > /tmp/xmluxv-matterBookDocumentClassGrep


stat --format %s /tmp/xmluxv-matterBookDocumentClassGrep > /tmp/xmluxv-matterBookDocumentClassGrepBytes

leggoMatterBookDocumentClassGrepBytes=$(cat /tmp/xmluxv-matterBookDocumentClassGrepBytes)

#read -p "614 testing" EnterNull

if test $leggoMatterBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/matter/matter-book/xmluxvMatter-book.sh

break

fi

grep "^<\!-- matter article document class -->" $targetFile.lmx > /tmp/xmluxv-matterArticleDocumentClassGrep

stat --format %s /tmp/xmluxv-matterArticleDocumentClassGrep > /tmp/xmluxv-matterArticleDocumentClassGrepBytes

leggoMatterArticleDocumentClassGrepBytes=$(cat /tmp/xmluxv-matterArticleDocumentClassGrepBytes)

#read -p "637 testing" EnterNull

if test $leggoMatterArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/matter/matter-article/xmluxvMatter-article.sh

break

fi

grep "^<\!-- brief book document class -->" $targetFile.lmx > /tmp/xmluxv-briefBookDocumentClassGrep

stat --format %s /tmp/xmluxv-briefBookDocumentClassGrep > /tmp/xmluxv-briefBookDocumentClassGrepBytes

leggoBriefBookDocumentClassGrepBytes=$(cat /tmp/xmluxv-briefBookDocumentClassGrepBytes)

#read -p "655 testing" EnterNull

if test $leggoBriefBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/brief/brief-book/xmluxvBrief-book.sh

break

fi

grep "^<\!-- brief article document class -->" $targetFile.lmx > /tmp/xmluxv-briefArticleDocumentClassGrep

stat --format %s /tmp/xmluxv-briefArticleDocumentClassGrep > /tmp/xmluxv-briefArticleDocumentClassGrepBytes

leggoBriefArticleDocumentClassGrepBytes=$(cat /tmp/xmluxv-briefArticleDocumentClassGrepBytes)


if test $leggoBriefArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/brief/brief-article/xmluxvBrief-article.sh

break

fi

grep "^<\!-- septem gradus data document class -->" $targetFile.lmx > /tmp/xmluxv-sevenLevelsDataDocumentClassGrep

stat --format %s /tmp/xmluxv-sevenLevelsDataDocumentClassGrep > /tmp/xmluxv-sevenLevelsDataDocumentClassGrepBytes

leggoSevenLevelsDataDocumentClassGrepBytes=$(cat /tmp/xmluxv-sevenLevelsDataDocumentClassGrepBytes)

if test $leggoSevenLevelsDataDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/data/data-seven/xmluxvData-seven.sh

break

fi

grep "^<\!-- category dataset 01 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset01DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset01DataDocumentClassGrep > /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes

categoryDataset01DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes)

if test $categoryDataset01DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/data/categoryDataset/xmluxvData-categoryDataset01.sh

break

fi


grep "^<\!-- category dataset 02 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset02DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset02DataDocumentClassGrep > /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes

categoryDataset02DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes)

if test $categoryDataset02DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/data/categoryDataset/xmluxvData-categoryDataset02.sh

break

fi

grep "^<\!-- pie dataset document class -->" $targetFile.lmx > /tmp/xmlux-pieDatasetDataDocumentClassGrep

stat --format %s /tmp/xmlux-pieDatasetDataDocumentClassGrep > /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes

pieDatasetDocumentClassGrepBytes=$(cat /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes)

if test $pieDatasetDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxvDocumentClass/data/pieDataset/xmluxvData-pieDataset.sh

break

fi

done

rm -rf /tmp/xmluxv*

exit

