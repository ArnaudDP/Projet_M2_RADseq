#!/bin/bash
nb_processeur=4
directoryName=links_to_all_files

#populations a besoin d'un dossier avec tous les fichiers de stacks:
if ! ([[ -d $directoryName ]]);
        then echo "On crée le dossier $directoryName";
        mkdir $directoryName;
        for i in ustacks_res_sans_Caitive_3_4_9 cstacks_res_sans_Caitive_3_4_9 sstacks_res_sans_Caitive_3_4_9;
        do for j in $(ls $i); do ln -s "$PWD/$i/$j" $directoryName/$j; done;
        done
fi



if ! ([[ -d populations_avec_popmap ]]);
        then echo "On crée le dossier populations_avec_popmap";
        mkdir populations_avec_popmap;
fi

if ! ([[ -d populations_avec_popmap/Avec_p_12_lnl_lim_moins_10 ]]);
        then echo "On crée le dossier populations_avec_popmap/Avec_p_12_lnl_lim_moins_10";
        mkdir populations_avec_popmap/Avec_p_12_lnl_lim_moins_10;
fi

if ! ([[ -d populations_avec_popmap/Avec_p_12 ]]);
        then echo "On crée le dossier populations_avec_popmap/Avec_p_12";
        mkdir populations_avec_popmap/Avec_p_12;
fi

populations -b 1 -t ${nb_processeur} -P $directoryName -p 12 --lnl_lim -10 -M popmap.txt --vcf

#populations -b 1 -t ${nb_processeur} -P $directoryName -p 12 -M popmap.txt --vcf

