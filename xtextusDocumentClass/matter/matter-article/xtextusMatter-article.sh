#!/bin/bash


for estensione in {1}

do

if [ -f /tmp/xtextus-estensioneLmx ]; then

tOrig=$(cat /tmp/xtextus-TargetFile)

targetFile=$(cat /tmp/xmlux-nomeSenzaEstensione)

break

fi

if [ -f /tmp/xtextus-estensioneXml ]; then

tOrig=$(cat /tmp/xtextus-TargetFile)

targetFile=$(cat /tmp/xmlux-nomeSenzaEstensione)

break

fi

if [ -f /tmp/xtextus-nessunaEstensione ]; then

tOrig="$(cat /tmp/xtextus-TargetFilePre).lmx"

targetFile=$(cat /tmp/xtextus-TargetFilePre)

break

fi

done


echo $PWD > /tmp/xtextus-posnow

posnow=$(cat /tmp/xtextus-posnow)


## Tutti gli id che iniziano con <a>, ossia il capitolo a.
# è troppo vincolante utilizzare la chiave <a>.
#grep -o "ID=\"a*.*" $targetFile.lmx > /tmp/xtextus-css01
# In questo modo puoi scrivere ID anche nel preambolo, perché quest'ultimo escluso.
cat $targetFile.lmx | sed -n '/<!-- begin radix/,$p' > /tmp/xtextus-css0000

## mi serve la coerenza di numero di righe tra il file lmx in cui effettuerò le iniezioni
## e il file selezionato in cui ho escluso il preambolo.
grep -n "<!-- begin radix" $targetFile.lmx | cut -d: -f1 > /tmp/xtextus-nLineaBeginRadix

leggoNBeginRadix=$(cat /tmp/xtextus-nLineaBeginRadix)

righeEsatte=$(echo $leggoNBeginRadix - 1 | bc)

touch /tmp/xtextus-IpezzoCoerenzaBeginRadixLmx

declare -i var=0

while ((k++ <$righeEsatte))
  do
  var=$var+1
  echo "riga per coerenza con il file lmx n. $var" >> /tmp/xtextus-IpezzoCoerenzaBeginRadixLmx
done 

cat /tmp/xtextus-IpezzoCoerenzaBeginRadixLmx /tmp/xtextus-css0000 > /tmp/xtextus-css000

for option in {1}

do

grep "^-o$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionOpen

stat --format %s /tmp/xtextus-actionOpen > /tmp/xtextus-actionOpenBytes

leggoBytes=$(cat /tmp/xtextus-actionOpenBytes)

if test $leggoBytes -gt 0

then

	for estensioneAgain in {1}

	do

if [ -f /tmp/xtextus-estensioneLmx ]; then

   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/xml.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/syntax/xml.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/xml.vim
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

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

break

fi


if [ -f /tmp/xtextus-estensioneXml ]; then
 
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/xml.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/syntax/xml.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/xml.vim
   fi
   if [ ! -d /home/$USER/.vim/autoload ]; then
     mkdir /home/$USER/.vim/autoload
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
    else
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
   fi

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

break

fi


if [ -f /tmp/xtextus-nessunaEstensione ]; then

####################### Se il file non esistesse  


read -p "Choose the codex type you want open:

1. lmx

2. xml

:" choiceLanguage



if test $choiceLanguage == 1
  then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/lmx.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/syntax/lmx.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/lmx.vim
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

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

echo "$tOrig" > /tmp/xtextus-tOrig-per-stampa

fi



if test $choiceLanguage == 2 
  then
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/xml.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/syntax/xml.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/xml.vim
   fi
   if [ ! -d /home/$USER/.vim/autoload ]; then
     mkdir /home/$USER/.vim/autoload
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
    else
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
   fi

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

tOrig="$(cat /tmp/xtextus-TargetFilePre).xml"

echo "$tOrig" > /tmp/xtextus-tOrig-per-stampa

fi

fi

done

