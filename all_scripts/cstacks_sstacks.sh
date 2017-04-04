#!/bin/bash
#Un script pour lancer cstacks puis sstacks directement

nb_processeur=12

#On crée un dossier de résulats pour cstacks
if ! ([[ -d cstacks_res_sans_Caitive_3_4_9 ]]);
	then echo "On crée le dossier cstacks_res_sans_Caitive_3_4_9";
	mkdir cstacks_res_sans_Caitive_3_4_9;
fi

#On lance cstacks pour créer un dictionnaire
cstacks -b 1 -p ${nb_processeur} -n 2 -o cstacks_res_sans_Caitive_3_4_9/ -s ustacks_res_sans_Caitive_3_4_9/sample_CGATA -s ustacks_res_sans_Caitive_3_4_9/sample_CGGCG -s ustacks_res_sans_Caitive_3_4_9/sample_CTAGG -s ustacks_res_sans_Caitive_3_4_9/sample_CTGAA -s ustacks_res_sans_Caitive_3_4_9/sample_GAAGC -s ustacks_res_sans_Caitive_3_4_9/sample_GAGAT -s ustacks_res_sans_Caitive_3_4_9/sample_GCATT -s ustacks_res_sans_Caitive_3_4_9/sample_GCGCC -s ustacks_res_sans_Caitive_3_4_9/sample_GGAAG -s ustacks_res_sans_Caitive_3_4_9/sample_GGGGA -s ustacks_res_sans_Caitive_3_4_9/sample_GTACA -s ustacks_res_sans_Caitive_3_4_9/sample_GTGTG -s ustacks_res_sans_Caitive_3_4_9/sample_TAATG -s ustacks_res_sans_Caitive_3_4_9/sample_TAGCA -s ustacks_res_sans_Caitive_3_4_9/sample_TCAGA -s ustacks_res_sans_Caitive_3_4_9/sample_TCGAG -s ustacks_res_sans_Caitive_3_4_9/sample_TGACC -s ustacks_res_sans_Caitive_3_4_9/sample_TGGTT -s ustacks_res_sans_Caitive_3_4_9/sample_AAAAA -s ustacks_res_sans_Caitive_3_4_9/sample_AACCC -s ustacks_res_sans_Caitive_3_4_9/sample_AAGGG -s ustacks_res_sans_Caitive_3_4_9/sample_AATTT -s ustacks_res_sans_Caitive_3_4_9/sample_ACACG -s ustacks_res_sans_Caitive_3_4_9/sample_ACCAT -s ustacks_res_sans_Caitive_3_4_9/sample_ACGTA -s ustacks_res_sans_Caitive_3_4_9/sample_ACTGC -s ustacks_res_sans_Caitive_3_4_9/sample_AGAGT -s ustacks_res_sans_Caitive_3_4_9/sample_AGCTG -s ustacks_res_sans_Caitive_3_4_9/sample_AGGAC -s ustacks_res_sans_Caitive_3_4_9/sample_AGTCA -s ustacks_res_sans_Caitive_3_4_9/sample_ATATC -s ustacks_res_sans_Caitive_3_4_9/sample_ATCGA -s ustacks_res_sans_Caitive_3_4_9/sample_ATGCT -s ustacks_res_sans_Caitive_3_4_9/sample_ATTAG -s ustacks_res_sans_Caitive_3_4_9/sample_CAACT -s ustacks_res_sans_Caitive_3_4_9/sample_CATGA

#On crée un dossier de résulats pour sstacks
if ! ([[ -d sstacks_res_sans_Caitive_3_4_9 ]]);
	then echo "On crée le dossier sstacks_res_sans_Caitive_3_4_9";
	mkdir sstacks_res_sans_Caitive_3_4_9;
fi

#On lance sstacks pour mapper sur le dictionnaire les loci et pouvoir comparer les individus entre eux
for i in $(cat barcodes_only_without_Caitive_3_4_9.txt);
	do echo "On lance sstacks sur le fichier sample_$i";
	sstacks -b 1 -p ${nb_processeur} -c cstacks_res_sans_Caitive_3_4_9/batch_1 -o sstacks_res_sans_Caitive_3_4_9/ -s ustacks_res_sans_Caitive_3_4_9/sample_$i;
done
