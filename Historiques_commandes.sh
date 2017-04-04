#!/bin/bash

#Voici un script récapitulant l'ensemble des commandes lancées pour l'analyse de mon jeu de donnée RADseq_raw_data.

#Le vendredi 17 mars 2017 :
#J'ai finalement le fin mot sur mes données...
#Les données brutes sont stockées sur /media/ubuntu/DATAS/LibM_raw_reads.
#1  Quality control of the libraries Fastq files with FastQC v0.10.1
mkdir Quality_check_fastqc_res
for i in $(ls /media/ubuntu/DATAS/LibM_raw_reads); do fastqc -o Quality_check_fastqc_res/ /media/ubuntu/DATAS/LibM_raw_reads/$i; done
#Affichage des résultats
firefox *fastqc/fastqc_report.html



#Analyse du jeu de données avec stacks v1.45
#Quelques soient les résultats donnés par Fastqc, je lance pour le week-end process_radtags sensé tester la qualité de mes reads, enlever les mauvais, enlever les adapateurs etc. tout seul...
#En effet, d'après le fichier /media/ubuntu/DATAS/2_Quality_and_demultiplexing.txt
#	" 1.3  Filtering the raw reads (do it only in STACKS for RAD-seq, not as described here! Only remove adaptor sequences) "

#Process radtags:
mkdir process_radtags_res
process_radtags -p /media/ubuntu/DATAS/LibM_raw_reads -b /media/ubuntu/DATAS/LibM_barcodes_only.txt -i gzfastq -y gzfastq -o /home/ubuntu/Desktop/From_scratch_RADseq_analysis/process_radtags_res -e pstI -r -c -q


#Lundi 20 mars 2017:
#Fastqc again, pour voir si tout a marché :
cd ~/Desktop/From_scratch_RADseq_analysis/process_radtags_res
mkdir Quality_check_fastqc_res
for i in $(ls ~/Desktop/From_scratch_RADseq_analysis/process_radtags_res); do fastqc -o Quality_check_fastqc_res/ ~/Desktop/From_scratch_RADseq_analysis/process_radtags_res/$i; done

#Ustacks a priori pour gagner du temps...
cp /media/ubuntu/DATAS/LibM_barcodes_only.txt ~/Desktop/From_scratch_RADseq_analysis/barcodes_only.txt
cp /media/ubuntu/DATAS/LibM_barcodes.txt ~/Desktop/From_scratch_RADseq_analysis/Correspondances_barcodes.txt

mkdir ustacks_res
s=1; for i in `cat barcodes_only.txt`; do ustacks -t gzfastq -f process_radtags_res/sample_$i.fq.gz -o ustacks_res/ -H -p 4 -i $s -m 3 -M 3; ((s=$s+1)); done
#Par rapport à Odrade, j'ai enlevé l'option -m 2, pour rester à la valeur par défaut. Cette valeur choisie par odrade correspondait en effet à la valeur par défaut dans la version précédente.


#Essai trimmomatic sur 1 fichier raw_data:
#For Single End:
#--> java -jar trimmomatic-0.30.jar SE -phred33 input.fq.gz output.fq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
#- Remove adapters (ILLUMINACLIP:TruSeq3-PE.fa:2:30:10)
#- Remove leading low quality or N bases (below quality 3) (LEADING:3)
#- Remove trailing low quality or N bases (below quality 3) (TRAILING:3)
#- Scan the read with a 4-base wide sliding window, cutting when the average quality per base drops below 15 (SLIDINGWINDOW:4:15)

java -jar ~/bioinfo/Trimmomatic-0.36/trimmomatic-0.36.jar SE -phred33 /media/ubuntu/DATAS/LibM_raw_reads/Lane1_NoIndex_L001_R1_003.fastq.gz ~/Desktop/From_scratch_RADseq_analysis/Essai_trimmomatic/Clean_Lane1_NoIndex_L001_R1_003.fastq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:28 MINLEN:80

##-> Conclusion: Trimmomatic permet bien d'enlever les adapateurs restant, mais ceci est bien fait par process_radtags...
##		-> Si on met un filtre trop stringeant on perd la majeur partie de nos reads... De plus la perte de qualité est majoritairement située en début de séquence, ce qui corrrespond aux séquences de barcode... Sinon, trimmomatic n'apporte rien de plus que process_radtags si on le lance avant...



#Et si on enlevait avec trimmomatic seuelement les 6 paires de bases (le barcodes +1) dont la qualité est faible plutôt que d'enlever 60% de nos reads ?
java -jar ~/bioinfo/Trimmomatic-0.36/trimmomatic-0.36.jar SE -phred33 ~/Desktop/From_scratch_RADseq_analysis/Essai_trimmomatic/Essai_AAAAA/sample_AAAAA.fastq.gz ~/Desktop/From_scratch_RADseq_analysis/Essai_trimmomatic/Essai_AAAAA/H6.fastq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 HEADCROP:6
#Conclusion de la journée:
#trimmomatic pour enlever simplment les 6 premières bases !!!!!! 
#Ca a l'air qu'on non ?