sudo chown root:root /etc/vim 2> /dev/null
sudo chmod ugao-xrw /etc/vim 2> /dev/null
sudo chmod uga+r /etc/vim 2> /dev/null
sudo chmod ga+x /etc/vim 2> /dev/null
sudo chmod g-w /etc/vim 2> /dev/null
sudo chmod u+w /etc/vim 2> /dev/null
sudo chmod ugao-xrw /etc/vim/* 2> /dev/null
sudo chmod uga+r /etc/vim/* 2> /dev/null
sudo chmod u+w /etc/vim/* 2> /dev/null



echo "

° To refresh
:cal reloadSource#Source()
"
	gvim -c ':source /etc/vim/gvimrc.local' -c :nos $tOrig -c :w


	break
fi


grep "^-p$" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionPrint

stat --format %s /tmp/xtextus-actionPrint > /tmp/xtextus-actionPrintBytes

leggoBytes=$(cat /tmp/xtextus-actionPrintBytes)

if test $leggoBytes -gt 0

then

	for estensioneAgain in {1}

	do

if [ -f /tmp/xtextus-estensioneLmx ]; then

   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/xml.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/syntax/xml.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/xml.vim
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

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

break

fi


if [ -f /tmp/xtextus-estensioneXml ]; then
 
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/xml.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/syntax/xml.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/xml.vim
   fi
   if [ ! -d /home/$USER/.vim/autoload ]; then
     mkdir /home/$USER/.vim/autoload
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
    else
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
   fi

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

break

fi


if [ -f /tmp/xtextus-nessunaEstensione ]; then

####################### Se il file non esistesse  


read -p "Choose the codex type you want open:

1. lmx

2. xml

:" choiceLanguage



if test $choiceLanguage == 1
  then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/lmx.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/syntax/lmx.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/lmx.vim
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

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

echo "$tOrig" > /tmp/xtextus-tOrig-per-stampa

fi



if test $choiceLanguage == 2 
  then
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/xml/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/xml.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/syntax/xml.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/xml.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/xml.vim
   fi
   if [ ! -d /home/$USER/.vim/autoload ]; then
     mkdir /home/$USER/.vim/autoload
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
    else
     cp /usr/local/lib/xmlux/xtextus/xml/functions/* /home/$USER/.vim/autoload 2> /dev/null
     chown -R $USER:$USER /home/$USER/.vim/autoload
     chmod -R ug+r /home/$USER/.vim/autoload
   fi

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/xml/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

tOrig="$(cat /tmp/xtextus-TargetFilePre).xml"

echo "$tOrig" > /tmp/xtextus-tOrig-per-stampa

fi

fi

done

sudo chown root:root /etc/vim 2> /dev/null
sudo chmod ugao-xrw /etc/vim 2> /dev/null
sudo chmod uga+r /etc/vim 2> /dev/null
sudo chmod ga+x /etc/vim 2> /dev/null
sudo chmod g-w /etc/vim 2> /dev/null
sudo chmod u+w /etc/vim 2> /dev/null
sudo chmod ugao-xrw /etc/vim/* 2> /dev/null
sudo chmod uga+r /etc/vim/* 2> /dev/null
sudo chmod u+w /etc/vim/* 2> /dev/null

	/usr/local/lib/xmlux/xtextus/stampa.sh

	break
fi


   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/vimrc.local /etc/vim/
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/etc/vim/gvimrc.local /etc/vim/
   if [ ! -f /usr/share/vim/vim82/syntax/lmx.vim ]; then
     sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/syntax/lmx.vim /usr/share/vim/vim82/syntax
     sudo chown root:root /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod ugao-xrw /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod u+w /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod uga+r /usr/share/vim/vim82/syntax/lmx.vim
     sudo chmod ug+r /usr/share/vim/vim82/syntax/lmx.vim
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

if [ ! -f /usr/share/vim/vim82/colors/mart.vim ]; then
   sudo cp /usr/local/lib/xmlux/xtextus/lmx/usr/share/vim/vim82/colors/mart.vim /usr/share/vim/vim82/colors
   sudo chown root:root /usr/share/vim/vim82/colors/mart.vim
   sudo chmod ugao-xrw /usr/share/vim/vim82/colors/mart.vim
   sudo chmod u+w /usr/share/vim/vim82/colors/mart.vim
   sudo chmod uga+r /usr/share/vim/vim82/colors/mart.vim
fi

grep "^--jump" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionJump

stat --format %s /tmp/xtextus-actionJump > /tmp/xtextus-actionJumpBytes

leggoBytes=$(cat /tmp/xtextus-actionJumpBytes)

if test $leggoBytes -gt 0

then

	for jump in {1}

	do

######### jump by ID
grep "^--jump-id=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionJump

stat --format %s /tmp/xtextus-actionJump > /tmp/xtextus-actionJumpBytes

leggoBytes=$(cat /tmp/xtextus-actionJumpBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionJump | sed 's/.*=//g' > /tmp/xtextus-idToJump
idToJump="$(cat /tmp/xtextus-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xtextus-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

break

fi


######### jump by name
grep "^--jump-name=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionJump-name

stat --format %s /tmp/xtextus-actionJump-name > /tmp/xtextus-actionJump-nameBytes

leggoBytes=$(cat /tmp/xtextus-actionJump-nameBytes)

if test $leggoBytes -gt 0

then
	cat  /tmp/xtextus-actionJump-name | sed 's/.*=//g' > /tmp/xtextus-idToJump-name
	nameToSelect=$(cat /tmp/xtextus-idToJump-name)

/usr/local/bin/xmluxv --find-name="$nameToSelect" --f=$targetFile

grep "\"$nameToSelect\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToJump

idToJump="$(cat /tmp/xtextus-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xtextus-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

break

fi

######### jump by title
grep "^--jump-title=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionJump-title

stat --format %s /tmp/xtextus-actionJump-title > /tmp/xtextus-actionJump-titleBytes

leggoBytes=$(cat /tmp/xtextus-actionJump-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionJump-title | sed 's/.*=//g' > /tmp/xtextus-idToJump-title
	titleToSelect=$(cat /tmp/xtextus-idToJump-title)

/usr/local/bin/xmluxv --find-title="$titleToSelect" --f=$targetFile

grep "$titleToSelect$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToJump

idToJump="$(cat /tmp/xtextus-idToJump)"

grep -n "ID=\"$idToJump\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToJumpBeginLine

nLineBeginIdToJump=$(cat /tmp/xtextus-idToJumpBeginLine)

gvim +''$nLineBeginIdToJump'|norm! zt' $targetFile.lmx 

break

fi

done


fi


grep "^--selectR" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectR

stat --format %s /tmp/xtextus-actionSelectR > /tmp/xtextus-actionSelectRBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectRBytes)

if test $leggoBytes -gt 0

then

	for selectR in {1}

	do

######### Select id block in read-only mode
grep "^--selectR-id=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectR

stat --format %s /tmp/xtextus-actionSelectR > /tmp/xtextus-actionSelectRBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionSelectR | sed 's/.*=//g' > /tmp/xtextus-idToSelectR
idToSelectR="$(cat /tmp/xtextus-idToSelectR)"

grep -n "ID=\"$idToSelectR\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectRBeginLine

nLineBeginIdToSelectR=$(cat /tmp/xtextus-idToSelectRBeginLine)

grep -n "<!-- end $idToSelectR -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectR=$(cat /tmp/xtextus-idToSelectREndLine)

echo $nLineEndIdToSelectR - $nLineBeginIdToSelectR | bc > /tmp/xtextus-linesToSelect

linesToSelectR=$(cat /tmp/xtextus-linesToSelect)

linesToSelectRPlusComment=$(($linesToSelectR + 1))

#echo "$nLineBeginIdToSelectR Gd$linesToSelectR
#ZZ

#" | sed 's/ //g' > /tmp/xtextus-blockToSelectR


#vim -s /tmp/xtextus-blockToSelectR $targetFile.lmx

#### Fine 'se dovessi rimuovere il blocco'.

### inizio modifica rispetto a remove
cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

#grep -n "<!-- end $idToSelectR -->" /tmp/xtextus-bloccoSelezionato.lmx | cut -d: -f1,1 > /tmp/xtextus-idToSelectREndLine

#echo " "
#echo "
#Prima linea da selezionare:
#$nLineBeginIdToSelectR testing
#real $realFirstLine testing

#Linee da selezionare:
#$linesToSelectR testing
#con commento finale $linesToSelectRPlusComment testing

#/tmp/xtextus-bloccoSelezionato.lmx testing
#" 

#read -p "testing 6392" EnterNull

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectRPlus=$(($linesToSelectR + 1))

echo  "$linesToSelectRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

gview -f /tmp/xtextus-bloccoSelezionato.lmx

break

fi






######### Select name block in read-only mode
grep "^--selectR-name=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectR-name

stat --format %s /tmp/xtextus-actionSelectR-name > /tmp/xtextus-actionSelectR-nameBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectR-nameBytes)

if test $leggoBytes -gt 0

then
	cat  /tmp/xtextus-actionSelectR-name | sed 's/.*=//g' > /tmp/xtextus-idToSelectR-name
	nameToSelect=$(cat /tmp/xtextus-idToSelectR-name)

/usr/local/bin/xmluxv --find-name="$nameToSelect" --f=$targetFile

grep "\"$nameToSelect\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToSelectR

idToSelectR="$(cat /tmp/xtextus-idToSelectR)"

grep -n "ID=\"$idToSelectR\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectRBeginLine

nLineBeginIdToSelectR=$(cat /tmp/xtextus-idToSelectRBeginLine)

grep -n "<!-- end $idToSelectR -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectR=$(cat /tmp/xtextus-idToSelectREndLine)

echo $nLineEndIdToSelectR - $nLineBeginIdToSelectR | bc > /tmp/xtextus-linesToSelect

linesToSelectR=$(cat /tmp/xtextus-linesToSelect)

linesToSelectRPlusComment=$(($linesToSelectR + 1))

cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectRPlus=$(($linesToSelectR + 1))

echo  "$linesToSelectRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato

vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

gview -f /tmp/xtextus-bloccoSelezionato.lmx


break

fi





######### Select title block in read-only mode
grep "^--selectR-title=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectR-title

stat --format %s /tmp/xtextus-actionSelectR-title > /tmp/xtextus-actionSelectR-titleBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionSelectR-title | sed 's/.*=//g' > /tmp/xtextus-idToSelectR-title
	titleToSelect=$(cat /tmp/xtextus-idToSelectR-title)

/usr/local/bin/xmluxv --find-title="$titleToSelect" --f=$targetFile

grep "$titleToSelect$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToSelectR

idToSelectR="$(cat /tmp/xtextus-idToSelectR)"

grep -n "ID=\"$idToSelectR\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectRBeginLine

nLineBeginIdToSelectR=$(cat /tmp/xtextus-idToSelectRBeginLine)

grep -n "<!-- end $idToSelectR -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectREndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectR=$(cat /tmp/xtextus-idToSelectREndLine)

echo $nLineEndIdToSelectR - $nLineBeginIdToSelectR | bc > /tmp/xtextus-linesToSelect

linesToSelectR=$(cat /tmp/xtextus-linesToSelect)

linesToSelectRPlusComment=$(($linesToSelectR + 1))

cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectRPlus=$(($linesToSelectR + 1))

echo  "$linesToSelectRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato

vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

gview -f /tmp/xtextus-bloccoSelezionato.lmx

break

fi

done

break

fi



grep "^--selectW" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectW

stat --format %s /tmp/xtextus-actionSelectW > /tmp/xtextus-actionSelectWBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectWBytes)

if test $leggoBytes -gt 0

then

	for selectW in {1}

	do

######### Select id block in write mode

grep "^--selectW-id=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectW

stat --format %s /tmp/xtextus-actionSelectW > /tmp/xtextus-actionSelectWBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectWBytes)

if test $leggoBytes -gt 0

then

	cat /tmp/xtextus-actionSelectW | sed 's/.*=//g' > /tmp/xtextus-idToSelectW

	idToSelectW="$(cat /tmp/xtextus-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xtextus-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectWEndLine

####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xtextus-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xtextus-linesToSelect

linesToSelectW=$(cat /tmp/xtextus-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

### inizio modifica rispetto a remove
cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectWPlus=$(($linesToSelectW + 1))

echo  "$linesToSelectWPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

gvim -f /tmp/xtextus-bloccoSelezionato.lmx

realFirstLine=$(($nLineBeginIdToSelectW - 1))

#cat $targetFile.lmx | sed -n '1,'$nLineBeginIdToSelectW'p' > /tmp/xtextus-targetFile-blocco_01.lmx

cat $targetFile.lmx | sed -n '1,'$realFirstLine'p' > /tmp/xtextus-targetFile-blocco_01.lmx

awk '{ nlines++;  print nlines }' $targetFile.lmx | tail -n1 > /tmp/xtextus-nLines

nLines=$(cat /tmp/xtextus-nLines)

cat $targetFile.lmx | sed -n ''$nLineEndIdToSelectW','$nLines'p' > /tmp/xtextus-targetFile-blocco_03.lmx

## composizione

cat /tmp/xtextus-targetFile-blocco_01.lmx /tmp/xtextus-bloccoSelezionato.lmx > /tmp/xtextus-targetFile-blocco_02.lmx

cat /tmp/xtextus-targetFile-blocco_02.lmx /tmp/xtextus-targetFile-blocco_03.lmx > /tmp/xtextus-targetFile-blocco_04.lmx

cp /tmp/xtextus-targetFile-blocco_04.lmx $targetFile.lmx

break

fi





######### Select name block in write mode
grep "^--selectW-name=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectW-name

stat --format %s /tmp/xtextus-actionSelectW-name > /tmp/xtextus-actionSelectW-nameBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectW-nameBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionSelectW-name | sed 's/.*=//g' > /tmp/xtextus-idToSelectW-name
	nameToSelect=$(cat /tmp/xtextus-idToSelectW-name)

/usr/local/bin/xmluxv --find-name="$nameToSelect" --f=$targetFile

grep "\"$nameToSelect\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToSelectW

idToSelectW="$(cat /tmp/xtextus-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xtextus-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectWEndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xtextus-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xtextus-linesToSelect

linesToSelectW=$(cat /tmp/xtextus-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
## Modifica 2024.09.24

#echo  "$linesToSelectW GdG
#ZZ

#" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato

linesToSelectWPlus=$(($linesToSelectW + 1))

echo  "$linesToSelectWPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato

vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

gvim -f /tmp/xtextus-bloccoSelezionato.lmx


realFirstLine=$(($nLineBeginIdToSelectW - 1))

#cat $targetFile.lmx | sed -n '1,'$nLineBeginIdToSelectW'p' > /tmp/xtextus-targetFile-blocco_01.lmx

cat $targetFile.lmx | sed -n '1,'$realFirstLine'p' > /tmp/xtextus-targetFile-blocco_01.lmx

awk '{ nlines++;  print nlines }' $targetFile.lmx | tail -n1 > /tmp/xtextus-nLines

nLines=$(cat /tmp/xtextus-nLines)

cat $targetFile.lmx | sed -n ''$nLineEndIdToSelectW','$nLines'p' > /tmp/xtextus-targetFile-blocco_03.lmx

## composizione

cat /tmp/xtextus-targetFile-blocco_01.lmx /tmp/xtextus-bloccoSelezionato.lmx > /tmp/xtextus-targetFile-blocco_02.lmx

cat /tmp/xtextus-targetFile-blocco_02.lmx /tmp/xtextus-targetFile-blocco_03.lmx > /tmp/xtextus-targetFile-blocco_04.lmx

cp /tmp/xtextus-targetFile-blocco_04.lmx $targetFile.lmx

break

fi





######### Select title block in read-only mode
grep "^--selectW-title=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionSelectW-title

stat --format %s /tmp/xtextus-actionSelectW-title > /tmp/xtextus-actionSelectW-titleBytes

leggoBytes=$(cat /tmp/xtextus-actionSelectW-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionSelectW-title | sed 's/.*=//g' > /tmp/xtextus-idToSelectW-title
	titleToSelect=$(cat /tmp/xtextus-idToSelectW-title)

/usr/local/bin/xmluxv --find-title="$titleToSelect" --f=$targetFile

grep "$titleToSelect$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToSelectW

idToSelectW="$(cat /tmp/xtextus-idToSelectW)"

grep -n "ID=\"$idToSelectW\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectWBeginLine

nLineBeginIdToSelectW=$(cat /tmp/xtextus-idToSelectWBeginLine)

grep -n "<!-- end $idToSelectW -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToSelectWEndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToSelectW=$(cat /tmp/xtextus-idToSelectWEndLine)

echo $nLineEndIdToSelectW - $nLineBeginIdToSelectW | bc > /tmp/xtextus-linesToSelect

linesToSelectW=$(cat /tmp/xtextus-linesToSelect)

linesToSelectWPlusComment=$(($linesToSelectW + 1))

cp $targetFile.lmx /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dalla I riga all'inizio del blocco da selezionare

echo $(($nLineBeginIdToSelectW - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato


vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToSelectWPlus=$(($linesToSelectW + 1))

echo  "$linesToSelectWPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato.lmx

gvim -f /tmp/xtextus-bloccoSelezionato.lmx

realFirstLine=$(($nLineBeginIdToSelectW - 1))

#cat $targetFile.lmx | sed -n '1,'$nLineBeginIdToSelectW'p' > /tmp/xtextus-targetFile-blocco_01.lmx

cat $targetFile.lmx | sed -n '1,'$realFirstLine'p' > /tmp/xtextus-targetFile-blocco_01.lmx

awk '{ nlines++;  print nlines }' $targetFile.lmx | tail -n1 > /tmp/xtextus-nLines

nLines=$(cat /tmp/xtextus-nLines)

cat $targetFile.lmx | sed -n ''$nLineEndIdToSelectW','$nLines'p' > /tmp/xtextus-targetFile-blocco_03.lmx

## composizione

cat /tmp/xtextus-targetFile-blocco_01.lmx /tmp/xtextus-bloccoSelezionato.lmx > /tmp/xtextus-targetFile-blocco_02.lmx

cat /tmp/xtextus-targetFile-blocco_02.lmx /tmp/xtextus-targetFile-blocco_03.lmx > /tmp/xtextus-targetFile-blocco_04.lmx

cp /tmp/xtextus-targetFile-blocco_04.lmx $targetFile.lmx

break

fi

done

break

fi


############### ACTION PARSE

grep "^--parse" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionParse

stat --format %s /tmp/xtextus-actionParse > /tmp/xtextus-actionParseBytes

leggoBytes=$(cat /tmp/xtextus-actionParseBytes)

if test $leggoBytes -gt 0

then

/usr/local/lib/xmlux/xtextusScripts/parse/parse.sh

break

fi


############## ACTION RENDER

grep "^--render" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionRender

stat --format %s /tmp/xtextus-actionRender > /tmp/xtextus-actionRenderBytes

leggoBytes=$(cat /tmp/xtextus-actionRenderBytes)

if test $leggoBytes -gt 0

then

	for render in {1}

	do

######### Render id block
grep "^--renderCss-id=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionRenderedR

stat --format %s /tmp/xtextus-actionRenderedR > /tmp/xtextus-actionRenderedRBytes

leggoBytes=$(cat /tmp/xtextus-actionRenderedRBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionRenderedR | sed 's/.*=//g' > /tmp/xtextus-idToRenderedR

	idToRenderedR="$(cat /tmp/xtextus-idToRenderedR)"


	## Invece di intervenire sul codice lmx, lavoro direttament sul xml.
#	grep -n "ID=\"$idToRenderedR\"" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToRenderedRBeginLine

#nLineBeginIdToRenderedR=$(cat /tmp/xtextus-idToRenderedRBeginLine)

#grep -n "<!-- end $idToRenderedR -->" /tmp/xtextus-css000 | cut -d: -f1,1 > /tmp/xtextus-idToRenderedREndLine

	
	grep -n "ID=\"$idToRenderedR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xtextus-idToRenderedRBeginLine

nLineBeginIdToRenderedR=$(cat /tmp/xtextus-idToRenderedRBeginLine)

grep -n "<!-- end $idToRenderedR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xtextus-idToRenderedREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderedR=$(cat /tmp/xtextus-idToRenderedREndLine)

echo $nLineEndIdToRenderedR - $nLineBeginIdToRenderedR | bc > /tmp/xtextus-linesToRendered

linesToRenderedR=$(cat /tmp/xtextus-linesToRendered)

linesToRenderedRPlusComment=$(($linesToRenderedR + 1))


## Rimuovo dalla I riga all'inizio del blocco da selezionare
echo $(($nLineBeginIdToRenderedR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xtextus-bloccoSelezionato

vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato

## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToRenderedRPlus=$(($linesToRenderedR + 1))

echo  "$linesToRenderedRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xtextus-intestazione

cat /tmp/xtextus-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xtextus-intestazione01

cp /tmp/xtextus-intestazione01 /tmp/xtextus-intestazione


/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xtextus-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xtextus-notKin_elements

vim -s /tmp/xtextus-commandDelFirstEtLastLine /tmp/xtextus-notKin_elements



cat /tmp/xtextus-notKin_elements | sed '/^$/d' | uniq > /tmp/xtextus-ToCTree

grep "$idToRenderedR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-relativeElement

element=$(cat /tmp/xtextus-relativeElement)
 

cat /tmp/xtextus-ToCTree | grep -B 1000 "$element" > /tmp/xtextus-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xtextus-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xtextus-commandDelLastLine /tmp/xtextus-ToCStructure

rm -fr /tmp/xtextus-ToCStructureSplit

mkdir  /tmp/xtextus-ToCStructureSplit

split -l1 /tmp/xtextus-ToCStructure /tmp/xtextus-ToCStructureSplit/

declare -i var=0

for tocStructure in $(ls /tmp/xtextus-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xtextus-ToCStructureSplit/$tocStructure)

	if test "$leggoToC" == "synopsis"

	then
	
	echo "<$leggoToC>" >> /tmp/xtextus-intestazione
	echo "</$leggoToC>" >> /tmp/xtextus-intestazione

	else

	echo "<$leggoToC>" >> /tmp/xtextus-intestazione

	echo "$leggoToC" > /tmp/xtextus-inverseOrderToC-$var

	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xtextus-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xtextus-inverseOrderToC-$var /tmp/xtextus-inverseOrder-$VarMenoUno > /tmp/xtextus-inverseOrder-$var

		else
			cat /tmp/xtextus-inverseOrderToC-$var > /tmp/xtextus-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xtextus-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xtextus-inverseOrderToC-'n' per la synopsis.
done

rm -fr /tmp/xtextus-inverseOrderToCSplit

mkdir /tmp/xtextus-inverseOrderToCSplit

ls /tmp/xtextus-inverseOrder-* | tail -n1 > /tmp/xtextus-inverseOrder-finalLs

cat /tmp/xtextus-inverseOrder-finalLs > /tmp/xtextus-inverseOrder-final

inversedOrder=$(cat /tmp/xtextus-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xtextus-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xtextus-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xtextus-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xtextus-bloccoSelezionato

done

cat /tmp/xtextus-intestazione /tmp/xtextus-bloccoSelezionato > /tmp/xtextus-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xtextus

mkdir /tmp/renderCss-xtextus

cp -r . /tmp/renderCss-xtextus/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xtextus/*.back

rm /tmp/renderCss-xtextus/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xtextus/*.dtd

rm /tmp/renderCss-xtextus/*.xml

rm /tmp/renderCss-xtextus/*.lmx

rm -f /tmp/renderCss-xtextus/*.lmxv

rm -fr /tmp/renderCss-xtextus/*lmxv*

rm /tmp/renderCss-xtextus/*.lmxp

rm -f /tmp/renderCss-xtextus/*.lmxe

cp /tmp/xtextus-bloccoSelezionatoIntestato /tmp/renderCss-xtextus/renderedCss.xml

### Dev: con la sottostante istanza, annullo le impostazioni css della sinossi
## cat $targetFile.css | sed 's/Synopsis*.*//g' > /tmp/renderCss-xtextus/renderedCss.css

