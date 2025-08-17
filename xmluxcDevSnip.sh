
### 526
# comandi, ambienti e gruppi

grep "^\\\begin{" | awk '$1 > 0 {print $1}' | sed 's/\\begin{//g' | sed 's/}//g' > /tmp/xmluxc-begin

stat --format %s /tmp/xmluxc-begin > /tmp/xmluxc-beginBytes

leggoBytes=$(cat /tmp/xmluxc-beginBytes)

if test $leggoBytes -gt 0

then

mkdir /tmp/xmluxc-beginSplit

split -l1 /tmp/xmluxc-begin /tmp/xmluxc-beginSplit/

for a in $(ls /tmp/xmluxc-beginSplit/)

do

leggoBegin="$(cat /tmp/xmluxc-beginSplit/$a)"

grep -n "\\\begin{$leggoBegin" $targetFile.lmx > /tmp/xmluxc-beginNLine

leggoInizio=$(cat /tmp/xmluxc-beginNLine)

grep -n "\\\end{$leggoBegin" $targetFile.lmx > /tmp/xmluxc-endNLine

leggoFine=$(cat /tmp/xmluxc-endNLine)


find /usr/local/lib/xmlux/ -name $leggoBegin.vim > /tmp/xmluxc-beginVim

leggoVimScript="$(cat /tmp/xmluxc-beginVim)"

vim -c ":%s/%/$leggoInizio,$leggoInizio/g" $leggoVimScript -c :w -c :q

cp $leggoVimScript /home/$USER/.vim/vimScript/xmlux

vim -c ":runtime! vimScript/xmlux/$leggoVimScript" -c ":cal $leggoBegin#$leggoBegin()" $targetFile.lmxp -c :w -c :q

done

fi

