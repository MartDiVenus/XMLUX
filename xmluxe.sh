#!/bin/bash


rm -fr ~/.vim/vimScript/xmluxe/

mkdir -p ~/.vim/vimScript/xmluxe


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

rm -fr /tmp/xmluxe*

rm -fr /tmp/InsXmluxe-*

touch /tmp/xmluxe-allIDs

# il seguente file serve al codice di xmluxe invece
touch /tmp/xmluxe-itemsEtIDs

rm -fr /tmp/xmluxePseudoOptions

mkdir /tmp/xmluxePseudoOptions

rm -fr /tmp/xmluxePseudoOptionsSchemi

mkdir /tmp/xmluxePseudoOptionsSchemi

## azione
leggo1="$(echo $1 > /tmp/xmluxePseudoOptions/01)"

## Possibile opzione  
leggo2="$(echo $2 > /tmp/xmluxePseudoOptions/02)"

## Possibile opzione  
leggo3="$(echo $3 > /tmp/xmluxePseudoOptions/03)"

## Possibile opzione  
leggo4="$(echo $4 >  /tmp/xmluxePseudoOptions/04)"

## Target: percorso e nome del file
leggo5="$(echo $5 >  /tmp/xmluxePseudoOptions/05)"

for ante in {1}

do

rileggoInput1="$(cat /tmp/xmluxePseudoOptions/01 2> /dev/null)"

if test "$rileggoInput1" == "-h"

then

	clear 
	
	echo ""
	echo ""	
	echo ""	
	echo ""	
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
echo "
Name: xmluxe"
echo "
Goal: to compose, edit, manipulate *.lmx structure by automatic, logical, orderly, forced way too.
jump*, select*, parse*, render* are common actions for xmluxe and xtextus, but xmluxe logs everything
of them in *.lmxe.
xtextus doesn't supply some other xmluxe's powerful actions.
An other difference is the speed of execution, xmluxe is few milliseconds slower than xtextus."
echo ""
		echo "Version: xmluxe-2.0.0"
		echo ""
echo "help				         				-h"
echo ""
echo ""
echo ""
echo "chars									-char
open by gvim: /usr/local/lib/xmlux/char/"
echo ""
echo ""
echo "pattern									-pattern
open by gvim: /usr/local/lib/xmlux/pattern/"
echo ""
echo ""
echo ""
echo ""
echo "Target file.								--f='Value without extension'"
echo "wildcard * as -f entire value or partial value, is accepted."
echo "If you have (into the project folder) one *.lmx only [together other xmlux files],
as default and as I suggest, just type one * [e.g. --f=*]."

echo ""
echo ""
echo ""
echo ""
echo "Open *.lmx file jumping to ID line by ID.				--jump-id='ID'"
echo ""
echo "Open *.lmx file jumping to name attribute ID line by name attribute.	--jump-name=\"'name'\""
echo "Warning! Double-quoted name attribute"
echo ""
echo "Open *.lmx file jumping to title line by title.				--jump-title=\"'title'\""
echo "Warning! Double-quoted title"
echo ""
echo ""
echo ""
echo ""
echo "Select by name attribute, in read-only mode, the element"
echo "and its children.							--selectR-name=\"'name'\""
echo "Warning! Double-quoted name attribute"
echo ""
echo "Select by title, in read-only mode, the element"
echo "and its children.							--selectR-title=\"'title'\""
echo "Warning! Double-quoted title"
echo ""
echo ""
echo "Select by ID, in read-only mode, the element and its children.		--selectR-id='ID'"
echo "Warning! Not quoted ID, not double-quoted ID"
echo ""
echo "Select by name attribute, in write mode, the element"
echo "and its children.							--selectW-name=\"'name'\""
echo "Warning! Double-quoted name attribute"
echo ""
echo ""
echo "Select by title, in write mode, the element"
echo "and its children.							--selectW-title=\"'title'\""
echo "Warning! Double-quoted name attribute"
echo ""
echo ""
echo "Select by ID, the element and its children.				--selectW-id='ID'"
echo "Warning! Not quoted ID, not double-quoted ID"
echo ""
echo ""
echo ""
echo ""
echo "Render through name attribute, by css* style, the element"
echo "and its children.							--renderCss-name=\"'name'\""
echo "Warning! Double-quoted name attribute"
echo ""
echo ""
echo "Render through title, by css* style, the element"
echo "and its children.							--renderCss-title=\"'title'\""
echo "Warning! Double-quoted title"
echo ""
echo ""
echo "Render through ID, by css* style, the element"
echo "and its children.							--renderCss-id='ID'"
echo "Warning! Not quoted ID, not double-quoted ID"
echo ""
echo ""
echo ""
echo ""
echo "Parse by name attribute the element only, not its children.		--parse-name=\"'name'\""
echo "Warning! Double-quoted name attribute"
echo ""
echo "Parse by title the element only, not its children.			--parse-title=\"'title'\""
echo "Warning! Double-quoted title"
echo ""
echo ""
echo "Parse by ID the element only, not its children.				--parse-id='ID'"
echo "Warning! Not quoted ID, not double-quoted ID"
echo ""
echo "Parse by name attribute the element and its children.			--parse-name=\"'name'\" -all"
echo "Warning! Double-quoted name attribute"
echo ""
echo "Parse by title the element and its children.				--parse-title=\"'title'\" -all"
echo "Warning! Double-quoted title"
echo ""
echo ""
echo "Parse by ID the element and its children.				--parse-id='ID' -all"
echo "Warning! Not quoted ID, not double-quoted ID"
echo ""
echo ""
echo ""
echo ""

