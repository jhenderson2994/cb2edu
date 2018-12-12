#Problem 1
#fasta parser
args <- commandArgs(trailingOnly = T)
filename <- args[1]
fasta_file <- file(filename, "r")
ids_file <- file(filename, "txt")

pattern <- "^\\>sp\\|(\\S+)\\"
for (i in ids_file)
  id <- i%in%ids_file
inside <- FALSE
buff <- c("")

while (length(line <- readLines(fasta_file, n=1)) > 0) {
  m <- regexec(pattern, line, perl = T)
  if (m[[1]][1] != -1){ 
    s <- regmatches(line, m)
    #cat(s[[1]][2],s[[1]][3], "\n")
    if (s[[1]][2] == id)
      inside= TRUE
    buff <- c(buff, line)
  } else {
      if (inside) {
        cat (buff, sep = "\n")
        inside <- FALSE
        break
      } else{
          
        }
    }
}
close(fasta_file)

if (inside) {
  cat (buff, sep = "\n")
}

#Problem 2
bwa index BLOSUM62  
bwa mem BLOSUM62 ex_align.fas  >ex_align.fas.sam
samtools view -bS ex_align.fas.sam >ex_align.fas.bam
samtools sort ex_align.fas.bam >ex_align.fas.sorted.bam
java -jar picard.jar MarkDuplicates INPUT=ex_align.fas.sorted.bam OUTPUT=ex_align.fas.dup.bam METRICS_FILE=picard_metrics.txt VALIDATION_STRINGENCY=LENIENT
java -jar ../../picard-tools-1.140/picard.jar CreateSequenceDictionary REFERENCE=BLOSUM62 OUTPUT=BLOSUM62.dict
samtools faidx BLOSUM62 
java -jar ../picard-tools-1.140/picard.jar AddOrReplaceReadGroups I=ex_align.fas.dup.bam O=ex_align.fas.dup.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 CREATE_INDEX=true
java -jar ../GenomeAnalysisTK.jar -T RealignerTargetCreator -R gatk_ref/ex_align.fas -o ex_align.fas.paired.bam.list -I ex_align.fas.dup.rg.bam
java -jar ../GenomeAnalysisTK.jar -I ex_align.fas.dup.rg.bam -R gatk_ref/BLOSUM62 -T IndelRealigner -targetIntervals ex_align.fas.paired.bam.list -o ex_align.fas.realigned.bam
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R BLOSUM62 -I ex_align/fas.realigned.bam --genotyping_mode DISCOVERY -stand_call_conf 30 -o raw_variants.vcf
java -Xmx2g -Djava.io.tmpdir=. -jar ../snpEff/snpEff.jar databases | grep -i Homo_sapiens
java -Xmx2g -Djava.io.tmpdir=. -jar snpEff.jar -v hg19 ex_align.fas.vcf >ex_align.fas.snpeff.vcf

#couldnt figure out how to end it myself