###################################################
# FINALEMENT, LES COMMANDES IMPORTANTES LANCEES : #
###################################################
#1  Quality control of the libraries Fastq files with FastQC v0.10.1
mkdir Quality_check_fastqc_res
for i in $(ls /media/ubuntu/DATAS/LibM_raw_reads); do fastqc -o Quality_check_fastqc_res/ /media/ubuntu/DATAS/LibM_raw_reads/$i; done
#Affichage des résultats
firefox *fastqc/fastqc_report.html

#Process radtags:
mkdir process_radtags_res
process_radtags -p /media/ubuntu/DATAS/LibM_raw_reads -b /media/ubuntu/DATAS/LibM_barcodes_only.txt -i gzfastq -y gzfastq -o /home/ubuntu/Desktop/From_scratch_RADseq_analysis/process_radtags_res -e pstI -r -c -q

#J'ai écrit un script qui trim les premières 6 bases, lance un quality check puis lance ustacks:
chmod +x Trimmomatic_puis_ustacks.sh
./Trimmomatic_puis_ustacks.sh

#Mardi 21 mars 2017
#Tout semble avoir bien tourné !! La qualité est nickel !!
#Comme d'hab on enlève Caitive_3 4 et 9 car ils manquent trop de reads...
#Barcode	Total		NoRadTag        LowQuality      Retained
#CGATA		11241903	276358		184575		10780970
#CGGCG		10050536	207606		180494		9662436
#CTAGG		10121947	349554		143225		9629168
#CTGAA		8297268		552190		121258		7623820
#GAAGC		12037330        355531		192694		11489105
#GAGAT		7911383		593308		83597		7234478
#GCATT		8260109		309600		136279		7814230
#GCGCC		11331087        197311		224919		10908857
#GGAAG		8081899		371772		84689		7625438
#GGGGA		10293068        227931		110767		9954370
#GTACA		8559061		206723		134878		8217460
#GTGTG		10267820        264008		119782		9884030
#TAATG		11858789        547379		189959		11121451
#TAGCA		12414217        817716		196136		11400365
#TCAGA		14479082        355158		336415		13787509
#TCGAG		11200348        506915		156981		10536452
#TGACC		9285516		326549		168634		8790333
#TGGTT		5891290		314806		67077		5509407
#AAAAA		7939405		838845		97243		7003317
#AACCC		7737305		404083		153254		7179968
#AAGGG		7597932		331078		77501		7189353
#AATTT		7002781		512333		115849		6374599
#ACACG		12293702        308652		259916		11725134
#ACCAT		10159124        847461		179249		9132414
#ACGTA		10161467        217664		175775		9768028
#ACTGC		9114791		357130		164846		8592815
#AGAGT		7585789		382614		81187		7121988
#AGCTG		8765674		507732		120829		8137113
#AGGAC		6985296		331120		113785		6540391
#AGTCA		7225610		331431		102573		6791606
#ATATC		6849280		284421		135246		6429613
#ATCGA		11450016        245773		182204		11022039
#ATGCT		7674612		360146		122278		7192188
#ATTAG		8598781		501524		112695		7984562
#CAACT		7066343		310508		122163		6633672
#CACAG		371406		134626		4038		232742	<- On enlève de l'analyse
#CAGTC		711623		221728		9141		480754	<- On enlève de l'analyse
#CATGA		1889928		289865		23640		1576423 <- On choisit de garder pour voir
#CCAAC		616621		273897		8233		334491	<- On enlève de l'analyse

#J'ai créé un fichier barcodes_only_without_Caitive_3_4_9.txt où j'ai retiré ces individus trop peu couvert

#Je copie les individus gardés dans un nouveau dossier
mkdir ustacks_res_sans_Caitive_3_4_9
for i in `cat barcodes_only_without_Caitive_3_4_9.txt`; do cp ustacks_res/sample_${i}* ustacks_res_sans_Caitive_3_4_9/; done

#J'ai écrit un script pour lancer cstacks et sstacks : cstacks_sstacks.sh

#J'ai lancé ce script sur l'ordinateur d'Enrique, beaucoup plus puissant que le mien, notamment pour cstacks et la constitution du dictionnaire qui necessite ici plus d'une dizaine de GB de ram...
#np_processeur=4; eval $(echo -n "cstacks -b 1 -p ${nb_processeur} -n 2 -o cstacks_res_sans_Caitive_3_4_9/ ";for i in `cat barcodes_only_without_Caitive_3_4_9.txt`; do echo -n "-s ustacks_res_sans_Caitive_3_4_9/sample_$i "; done; echo "")

#On lance le dernier script "population":
# Pour ça il faut que tous les fichiers soient dans un même dossier... Du coup je crée un dossier de lien symbolique pour gagner de la place...
for i in cstacks_res_sans_Caitive_3_4_9 sstacks_res_sans_Caitive_3_4_9 ustacks_res_sans_Caitive_3_4_9;
	do for j in $(ls $i); do ln -s "$PWD/$i/$j" links_to_all_files/$j; done;
done

#J'ai écrit un script pour lancer populations sur l'ordinateur d'Enrique : populations.sh

##### Finalement ça n'a pas marché !
# Il faut que j'utilise depuis sstacks une population map, comme Odrade je fixe un invidu=une pop
# comme ça on est sur qu'il n'y a pas d'hypothèse d'HW cachée qq part...
#Ensuite Dans population, j'utilise la même map, avec le paramètre -p = 12, --lnl_lim=-10, --vcf

