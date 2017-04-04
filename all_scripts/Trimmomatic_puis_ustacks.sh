#!/bin/bash
#Un script pour lancer Trimmomatic (enlever le barcode + 1 base) puis ustacks
cd ~/Desktop/From_scratch_RADseq_analysis/analyse_reduite

#On enlève les 6 premières bases de chaque reads avec trimmomatic:
#On crée un dossier de résultat si il n'éxiste pas:
if ! ([[ -d trimmomatic_res_only_without_Caitive_3_4_9_ANK ]]);
	then echo "On crée le dossier trimmomatic_res_only_without_Caitive_3_4_9_ANK";
	mkdir trimmomatic_res_only_without_Caitive_3_4_9_ANK;
fi

for i in $(cat barcodes_only_without_Caitive_3_4_9_ANK.txt);
	do echo "On trim le fichier sample_$i.fq.gz";
	java -jar ~/bioinfo/Trimmomatic-0.36/trimmomatic-0.36.jar SE -phred33 /home/ubuntu/Desktop/From_scratch_RADseq_analysis/analyse_reduite/process_radtags_res/sample_$i.fq.gz ~/Desktop/From_scratch_RADseq_analysis/analyse_reduite/trimmomatic_res_only_without_Caitive_3_4_9_ANK/sample_$i.fastq.gz HEADCROP:6;
done

#On effectue un quality check avec fastqc
#if ! ([[ -d Post_trim_fastqc_res ]]);
#	then echo "On crée le dossier Post_trim_fastqc_res";
#	mkdir Post_trim_fastqc_res;
#fi

#for i in $(ls trimmomatic_res/*.fastq.gz);
#	do echo "On lance fastqc sur le fichier $i";
#	fastqc -o Post_trim_fastqc_res/ ~/Desktop/From_scratch_RADseq_analysis/$i;
#done


#On passe à ustacks:
if ! ([[ -d ustacks_res_without_Caitive_3_4_9_ANK ]]);
	then echo "On crée le dossier ustacks_res_without_Caitive_3_4_9_ANK";
	mkdir ustacks_res_without_Caitive_3_4_9_ANK;
fi

s=1
for i in $(cat barcodes_only_without_Caitive_3_4_9_ANK.txt);
	do echo "On lance Ustacks sur le fichier sample_$i.fq.gz";
	ustacks -t gzfastq -f trimmomatic_res_only_without_Caitive_3_4_9_ANK/sample_$i.fastq.gz -o ustacks_res_without_Caitive_3_4_9_ANK/ -H -p 4 -i $s -m 3 -M 3; ((s=$s+1));
done
