#!/bin/bash

targetFile="$(cat /tmp/xmluxcTargetFile)"

leggoGroup="$(cat /tmp/xmluxc-GroupsNameOrder)"

leggoInizio=$(cat /tmp/xmluxc-GroupsStartOrder)

leggoFine=$(cat /tmp/xmluxc-GroupsEndOrder)


cat /tmp/xmluxc-GroupsNameOrder | tr a-z A-Z > /tmp/xmluxc-startFunMaiuscolo

leggoFunMaiuscolo="$(cat /tmp/xmluxc-startFunMaiuscolo)"

## Opzioni

## per addTab ho solo un opzione, il numero n di tab e.g. \start{ÆddTab}[1]
leggoOption="n"



### Verifico se è stata espressa l'opzione, facoltativa, se non espressa essa si suppone [1].

if [ -f /tmp/xmluxc-GroupsNameWithOption ]; then

## per ora fornisco solo 4 tab
cat /tmp/xmluxc-GroupsNameWithOption | sed 's/.*\[//g' | sed 's/\]//g' > /tmp/xmluxc-addTabOptionValue

leggoOptionValue=$(cat /tmp/xmluxc-addTabOptionValue)

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/addTab/vimFun/$leggoOption/$leggoOptionValue/ADDTAB.vim /home/$USER/.vim/vimScript/xmlux

vim -c ":%s/%/$leggoInizio,$leggoFine/g" /home/$USER/.vim/vimScript/xmlux/$leggoFunMaiuscolo.vim -c :w -c :q

vim -c ":runtime! vimScript/xmlux/$leggoFunMaiuscolo.vim" -c ":cal $leggoFunMaiuscolo#$leggoFunMaiuscolo()" $targetFile.lmxp -c :w -c :q

else

cp /usr/local/lib/xmlux/xmluxcGroups/paragraph/addTab/vimFun/$leggoOption/1/ADDTAB.vim /home/$USER/.vim/vimScript/xmlux

vim -c ":%s/%/$leggoInizio,$leggoFine/g" /home/$USER/.vim/vimScript/xmlux/$leggoFunMaiuscolo.vim -c :w -c :q

vim -c ":runtime! vimScript/xmlux/$leggoFunMaiuscolo.vim" -c ":cal $leggoFunMaiuscolo#$leggoFunMaiuscolo()" $targetFile.lmxp -c :w -c :q

fi

rm /home/$USER/.vim/vimScript/xmlux/$leggoFunMaiuscolo.vim


exit

