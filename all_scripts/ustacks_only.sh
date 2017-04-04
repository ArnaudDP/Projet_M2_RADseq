#!/bin/bash
#On passe à ustacks:
if ! ([[ -d ustacks_res_2_without_Caitive_3_4_9_ANK ]]);
	then echo "On crée le dossier ustacks_res_2_without_Caitive_3_4_9_ANK";
	mkdir ustacks_res_2_without_Caitive_3_4_9_ANK;
fi

s=1
for i in $(cat barcodes_only_without_Caitive_3_4_9_ANK.txt);
	do echo "On lance Ustacks sur le fichier sample_$i.fq.gz";
	ustacks -t gzfastq -f trimmomatic_res_only_without_Caitive_3_4_9_ANK/sample_$i.fastq.gz -o ustacks_res_2_without_Caitive_3_4_9_ANK/ -H -p 4 -i $s -m 3 -M 3; ((s=$s+1));
done