#else

cp $targetFile.css /tmp/renderCss-xtextus/renderedCss.css

#fi


#cd /tmp/renderCss-xtextus

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xtextus/parsing/parsingChoice.java

scelta=$(cat /tmp/xtextus-parsingChoice)

for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xtextus/renderedCss.xml

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xtextus/parsing/parsingPath.java

path=$(cat /tmp/xtextus-parsingPath)

cp /tmp/renderCss-xtextus/renderedCss.xml $path
cp /tmp/renderCss-xtextus/renderedCss.css $path
sync

break
fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xtextus/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xtextus/parsing/parsingPath.java

path=$(cat /tmp/xtextus-parsingPath)

cp /tmp/renderCss-xtextus/renderedCss.xml $path
cp /tmp/renderCss-xtextus/renderedCss.css $path
sync

break

fi

done

break

fi

######### Render name block
grep "^--renderCss-name=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionRenderedR-name

stat --format %s /tmp/xtextus-actionRenderedR-name > /tmp/xtextus-actionRenderedR-nameBytes

leggoBytes=$(cat /tmp/xtextus-actionRenderedR-nameBytes)

if test $leggoBytes -gt 0

then
	cat  /tmp/xtextus-actionRenderedR-name | sed 's/.*=//g' > /tmp/xtextus-idToRenderedR-name
	nameToRendered=$(cat /tmp/xtextus-idToRenderedR-name)

