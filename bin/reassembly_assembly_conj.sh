##############
# Author: Ben Joris
# Created: July 29th, 2020
# Purpose: Assemble select samples, extract conjugative systems
##############

threads=20

while read line; do
  arrIN=(${line// / })
  sample=${arrIN[0]}
  spades.py -1 ../population_mapping/reads/paired_${sample}_1.fastq.gz ../population_mapping/reads/paired_${sample}_2.fastq.gz --meta -o ../assemblies/${sample}/ -t $threads
  anvi-script-reformat-fasta ../assemblies/${sample}/scaffolds.fasta -o ../assemblies/${sample}/reformated.fasta --simplify-names
  sed -i "s/>/>${sample}_/g" ../assemblies/${sample}/reformated.fasta
  anvi-gen-contigs-database -f ../assemblies/${sample}/reformated.fasta -n 'Microbiome Assemblies' -o ../assemblies/${sample}/CONTIGS.db
  anvi-run-hmms -c ../assemblies/${sample}/CONTIGS.db -I T4SS -t $threads
  anvi-run-hmms -c ../assemblies/${sample}/CONTIGS.db -I T4CP -t $threads
  anvi-run-hmms -c ../assemblies/${sample}/CONTIGS.db -I Relaxase -t $threads
  anvi-get-sequences-for-hmm-hits -c ../assemblies/${sample}/CONTIGS.db --hmm-sources T4SS -o ../assemblies/${sample}/t4ss.fa
  anvi-get-sequences-for-hmm-hits -c ../assemblies/${sample}/CONTIGS.db --hmm-sources T4CP -o ../assemblies/${sample}/t4cp.fa
  anvi-get-sequences-for-hmm-hits -c ../assemblies/${sample}/CONTIGS.db --hmm-sources Relaxase -o ../assemblies/${sample}/relaxase.fa
  python get_conj_systems.py ../assemblies/${sample}/relaxase.fa ../assemblies/${sample}/t4ss.fa ../assemblies/${sample}/t4cp.fa ../assemblies/${sample}/reformated.fasta ../assemblies/${sample}/conj_systems.fasta
done <reassembly_samples.txt