echo "Insert an ID family level								--ins='ID'"
echo ""
echo ""
echo "	For:
brief article, brief book, matter article, matter book, data-seven, 
you can insert every elements.

	For:
category dataset01, category dataset02,
you can insert Series or Items, value and key are inserted consequentially.

	For:
pie dataset,
you can insert Items only, value and key are inserted consequentially.
"

echo "		Only for:"
echo "brief article, brief book, matter article, matter book, data-seven;
for category dataset01, category dataset02, pie dataset, it happens automatically. 
Category dataset02 has not title for Items, it has titles for Series."
echo "Insert an ID family level, specifying title and content of element too.			--ins='ID' -t"
echo ""
echo "		Only for:"
echo "brief article, brief book, matter article, matter book, data-seven;
for category dataset01, category dataset02, pie dataset, it happens automatically."
echo "Insert an ID family level, specifying name attribute of element too.			--ins='ID' -name"
echo ""
echo "		Only for:"
echo "brief article, brief book, matter article, matter book, data-seven;
for category dataset01, category dataset02, pie dataset, it happens automatically.
Category dataset02 has not title for Items, it has titles for Series."
echo "Insert an ID family level, specifying name attribute of element,
and titles too.										--ins='ID' -name -t"
echo ""
echo ""
echo "		Only for septem gradus data document class (data-seven):"
echo "Insert an ID family level, and sort ascending through name attribute		--ins-a='ID'"
echo "that you'll supply interactively."
echo ""
echo "Insert an ID family level, and sort ascending through name attribute,		--ins-a='ID' -t"
echo "that you'll supply interactively; specifying title and content of element too."
echo ""
echo "Insert an ID family level, and sort ascending through title			--ins-at='ID'"
echo "that you'll supply interactively."
echo ""
echo "Insert an ID family level, and sort ascending through title			--ins-at='ID' -name"
echo "that you'll supply interactively; specifying name attribute too."
echo ""
echo "Insert an ID family level, and sort descending through name attribute		--ins-d='ID'"
echo "that you'll supply interactively."
echo ""
echo "Insert an ID family level, and sort descending through name attribute,		--ins-d='ID' -t"
echo "that you'll supply interactively; specifying title and content of element too."
echo ""
echo "Insert an ID family level, and sort descending through title			--ins-dt='ID'"
echo ""
echo "Insert an ID family level, and sort descending through title			--ins-dt='ID' -name"
echo "that you'll supply interactively; specifying name attribute too."
echo ""
echo "Both, insert actions, are the fastest human way, but the \"slowest\" machine way;
insert action is a very fast machine task however."
echo "Next istance <Add the ID element> is the slowest human way, but the fastest machine way."
echo ""
echo ""
echo ""
echo ""
echo "Add the ID element. 							--add='ID'"
echo ""
echo "Write title and content of the ID element to add.  			-w"
echo ""
echo ""
echo "Write name attribute content of the ID element to add.  		-name"
echo ""
echo "Only for category dataset and pie dataset document classes:"
echo "Add title of the ID Key element to add, or sort ID Key element.		-k"
echo "Key ID and Value ID have same lenght, so if option -k is not
specified, you'll want to add or to sort a Value element"  
echo ""
echo ""
echo ""
echo ""
echo "Only for septem gradus data document class (data-seven):"
echo "Ascending sort by ID level: from A to Z, from 0 to +infinity		--sort-a='IDlevel'"
echo ""
echo ""
echo "Only for septem gradus data document class (data-seven):"
echo "Descending sort by ID level: from Z to A, from +infinity to 0		--sort-d='IDlevel'"
echo ""
echo ""
echo "Sort by ID level and through title.					-t"
echo "Default behaviour [without options] constists in sorting" 
echo "through name attribute"
echo ""
echo ""
echo ""
echo ""
echo "Delete IDs lacks (IDs voids). 
It can consist in document checking.						-delLack"
echo "It makes no sense to specify this option for
Keys or Values, because an Item can contain
only one Key and one Value. You can express this
option for Items, Series, chapters, sections, and
any other element, except for Keys and Values."
echo ""
echo ""
echo ""
echo ""
echo "Remove the ID element and its children.						--remove='ID'"
echo ""
echo ""
echo "Remove the ID element and its children, delete IDs lacks (voids) finally."
echo "										--remove='ID' -delLack"
echo ""
echo ""
echo ""
echo ""
echo "Move the ID element and its children after 
'Value' unit.									--move='ID' -a'Value'"
echo ""
echo "Move all elements starting from the ID element [and their children]
after, 'Value' unit until the relative end.					--move='ID' -a'Value' -end"
echo ""
echo "Move the ID element and its children before	
'Value' unit.									--move='ID' -b'Value'"
echo ""
echo ""
echo "Move all elements starting from the ID element [and their children]
before, 'Value' unit until the relative end.					--move='ID' -b'Value' -end"
echo ""
echo ""
echo ""
echo ""

