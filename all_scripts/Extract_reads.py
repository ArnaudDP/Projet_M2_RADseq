#!/usr/bin/python3
# -*-coding:Utf-8 -*


import sys, argparse,re, pysam


parser = argparse.ArgumentParser(description="Lecture .bam file")
if len(sys.argv) < 2:
    print("You need to specify at least .bam file")
    sys.exit(1)
else:
    parser.add_argument("file", nargs = 1, type = str, help = "One .bam file (full path) to use")
    #parser.add_argument("FDRthreeshold", nargs = 1, type = str, help = "A FDR threeshold to use, ex: 0.01 or 0.05")
args = parser.parse_args()

print("#######################################################")
print("Analyse of",args.file[0])
print("#######################################################")
print("\n")
print("\n")

line=str("Empty")
samfile=pysam.AlignmentFile(args.file[0], "rb")
#for read in samfile.fetch():
#	print(read)

for pileupcolumn in samfile.pileup():
    print ("\ncoverage at base %s = %s" %
           (pileupcolumn.pos, pileupcolumn.n))
    for pileupread in pileupcolumn.pileups:
        if not pileupread.is_del and not pileupread.is_refskip:
            # query position is None if is_del or is_refskip is set.
            print ('\tbase in read %s = %s' %
                  (pileupread.alignment.query_name,
                   pileupread.alignment.query_sequence[pileupread.query_position]))

samfile.close()
