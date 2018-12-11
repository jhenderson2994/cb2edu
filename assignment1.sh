#Problem 1
#Bash script to extract unique domains from 9606 proteome:
cat 9606.tsv | tail -n+4 | cut -f 6 | sort | uniq |wc

#Problem 2: 
#bash script to get all Yersinia_pestis strains
wget -r ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Yersinia_pestis*

#Problem 3: 
#bash script to get all Yersinia_pestis proteins from all .faa files
find / -name "*.faa" -print0 | xargs -r0 grep -Hi '\>' {} + |wc -l

#Problem 4: 
a) Answer from using bash script : avg gene length= 316 bp
b) #average gene calculation using an imput .faa file
gene_num=`cat $1 | grep \> |wc -l`
bp=`cat $1 | grep -v \> | tr -d "\n" |wc -c`
echo "$bp / $gene_num" |bc
  