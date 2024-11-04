#!/bin/bash

pathIsolato=$(cat /tmp/xmlux-percorsoIsolato)

nomeSenzaEstensione=$(cat /tmp/xmlux-nomeSenzaEstensione)

ps2pdf $pathIsolato/$nomeSenzaEstensione.ps $pathIsolato/$nomeSenzaEstensione.pdf 

echo "
Hai
$pathIsolato/$nomeSenzaEstensione.ps
$pathIsolato/$nomeSenzaEstensione.pdf

"
echo " "

rm -f /tmp/xmlux-IVoutPreExsistence /tmp/xmlux-exsistence

rm -f -r splitFiles

rm -f /tmp/xmlux-Iout /tmp/xmlux-IIout /tmp/xmlux-IIIout /tmp/xmlux-IVout /tmp/xmlux-colC.txt /tmp/xmlux-match /tmp/xmlux-matchAwked /tmp/xmlux-matchWc /tmp/xmlux-nomeFile.txt

rm -f /tmp/xmlux-Vout /tmp/xmlux-VIout /tmp/xmlux-VIIout /tmp/xmlux-stampaNome /tmp/xmlux-grepped /tmp/xmlux-statted

rm -f /tmp/xmlux-extractedName

rm -f /tmp/xmlux-progHack-GenericTxtConverted-log.txt

rm -f /tmp/xmlux-B2preint

rm -f /tmp/xmlux-Bpreint

rm -f /tmp/xmlux-chiusuraIstanzaAwk

rm -f /tmp/xmlux-colonnePathIsolato

rm -f /tmp/xmlux-curuserechoed.txt

rm -f /tmp/xmlux-fullNameBackup

rm -f /tmp/xmlux-intervallo

rm -f /tmp/xmlux-intestazione.edr

rm -f /tmp/xmlux-Ipezzo.txt

rm -f /tmp/xmlux-istanzaAwk

rm -f /tmp/xmlux-motherheaders.hedr

rm -f /tmp/xmlux-nomeFileIsolato

rm -f /tmp/xmlux-nomeSenzaEstensione

rm -f /tmp/xmlux-path

rm -f /tmp/xmlux-percorsoBlanked

rm -f /tmp/xmlux-percorsoIsolato

rm -f /tmp/xmlux-prefisso

rm -f /tmp/xmlux-preint /tmp/xmlux-preVi

rm -f /tmp/xmlux-preIstanzaAwk.txt

exit


