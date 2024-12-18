#!/bin/bash

## Mario Fantini ing.mariofantini@gmail.com
## Copyright:
## Copyright (C) 2023.09.23 Mario Fantini (ing.mariofantini@gmail.com).
## Bash copyright applies to its Mario Fantini's BASH usage.
## GNU copyright applies to its Mario Fantini's GNU tools usage.
## XML copyright applies to its Mario Fantini's XML tools usage.
## VIM copyright applies to its Mario Fantini's VIM usage.
## Java copyright applies to its Mario Fantini's JAVA tools usage.
## And so on.

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You have received a copy of the GNU General Public License
## along with this program in README/COPYING. 
## Aka see <https://www.gnu.org/licenses/>.


path="/usr/local/lib/xmlux"

dir_doc="/usr/local/share/doc"


echo $USER > /tmp/curuserechoed.txt


curuser=$(cat /tmp/curuserechoed.txt)


sudo mkdir /usr/local/lib/xmlux

sudo cp -r . /usr/local/lib/xmlux

#### prima di sfasare con le proprietà e i permessi, sistemo netrw e qcad; tanto
### poi saranno assegnati anche a loro le giuste proprietà e i giusti permessi
## Sintassi e colorazione per netrw

sudo chown -R root:$curuser /usr/local/lib/xmlux/

sudo chmod -R uga+xrw /usr/local/lib/xmlux/

## Proprietà e permessi

## creo il gruppo backemerg
sudo groupadd xmlux

## aggiungo il corrente utente al gruppo xmlux 
sudo gpasswd --add $curuser xmlux

sudo cp xmlux.sh /usr/local/bin/xmlux

sudo cp xmluxc.sh /usr/local/bin/xmluxc

sudo cp xmluxe.sh /usr/local/bin/xmluxe

sudo cp xmluxv.sh /usr/local/bin/xmluxv


sudo chown root:xmlux /usr/local/bin/xmlux
sudo chmod a-xwr /usr/local/bin/xmlux
sudo chmod o-xwr /usr/local/bin/xmlux
sudo chmod ug+xr /usr/local/bin/xmlux

sudo chown root:xmlux /usr/local/bin/xmluxc
sudo chmod a-xwr /usr/local/bin/xmluxc
sudo chmod o-xwr /usr/local/bin/xmluxc
sudo chmod ug+xr /usr/local/bin/xmluxc

sudo chown root:xmlux /usr/local/bin/xmluxe
sudo chmod a-xwr /usr/local/bin/xmluxe
sudo chmod o-xwr /usr/local/bin/xmluxe
sudo chmod ug+xr /usr/local/bin/xmluxe

sudo chown root:xmlux /usr/local/bin/xmluxv
sudo chmod a-xwr /usr/local/bin/xmluxv
sudo chmod o-xwr /usr/local/bin/xmluxv
sudo chmod ug+xr /usr/local/bin/xmluxv


sudo mkdir $dir_doc/xmlux

sudo cp -r README/ /usr/local/share/doc/xmlux

sudo rm -r /usr/local/lib/xmlux/README

sudo chown -R root:xmlux /usr/local/share/doc/xmlux
sudo chmod -R a-xrw /usr/local/share/doc/xmlux
sudo chmod -R o-xrw /usr/local/share/doc/xmlux
sudo chmod -R ug+xrw /usr/local/share/doc/xmlux

sudo cp /usr/local/lib/xmlux/xtextus/xtextus.sh /usr/local/bin/xtextus
sudo chown root:xmlux /usr/local/bin/xtextus
sudo chmod uga+xr /usr/local/bin/xtextus
sudo chmod o-xwr /usr/local/bin/xtextus

sudo chown -R root:xmlux /usr/local/lib/xmlux

sudo chmod -R uga+xrw /usr/local/lib/xmlux

sudo chmod -R o-xrw /usr/local/lib/xmlux


if [ ! -d /home/$USER/.vim/vimScript/ ]; then

mkdir /home/$USER/.vim/vimScript/

sudo chown -R $USER:xmlux /home/$USER/.vim/vimScript/

sudo chmod -R uga+xrw /home/$USER/.vim/vimScript/

fi

mkdir /home/$USER/.vim/vimScript/xmlux 2> /dev/null

#sudo cp -r /usr/local/lib/xmlux/alearchiver/vimScript/* /home/$USER/.vim/vimScript/xmlux

#sudo chown -R $USER:xmlux /home/$USER/.vim/vimScript/

#sudo chmod -R uga+xr /home/$USER/.vim/vimScript/xmlux


echo -e "\033[35;40;5m\033[1m riavvia il pc  \033[0m"

exit