echo "Usage"
echo "cd 'path of the project'"

echo "Simple are the following examples, but you can use xmluxe for any element, e.g. you
can use xmluxe to move one or more paragraphs of the same family too:
xmluxe --action -option --f=<Value without extension>"
echo ""
echo "e.g.:

	Only for data document classes 
(data-seven, category dataset01, category dataset02, pie dataset):
To insert a gradusIII ID, of a01's family (a01 gradusI), e.g.
xmluxe --ins=a01.01.01 --f=greeting
e.g. if last existing a01 gradusIII ID was a01.01.03, you will have a01.01.04.
But if exists a02.01.03, you will not get a02.01.04 because you have specified
a01 family.

	Only for septem gradus data document class (data-seven):
To insert a gradusIII ID, of a01's family (a01 gradusI), and to sort ascending
through name attribute, both actions automatically.
e.g. to add a GradusIII, that will be insert and sorted ascending through name
attribute automatically:
xmluxe --ins-a=a01.01.01 --f=greeting
e.g. if last existing a01 gradusIII ID was a01.01.03, you will have a01.01.04
but sorting by ID level and through name attribute.

To insert a gradusIII ID, of a01's family (a01 gradusI), and to sort ascending
through title, both actions automatically.
e.g. to add a GradusIII, that will be insert and sorted ascending through title
automatically:
xmluxe --ins-at=a01.01.01 --f=greeting
e.g. if last existing a01 gradusIII ID was a01.01.03, you will have a01.01.04
but sorting by ID level and through title.



To add the third chapter to the first part,
xmluxe --add=a01.03 --f=greeting

To add the third chapter to the first part; and to write title and content of
the element to add, in this xmlux session,
xmluxe --add=a01.03 -w --f=greeting


To add the third item to the first series; and to write content of the item
to add:
xmluxe --add=a01.03 -w --f=greeting

To add the third item to the first series; to write content of the item
to add; to specify name attribute:
xmluxe --add=a01.03 -name --f=greeting
aka
xmluxe --add=a01.03 -w -name --f=greeting


e.g. If you have a lack between first chapter  and third chapter: 
xmluxe -delLack --f=greeting



To remove the second chapter (and its children) of the first part,
xmluxe --remove=a01.02 --f=greeting

