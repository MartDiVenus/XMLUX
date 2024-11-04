#!/bin/bash


nomeFile="$(cat /tmp/xmlux-nomeFileIsolato)"

if [ -f /tmp/xmlux-percorsoIsolato ]; then

                percorsoIsolato="$(cat /tmp/xmlux-percorsoIsolato)"


mkdir $percorsoIsolato/$nomeFile-xmlux


		cat /usr/local/lib/xmlux/documentClasses/data/pieDataset/css2/pieDataset.lmx > $percorsoIsolato/$nomeFile-xmlux/$nomeFile.lmx

		sudo chown -R $USER:$USER $percorsoIsolato/$nomeFile-xmlux/

		sudo chmod -R ugao-xrw $percorsoIsolato/$nomeFile-xmlux/

		sudo chmod uga+x $percorsoIsolato/$nomeFile-xmlux/

		sudo chmod -R uga+rw $percorsoIsolato/$nomeFile-xmlux/


		## Devo fare la stessa cosa anche nelle altre modalità di xmlux, ossia quando non scelgo --data

		vim -c ":%s/pieDataset.css/$nomeFile.css/g"	$percorsoIsolato/$nomeFile-xmlux/$nomeFile.lmx -c :w -c :q

                vim -c ":%s/pieDataset.dtd/$nomeFile.dtd/g"	$percorsoIsolato/$nomeFile-xmlux/$nomeFile.lmx -c :w -c :q

		## else [altri stili ancora non implementati]


else

mkdir $nomeFile-xmlux

		cat /usr/local/lib/xmlux/documentClasses/data/pieDataset/css2/pieDataset.lmx > $nomeFile-xmlux/$nomeFile.lmx

		sudo chown -R $USER:$USER $nomeFile-xmlux/

		sudo chmod -R ugao-xrw $nomeFile-xmlux/

		sudo chmod uga+x $nomeFile-xmlux/

		sudo chmod -R uga+rw $nomeFile-xmlux/

		## Devo fare la stessa cosa anche nelle altre modalità di xmlux, ossia quando non scelgo --data

		vim -c ":%s/pieDataset.css/$nomeFile.css/g" $nomeFile-xmlux/$nomeFile.lmx -c :w -c :q

                vim -c ":%s/pieDataset.dtd/$nomeFile.dtd/g" $nomeFile-xmlux/$nomeFile.lmx -c :w -c :q

		#else [altri stili ancora non implementati]

fi


exit
