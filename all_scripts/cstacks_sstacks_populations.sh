#!/bin/bash
#Un script pour lancer cstacks puis sstacks directement

nb_processeur=16
directoryName=links_to_all_files

#On crée un dossier de résulats pour cstacks
if ! ([[ -d cstacks_res_without_Caitive_3_4_9_ANK ]]);
	then echo "On crée le dossier cstacks_res_without_Caitive_3_4_9_ANK";
	mkdir cstacks_res_without_Caitive_3_4_9_ANK;
fi

#On lance cstacks pour créer un dictionnaire
cstacks -b 1 -p ${nb_processeur} -n 2 -o cstacks_res_without_Caitive_3_4_9_ANK/ -s ustacks_res_without_Caitive_3_4_9_ANK/sample_CGATA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_CGGCG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_CTAGG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_CTGAA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GAAGC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GAGAT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GCATT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GCGCC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GGAAG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GGGGA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GTACA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_GTGTG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_TAATG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_TAGCA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_TCAGA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_TCGAG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_TGACC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_TGGTT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AAAAA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AACCC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AAGGG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AATTT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ACCAT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ACGTA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ACTGC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AGAGT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AGCTG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AGGAC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_AGTCA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ATATC -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ATCGA -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ATGCT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_ATTAG -s ustacks_res_without_Caitive_3_4_9_ANK/sample_CAACT -s ustacks_res_without_Caitive_3_4_9_ANK/sample_CATGA

#On crée un dossier de résulats pour sstacks
if ! ([[ -d sstacks_res_without_Caitive_3_4_9_ANK ]]);
	then echo "On crée le dossier sstacks_res_without_Caitive_3_4_9_ANK";
	mkdir sstacks_res_without_Caitive_3_4_9_ANK;
fi

#On lance sstacks pour mapper sur le dictionnaire les loci et pouvoir comparer les individus entre eux
for i in $(cat barcodes_only_without_Caitive_3_4_9_ANK.txt);
	do echo "On lance sstacks sur le fichier sample_$i";
	sstacks -b 1 -p ${nb_processeur} -c cstacks_res_without_Caitive_3_4_9_ANK/batch_1 -o sstacks_res_without_Caitive_3_4_9_ANK/ -s ustacks_res_without_Caitive_3_4_9_ANK/sample_$i;
done

#populations a besoin d'un dossier avec tous les fichiers de stacks:
if ! ([[ -d $directoryName ]]);
        then echo "On crée le dossier $directoryName";
        mkdir $directoryName;
        for i in ustacks_res_without_Caitive_3_4_9_ANK cstacks_res_without_Caitive_3_4_9_ANK sstacks_res_without_Caitive_3_4_9_ANK;
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

populations -b 1 -t ${nb_processeur} -P $directoryName -p 12 --lnl_lim -10 -M popmap_without_Caitive_3_4_9_ANK.txt --vcf

# populations -b 1 -t ${nb_processeur} -P $directoryName -p 12 -M popmap_without_Caitive_3_4_9_ANK.txt --vcf