To remove the second chapter (and its children) of the first part,
and to delete the lack that will be created (by removal) between
first chapter  and third chapter.
xmluxe --remove=a01.02 -delLack --f=greeting



To move part a08, and its children, one unit after,
xmluxe --move=a08 -a1 --f=greeting


To move parts, and their children, one unit after until the end; starting
from part a07. Be careful: You must specify the lowest ID among parts you
want to move.
e.g. you have parts from part a01 to a09. You want to move parts a07, a08,
a09 one unit after to have part a08, a09, a10; of course then, you'll have
a lack between part a06 and part a08 because part a07 doesn't exist no more.
e.g. you have done this because you want to add a new part a07 between part
a06 and part a08, where part a08 is the past part a07.
xmluxe --move=a07 -a1 -end --f=greeting


To move part a01, and its children, two units after,
xmluxe --move=a01 -a2 --f=greeting


To move part a05, and its children, one unit before,
xmluxe --move=a05 -b1 --f=greeting


To move parts after part a06 [including it] and their children, one unit
before, until the end.
Be careful: You must specify the lowest ID among parts you want to move.
e.g. you have parts from part a01 to part a08. Between part a04 and part
a06 you have a lack (e.g. you removed part a05). To downgrade part a08,
a07, a06 one unit to have part a07, part a06, part a05:
you have to select part a06 and you must to specify <1> like value of
option <b>.
xmluxe --move=a06 -b1 -end --f=greeting


To move part a05, and its children, two units before.
xmluxe --move=a05 -b2 --f=greeting


To select in read-only mode the ID element and its children:
xmluxe -selectR='ID' --f=greeting

To select in write mode the ID element and its children:
xmluxe -selectW='ID' --f=greeting


To sort by ID level axx.xx.xx (GradusIII) and through name attribute ascending.
e.g. a01.01.01 ... a01.01.03, a02.01.01 ... a02.01.03 
xmluxe --sort-a=a01.01.01 --f=*


To sort by ID level axx.xx.xx (GradusIII) and through name attribute descending.
e.g. a01.01.01 ... a01.01.03, a02.01.01 ... a02.01.03 
xmluxe --sort-d=a01.01.01 --f=*


To sort by ID level axx.xx.xx (GradusIII) and through title ascending.
e.g. a01.01.01 ... a01.01.03, a02.01.01 ... a02.01.03 
xmluxe --sort-a=a01.01.01 -t --f=*


To sort by ID level axx.xx.xx (GradusIII) and through title descending.
e.g. a01.01.01 ... a01.01.03, a02.01.01 ... a02.01.03 
xmluxe --sort-d=a01.01.01 -t --f=*



Copyright:
Copyright (C) 2023.09.23 Mario Fantini (ing.mariofantini@gmail.com).
Bash copyright applies to its Mario Fantini's BASH usage.
GNU copyright applies to its Mario Fantini's GNU tools usage.
XML copyright applies to its Mario Fantini's XML tools usage.
VIM copyright applies to its Mario Fantini's VIM usage.
Java copyright applies to its Mario Fantini's JAVA tools usage.
And so on.
"

rm -fr /tmp/xmluxe*

exit

break

fi

if test "$rileggoInput1" == "-char"

then

	gvim /usr/local/lib/xmlux/char/

	rm -fr /tmp/xmluxe*

	exit

	break

fi

if test "$rileggoInput1" == "-pattern"

then

	gvim /usr/local/lib/xmlux/pattern/

	rm -fr /tmp/xmluxe*

	exit

	break

fi

done


for a in $(ls /tmp/xmluxePseudoOptions)

do

	grep "^--f=" /tmp/xmluxePseudoOptions/$a > /tmp/xmluxeTargetFileOp

	stat --format %s /tmp/xmluxeTargetFileOp > /tmp/xmluxeTargetFileBytes

	leggoBytes=$(cat /tmp/xmluxeTargetFileBytes)

	if test $leggoBytes -gt 1

	then

	cat /tmp/xmluxePseudoOptions/$a | sed 's/--f=//g' > /tmp/xmluxeTargetFilePre

        fi
done

leggoTargetFilePre="$(cat /tmp/xmluxeTargetFilePre)"

ls $leggoTargetFilePre.lmx | cut -d. -f1,1 > /tmp/xmluxeTargetFile

targetFile="$(cat /tmp/xmluxeTargetFile)"

