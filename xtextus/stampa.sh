#!/bin/bash



############# le << \ \ \ >> rappresentano gli spazi negli header
#### aggiungine o rimuovine a piacimento secondo le tue esigenze
### se non ti va bene quella assegnata di default.

#### Aggiungi se vuoi anche altre opzioni
###### i.e.
#### formato A4,
#### margini dx (20mm), sx(15mm), alto(10mm) e basso(30mm), fronte-retro(long)
##
### :set printoptions=paper:A4,righ:20mm,left:15mm,top:10mm,bottom:30mm,duplex:long
###  
### Altro su:
### :help hardcopy

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

tOrig=$(cat /tmp/xtextus-tOrig-per-stampa)

targetFile=$(cat /tmp/xtextus-TargetFilePre)

break

fi

done

pathIsolato=$(cat /tmp/xmlux-percorsoIsolato)

nomeSenzaEstensione=$(cat /tmp/xmlux-nomeSenzaEstensione)


###### Headers e altre impostazioni di stampa


read -p "
Hai queste possibilità:

1. Numerazione pagina
   Per l'eventuale formattazione personalizzata modifica il  contenuto
   di echo del condizionale n.1:

   in caso di tuoi disastri puoi ristabilire il suddetto file in  base
   a:
   /usr/local/lib/xmlux/xtextus/headers/pageNumber


2. Titolo e numerazione pagina 
   In	automatico   ma   da	te    personalizzabile	  sia	 nella
   formattazione --  titolo  più  a  sx  o  al	centro	o  più	a  dx,
   ugualmente  per  la	 numerazione   delle   pagine	--   sia   nel
   titolo   se	 non   vuoi    automaticamente	  esso	  come	  nome
   del file.  Se vuoi modifica il contenuto di echo  del  condizionale
   n. 2.

   in caso di tuoi disastri puoi ristabilire il suddetto file in  base
   a:
   /usr/local/lib/xmlux/xtextus/headers/titlePageNumber


3. Formattazione di default 
   (nome del file a sx, numero  della pagina a dx). 
   Questa è la soluzione più  veloce  quando  hai  un  file  dal  nome
   accettabile, umano.	Considera che  tutti  i  miei  tool  non  sono
   pensati per file con spazi tra parole del nome, quindi  se  volessi
   un titolo con spazi tra parole e/o  numeri  dovresti  scegliere  la
   scelta n. 2. 


4. Header nullo: né titolo né numerazione della pagina
   

:" sceltaHeader

if test $sceltaHeader == 1
 then
  echo ":set printheader:\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \%N
:so /etc/vim/gvimrc.local
:hardcopy > $pathIsolato/$nomeSenzaEstensione.ps
ZZ" > /tmp/xmlux-command-print
 
gvim -s /tmp/xmlux-command-print $tOrig
fi


if test $sceltaHeader == 2
 then
  echo ":set printheader:\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ $nomeSenzaEstensione\ \%N
:so /etc/vim/gvimrc.local
:hardcopy > $pathIsolato/$nomeSenzaEstensione.ps
ZZ" > /tmp/xmlux-command-print

  gvim -s /tmp/xmlux-command-print $tOrig
fi


if test $sceltaHeader == 3
 then
  echo ":so /etc/vim/gvimrc.local
:hardcopy > $pathIsolato/$nomeSenzaEstensione.ps
ZZ" > /tmp/xmlux-command-print
  gvim -s /tmp/xmlux-command-print $tOrig
fi



if test $sceltaHeader == 4
 then
  echo ":set printoptions=header:0
:so /etc/vim/gvimrc.local
:hardcopy > $pathIsolato/$nomeSenzaEstensione.ps
ZZ" > /tmp/xmlux-command-print
  gvim -s /tmp/xmlux-command-print $tOrig
fi


/usr/local/lib/xmlux/xtextus/stampa2.sh



rm /tmp/xmlux-command-print


exit