/usr/local/bin/xmluxv -s --find-name="$nameToRendered" --f=$targetFile

grep "\"$nameToRendered\"" $targetFile-lmxv/kin/$targetFile-ids-names.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToRenderedR

idToRenderedR="$(cat /tmp/xtextus-idToRenderedR)"

	grep -n "ID=\"$idToRenderedR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xtextus-idToRenderedRBeginLine

nLineBeginIdToRenderedR=$(cat /tmp/xtextus-idToRenderedRBeginLine)

grep -n "<!-- end $idToRenderedR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xtextus-idToRenderedREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderedR=$(cat /tmp/xtextus-idToRenderedREndLine)

echo $nLineEndIdToRenderedR - $nLineBeginIdToRenderedR | bc > /tmp/xtextus-linesToRendered

linesToRenderedR=$(cat /tmp/xtextus-linesToRendered)

linesToRenderedRPlusComment=$(($linesToRenderedR + 1))



## Rimuovo dalla I riga all'inizio del blocco da selezionare
echo $(($nLineBeginIdToRenderedR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xtextus-bloccoSelezionato

vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato


## Rimuovo dall'ultima riga del blocco da selezionare, all'ultima riga del contenuto originale
linesToRenderedRPlus=$(($linesToRenderedR + 1))

echo  "$linesToRenderedRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xtextus-intestazione

cat /tmp/xtextus-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xtextus-intestazione01

cp /tmp/xtextus-intestazione01 /tmp/xtextus-intestazione



/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xtextus-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xtextus-notKin_elements

vim -s /tmp/xtextus-commandDelFirstEtLastLine /tmp/xtextus-notKin_elements



cat /tmp/xtextus-notKin_elements | sed '/^$/d' | uniq > /tmp/xtextus-ToCTree

grep "$idToRenderedR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-relativeElement

element=$(cat /tmp/xtextus-relativeElement)
 

cat /tmp/xtextus-ToCTree | grep -B 1000 "$element" > /tmp/xtextus-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xtextus-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xtextus-commandDelLastLine /tmp/xtextus-ToCStructure

rm -fr /tmp/xtextus-ToCStructureSplit

mkdir  /tmp/xtextus-ToCStructureSplit

split -l1 /tmp/xtextus-ToCStructure /tmp/xtextus-ToCStructureSplit/

declare -i var=0

for tocStructure in $(ls /tmp/xtextus-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xtextus-ToCStructureSplit/$tocStructure)

	if test "$leggoToC" == "synopsis"

	then
	
	echo "<$leggoToC>" >> /tmp/xtextus-intestazione
	echo "</$leggoToC>" >> /tmp/xtextus-intestazione

	else

	echo "<$leggoToC>" >> /tmp/xtextus-intestazione

	echo "$leggoToC" > /tmp/xtextus-inverseOrderToC-$var


	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xtextus-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xtextus-inverseOrderToC-$var /tmp/xtextus-inverseOrder-$VarMenoUno > /tmp/xtextus-inverseOrder-$var

		else
			cat /tmp/xtextus-inverseOrderToC-$var > /tmp/xtextus-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xtextus-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xtextus-inverseOrderToC-'n' per la synopsis.
done

rm -fr /tmp/xtextus-inverseOrderToCSplit

mkdir /tmp/xtextus-inverseOrderToCSplit

ls /tmp/xtextus-inverseOrder-* | tail -n1 > /tmp/xtextus-inverseOrder-finalLs

cat /tmp/xtextus-inverseOrder-finalLs > /tmp/xtextus-inverseOrder-final

inversedOrder=$(cat /tmp/xtextus-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xtextus-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xtextus-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xtextus-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xtextus-bloccoSelezionato

done


cat /tmp/xtextus-intestazione /tmp/xtextus-bloccoSelezionato > /tmp/xtextus-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xtextus

mkdir /tmp/renderCss-xtextus

cp -r . /tmp/renderCss-xtextus/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xtextus/*.back

rm /tmp/renderCss-xtextus/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xtextus/*.dtd

rm /tmp/renderCss-xtextus/*.xml

rm /tmp/renderCss-xtextus/*.lmx

rm -f /tmp/renderCss-xtextus/*.lmxv

rm -fr /tmp/renderCss-xtextus/*lmxv*

rm /tmp/renderCss-xtextus/*.lmxp

rm -f /tmp/renderCss-xtextus/*.lmxe

cp /tmp/xtextus-bloccoSelezionatoIntestato /tmp/renderCss-xtextus/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xtextus/renderedCss.css


#cd /tmp/renderCss-xtextus

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xtextus/parsing/parsingChoice.java

scelta=$(cat /tmp/xtextus-parsingChoice)

for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xtextus/renderedCss.xml

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xtextus/parsing/parsingPath.java

path=$(cat /tmp/xtextus-parsingPath)

cp /tmp/renderCss-xtextus/renderedCss.xml $path
cp /tmp/renderCss-xtextus/renderedCss.css $path
sync

break
fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xtextus/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xtextus/parsing/parsingPath.java

path=$(cat /tmp/xtextus-parsingPath)
	

cp /tmp/renderCss-xtextus/renderedCss.xml $path
cp /tmp/renderCss-xtextus/renderedCss.css $path
sync

break

fi

done

break

fi

######### Render title block
grep "^--renderCss-title=" /tmp/xtextusPseudoOptions/* > /tmp/xtextus-actionRenderedR-title

stat --format %s /tmp/xtextus-actionRenderedR-title > /tmp/xtextus-actionRenderedR-titleBytes

leggoBytes=$(cat /tmp/xtextus-actionRenderedR-titleBytes)

if test $leggoBytes -gt 0

then
	cat /tmp/xtextus-actionRenderedR-title | sed 's/.*=//g' > /tmp/xtextus-idToRenderedR-title
	titleToRendered=$(cat /tmp/xtextus-idToRenderedR-title)

/usr/local/bin/xmluxv -s --find-title="$titleToRendered" --f=$targetFile

grep "$titleToRendered$" $targetFile-lmxv/kin/$targetFile-ids-titles.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-idToRenderedR

idToRenderedR="$(cat /tmp/xtextus-idToRenderedR)"
	grep -n "ID=\"$idToRenderedR\"" $targetFile.xml | cut -d: -f1,1 > /tmp/xtextus-idToRenderedRBeginLine

nLineBeginIdToRenderedR=$(cat /tmp/xtextus-idToRenderedRBeginLine)

grep -n "<!-- end $idToRenderedR -->" $targetFile.xml | cut -d: -f1,1 > /tmp/xtextus-idToRenderedREndLine


####### Se dovessi rimuovere il blocco, invece io devo selezionarlo
nLineEndIdToRenderedR=$(cat /tmp/xtextus-idToRenderedREndLine)

echo $nLineEndIdToRenderedR - $nLineBeginIdToRenderedR | bc > /tmp/xtextus-linesToRendered

linesToRenderedR=$(cat /tmp/xtextus-linesToRendered)

linesToRenderedRPlusComment=$(($linesToRenderedR + 1))

echo $(($nLineBeginIdToRenderedR - 2)) > /tmp/xtextus-realFirstLine

realFirstLine=$(cat /tmp/xtextus-realFirstLine)

echo  "1 Gd$realFirstLine
ZZ

" | sed 's/ //g' > /tmp/xtextus-command01-bloccoSelezionato

cp $targetFile.xml /tmp/xtextus-bloccoSelezionato

vim -s /tmp/xtextus-command01-bloccoSelezionato /tmp/xtextus-bloccoSelezionato

linesToRenderedRPlus=$(($linesToRenderedR + 1))

echo  "$linesToRenderedRPlus GdG
ZZ

" | sed 's/ //g' > /tmp/xtextus-command02-bloccoSelezionato


vim -s /tmp/xtextus-command02-bloccoSelezionato /tmp/xtextus-bloccoSelezionato

## dall'inizio a <!-- begin radix -->
cat $targetFile.xml | head -n6 | sed 's/'$targetFile'/renderedCss/g' >  /tmp/xtextus-intestazione

cat /tmp/xtextus-intestazione | sed 's/standalone="no"/standalone="yes"/g' | sed '/\.dtd/d' > /tmp/xtextus-intestazione01

cp /tmp/xtextus-intestazione01 /tmp/xtextus-intestazione


/usr/local/bin/xmluxv -s -ie --f=$targetFile 

echo  "1GddGdd
ZZ

" > /tmp/xtextus-commandDelFirstEtLastLine

cp $targetFile-lmxv/notKin/$targetFile-notKin_elements.lmxv /tmp/xtextus-notKin_elements

vim -s /tmp/xtextus-commandDelFirstEtLastLine /tmp/xtextus-notKin_elements


cat /tmp/xtextus-notKin_elements | sed '/^$/d' | uniq > /tmp/xtextus-ToCTree

grep "$idToRenderedR$" $targetFile-lmxv/notKin/$targetFile-notKin_elements-ids.lmxv | awk '$1 > 0 {print $1}' > /tmp/xtextus-relativeElement

element=$(cat /tmp/xtextus-relativeElement)
 

cat /tmp/xtextus-ToCTree | grep -B 1000 "$element" > /tmp/xtextus-ToCStructure

echo  "Gdd
ZZ

" > /tmp/xtextus-commandDelLastLine

## per non ripetere l'elemento
vim -s /tmp/xtextus-commandDelLastLine /tmp/xtextus-ToCStructure

rm -fr /tmp/xtextus-ToCStructureSplit

mkdir  /tmp/xtextus-ToCStructureSplit

split -l1 /tmp/xtextus-ToCStructure /tmp/xtextus-ToCStructureSplit/

declare -i var=0
for tocStructure in $(ls /tmp/xtextus-ToCStructureSplit)

do

	var=var+1

	leggoToC=$(cat /tmp/xtextus-ToCStructureSplit/$tocStructure)

	if test "$leggoToC" == "synopsis"

	then
	
	echo "<$leggoToC>" >> /tmp/xtextus-intestazione
	echo "</$leggoToC>" >> /tmp/xtextus-intestazione

	else

	echo "<$leggoToC>" >> /tmp/xtextus-intestazione

	echo "$leggoToC" > /tmp/xtextus-inverseOrderToC-$var


	fi	
	VarMenoUno=$(($var - 1))

	if [ -f /tmp/xtextus-inverseOrder-$VarMenoUno ]; then
	
		cat /tmp/xtextus-inverseOrderToC-$var /tmp/xtextus-inverseOrder-$VarMenoUno > /tmp/xtextus-inverseOrder-$var

		else
			cat /tmp/xtextus-inverseOrderToC-$var > /tmp/xtextus-inverseOrder-$var
	fi

	## L'eventuale errore /tmp/xtextus-inverseOrderToC-'n' è ininfluente, si riferisce a quando salto
	# la scrittura di /tmp/xtextus-inverseOrderToC-'n' per la synopsis.
done


rm -fr /tmp/xtextus-inverseOrderToCSplit

mkdir /tmp/xtextus-inverseOrderToCSplit

ls /tmp/xtextus-inverseOrder-* | tail -n1 > /tmp/xtextus-inverseOrder-finalLs

cat /tmp/xtextus-inverseOrder-finalLs > /tmp/xtextus-inverseOrder-final

inversedOrder=$(cat /tmp/xtextus-inverseOrder-final) 

split -l1 $inversedOrder /tmp/xtextus-inverseOrderToCSplit/
	

for inverseToCStructure in $(ls /tmp/xtextus-inverseOrderToCSplit)

do
	leggoinverseToC=$(cat /tmp/xtextus-inverseOrderToCSplit/$inverseToCStructure)


echo "</$leggoinverseToC>" >> /tmp/xtextus-bloccoSelezionato

done

cat /tmp/xtextus-intestazione /tmp/xtextus-bloccoSelezionato > /tmp/xtextus-bloccoSelezionatoIntestato

rm -fr /tmp/renderCss-xtextus

mkdir /tmp/renderCss-xtextus

cp -r . /tmp/renderCss-xtextus/

## in questo modo copio eventuali immagini da caricare

rm /tmp/renderCss-xtextus/*.back

rm /tmp/renderCss-xtextus/*.css

## In questa versione di xmlux non offro il file render con il *.dtd,
# per creare il file *.dtd devo seguire la via più lunga.
# Ossia, estrarre il contenuto come faccio con selectR;
# aprire e chiudere gli elementi [ma specificando <!-- end 'ID --> stavolta]
# -- visto che non sto estraendo da un file xml --, e compilare il nuovo file ottenuto.
# Se invece seguissi la via più veloce, potrei manipolare il file *.dtd originario, in base al nuovo xml.
# Ora non ho tempo.
rm /tmp/renderCss-xtextus/*.dtd

rm /tmp/renderCss-xtextus/*.xml

rm /tmp/renderCss-xtextus/*.lmx

rm -f /tmp/renderCss-xtextus/*.lmxv

rm -fr /tmp/renderCss-xtextus/*lmxv*

rm /tmp/renderCss-xtextus/*.lmxp

rm -f /tmp/renderCss-xtextus/*.lmxe

cp /tmp/xtextus-bloccoSelezionatoIntestato /tmp/renderCss-xtextus/renderedCss.xml

cp $targetFile.css /tmp/renderCss-xtextus/renderedCss.css


#cd /tmp/renderCss-xtextus

#/usr/local/bin/xmluxc --f=renderedCss

#cd $posnow
java /usr/local/lib/xmlux/java/xtextus/parsing/parsingChoice.java

scelta=$(cat /tmp/xtextus-parsingChoice)


for choose in {1}

do

if test $scelta -eq 1

then
	chromium /tmp/renderCss-xtextus/renderedCss.xml

	break
fi

if test $scelta -eq 2

then

java /usr/local/lib/xmlux/java/xtextus/parsing/parsingPath.java

path=$(cat /tmp/xtextus-parsingPath)

cp /tmp/renderCss-xtextus/renderedCss.xml $path
cp /tmp/renderCss-xtextus/renderedCss.css $path
sync

break
fi

if test $scelta -eq 3

then

chromium /tmp/renderCss-xtextus/renderedCss.xml

clear

java /usr/local/lib/xmlux/java/xtextus/parsing/parsingPath.java

path=$(cat /tmp/xtextus-parsingPath)

cp /tmp/renderCss-xtextus/renderedCss.xml $path
cp /tmp/renderCss-xtextus/renderedCss.css $path
sync

fi

done

break

fi

done

fi

done


exit


