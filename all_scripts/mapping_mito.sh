#!/bin/bash
# on error exit flag : set -e
set -o errexit
# error if a var is unset : set -u
set -o nounset
# raise error in pipe
set -o pipefail

######################################
# date : 31.03.2017
# version : 0.01
# author : Arnaud Desbiez-Piat
# licence : GPL
#
######################################
# Short description :
#    This script takes one reference genome and a fastq file containing reads to map against it.
#	It is important that all files, or at least links are presents in the same directory than this script.
#
######################################
# USAGE :
#	  ./mapping_mito.sh -g <ref fasta file> -r <reads fastq> -t <threads>
#
######################################
# Long Description :
#    bla bla bla bla ... 
######################################
# Known problems and caveats
#  - the script print to stdout the required fastq file number
#
######################################
# DEVELOPPER'S TODO LIST
# -Complete Usage, descriptionS, etc. 
# -Add output dir


######################################
# SCRIPT PARAMETERS
SCRIPT_NAME=$(basename "$0")
while getopts ":g:r:o:t:" opt; do
	case $opt in
		g) geno_mito_ref="$OPTARG"
		;;
		r) reads_to_map="$OPTARG"
		;;
#		o) output_dir="$OPTARG"
#		;;
		t) threads="$OPTARG"
		;;
		\?) echo "Option invalide -$OPTARG" >&2
		;;
esac
done
####################################
# FUNCTIONS

usage(){
	echo -e "$SCRIPT_NAME script :" 
	echo -e "\t\ttakes one reference genome and a fastq file containing reads to map against it"
	echo -e "$SCRIPT_NAME usage :"
	echo -e "\t\t$SCRIPT_NAME -g <ref fasta file> -r <reads fastq> -t <threads>" #-o <output directory>
}

####################################
# testing the -g parameter : the ref fasta file
[ -e "${geno_mito_ref}" ] || { (usage ; echo -e "ERROR : file not found error for ${geno_mito_ref} \n") >&2 ; exit 2;}
[ -f "${geno_mito_ref}" ] || { (usage ; echo -e "ERROR : standard file expected for ${geno_mito_ref} \n") >&2; exit 2;}
[ -r "${geno_mito_ref}" ] || { (usage ; echo -e "ERROR : Read permission error for ${geno_mito_ref} \n") >&2 ; exit 2;}
[ -s "${geno_mito_ref}" ] || { (usage ; echo -e "ERROR : Empty file error for ${geno_mito_ref} \n") >&2 ; exit 2;}
[[ "${geno_mito_ref}" == *.fasta ]] || [[ "${geno_mito_ref}" == *.fa ]] || { (usage ; echo -e "ERROR : '.fasta' or '.fa' file extention expected ${geno_mito_ref} \n") >&2 ; exit 2;}
# testing the -r parameter : the reads fasq file
[ -e "${reads_to_map}" ] || { (usage ; echo -e "ERROR : file not found error for ${reads_to_map} \n") >&2 ; exit 2;}
[ -f "${reads_to_map}" ] || { (usage ; echo -e "ERROR : standard file expected for ${reads_to_map} \n") >&2; exit 2;}
[ -r "${reads_to_map}" ] || { (usage ; echo -e "ERROR : Read permission error for ${reads_to_map} \n") >&2 ; exit 2;}
[ -s "${reads_to_map}" ] || { (usage ; echo -e "ERROR : Empty file error for ${reads_to_map} \n") >&2 ; exit 2;}
[[ "${reads_to_map}" == *.fastq ]] || [[ "${reads_to_map}" == *.fastq.gz ]] || { (usage ; echo -e "ERROR : '.fastq' or '.fastq.gz' file extention expected ${reads_to_map} \n") >&2 ; exit 2;}

# testing the  -o parameter : the output directory
#[ -e "$output_dir" ] || { 
#	      mkdir -p "$output_dir" || { (usage ; echo -e "ERROR : directory $output_dir does not exist and can not create it\n") >&2; exit 2;} && echo -e "Directory $output_dir missing. Created automatically ! \n"
#          } 
#[ -w "$output_dir" ] || { (usage ; echo -e "ERROR : write permission error in directory $output_dir\n") >&2; exit 2;}

# testing the -r parameter : the number from 1 to 99
[[ $threads =~ ^[0-9]{,2}$ && $threads -ne 0 ]] || { (usage ; echo -e "ERROR : -t parameter should be an integer from 1 to 99, '$threads' provided \n") >&2; exit 2;}

####################################
# CORE CODE

echo "$SCRIPT_NAME running"
echo "Le génotype de référence utilisé est:" "${geno_mito_ref}"
echo "Les reads à mapper sont ceux du fichier fastq:" "${reads_to_map}"
#echo "Le dossier de sortie est:" "$output_dir"
echo "Les programmes tournent sur $threads threads"

base=$(basename ${reads_to_map})
sample_name=$(cut -d. -f1 <<< ${base})
#echo $sample_name

#Création d'un index du génome de référence pour bwa
if ! ([[ -f ${geno_mito_ref}.bwt ]]&&[[ -f ${geno_mito_ref}.pac ]]&&[[ -f ${geno_mito_ref}.ann ]]&&[[ -f ${geno_mito_ref}.amb ]]&&[[ -f ${geno_mito_ref}.sa ]]);
	then bwa index ${geno_mito_ref};
fi

#Mapping :ll
bwa mem -t $threads ${geno_mito_ref} ${reads_to_map} > aln_${sample_name}.sam #-k 40
## Arguments (man summary)
## -k 50 : Minimum seed length. Matches shorter than INT will be missed
## -w INT : Band width. Essentially, gaps longer than INT will not be found.
## -c INT : Discard a MEM if it has more than INT occurence in the genome.
## -A INT : Matching score.
## -T INT : Don't output alignment with score lower than INT.
## -B INT : Mismatch  penalty.  The  sequence  error  rate  is  approximately:  {.75 * exp[-log(4) * B/A]}.
## -O INT : Gap open penalty.
## -E INT : Gap  extension  penalty.  A  gap of length k costs O + k*E (i.e.  -O is for opening a zero-length gap).

#Le but maintenant est de traiter ça en une sortie plus pratique avec samtools
#Idem création d'un index du génome de réf propre à samtools

if ! ([[ -f ${geno_mito_ref}.fai ]]);
	then samtools faidx ${geno_mito_ref};
fi

#Conversion du sam en bam
samtools import ${geno_mito_ref}.fai aln_${sample_name}.sam aln_${sample_name}.bam

#On trie le bam:
samtools sort aln_${sample_name}.bam aln_${sample_name}.sorted

#On indexe le bam file
samtools index aln_${sample_name}.sorted.bam

######################################
# END
echo -e "Successfully processed files !\n"
exit 0