cp $targetFile.lmx $targetFile.lmx.back


### Individuazione document class
for c in {1}

do

grep "^<\!-- matter book document class -->" $targetFile.lmx > /tmp/xmlux-matterBookDocumentClassGrep


stat --format %s /tmp/xmlux-matterBookDocumentClassGrep > /tmp/xmlux-matterBookDocumentClassGrepBytes

leggoMatterBookDocumentClassGrepBytes=$(cat /tmp/xmlux-matterBookDocumentClassGrepBytes)

#read -p "614 testing" EnterNull

if test $leggoMatterBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/matter/matter-book/xmluxeMatter-book.sh

break

fi

grep "^<\!-- matter article document class -->" $targetFile.lmx > /tmp/xmlux-matterArticleDocumentClassGrep

stat --format %s /tmp/xmlux-matterArticleDocumentClassGrep > /tmp/xmlux-matterArticleDocumentClassGrepBytes

leggoMatterArticleDocumentClassGrepBytes=$(cat /tmp/xmlux-matterArticleDocumentClassGrepBytes)

#read -p "637 testing" EnterNull

if test $leggoMatterArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/matter/matter-article/xmluxeMatter-article.sh

break

fi

grep "^<\!-- brief book document class -->" $targetFile.lmx > /tmp/xmlux-briefBookDocumentClassGrep

stat --format %s /tmp/xmlux-briefBookDocumentClassGrep > /tmp/xmlux-briefBookDocumentClassGrepBytes

leggoBriefBookDocumentClassGrepBytes=$(cat /tmp/xmlux-briefBookDocumentClassGrepBytes)

#read -p "655 testing" EnterNull

if test $leggoBriefBookDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/brief/brief-book/xmluxeBrief-book.sh

break

fi

grep "^<\!-- brief article document class -->" $targetFile.lmx > /tmp/xmlux-briefArticleDocumentClassGrep

stat --format %s /tmp/xmlux-briefArticleDocumentClassGrep > /tmp/xmlux-briefArticleDocumentClassGrepBytes

leggoBriefArticleDocumentClassGrepBytes=$(cat /tmp/xmlux-briefArticleDocumentClassGrepBytes)


if test $leggoBriefArticleDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/brief/brief-article/xmluxeBrief-article.sh

break

fi

grep "^<\!-- septem gradus data document class -->" $targetFile.lmx > /tmp/xmlux-sevenLevelsDataDocumentClassGrep

stat --format %s /tmp/xmlux-sevenLevelsDataDocumentClassGrep > /tmp/xmlux-sevenLevelsDataDocumentClassGrepBytes

leggoSevenLevelsDataDocumentClassGrepBytes=$(cat /tmp/xmlux-sevenLevelsDataDocumentClassGrepBytes)

if test $leggoSevenLevelsDataDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/data/data-seven/xmluxeData-seven.sh

break

fi

grep "^<\!-- category dataset 01 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset01DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset01DataDocumentClassGrep > /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes

categoryDataset01DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset01DataDocumentClassGrepBytes)

if test $categoryDataset01DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/data/categoryDataset/xmluxeData-categoryDataset01.sh

break

fi


grep "^<\!-- category dataset 02 document class -->" $targetFile.lmx > /tmp/xmlux-categoryDataset02DataDocumentClassGrep

stat --format %s /tmp/xmlux-categoryDataset02DataDocumentClassGrep > /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes

categoryDataset02DocumentClassGrepBytes=$(cat /tmp/xmlux-categoryDataset02DataDocumentClassGrepBytes)

if test $categoryDataset02DocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/data/categoryDataset/xmluxeData-categoryDataset02.sh

break

fi

grep "^<\!-- pie dataset document class -->" $targetFile.lmx > /tmp/xmlux-pieDatasetDataDocumentClassGrep

stat --format %s /tmp/xmlux-pieDatasetDataDocumentClassGrep > /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes

pieDatasetDocumentClassGrepBytes=$(cat /tmp/xmlux-pieDatasetDataDocumentClassGrepBytes)

if test $pieDatasetDocumentClassGrepBytes -gt 0

then

/usr/local/lib/xmlux/xmluxeDocumentClass/data/pieDataset/xmluxeData-pieDataset.sh

break

fi


done


rm -fr /tmp/xmluxe*


exit

