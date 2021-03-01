##############
# Author: Ben Joris
# Created: July 29th, 2020
# Purpose: Run all scripts required to reassembly and map select samples
##############

mkdir assemblies

./reassembly_assembly_conj.sh

mkdir ../reassembly
cat ../assemblies/*/conj_systems.fasta >> ../reassembly/contigs.fa

mkdir ../reassembly_contigs/
python reassembly_separate_contigs.py

./reassembly_contig_annotation.sh

mkdir ../reassembly_orf_tables/
python reassembly_tabcreate.py

mkdir ../reassembly_operons/
python reassembly_extract_conjugative_elements.py

./reassembly_mapping.sh
python reassembly_mapping_data.py

./reassembly_anvi_profile.sh

#### -------- EDIT KAIJU INSTALL LOCATIONS -------- ####
mkdir ../reassembly_taxon/
/Volumes/data/bin/kaiju/bin/kaiju -t /Volumes/data/bin/kaiju/nr/nodes.dmp -f /Volumes/data/bin/kaiju/nr/nr/kaiju_db_nr.fmi -i ../reassembly/contigs.fa -z 5 -o ../reassembly_taxon/tax_contigs.txt
/Volumes/data/bin/kaiju/bin/kaiju-addTaxonNames -t /Volumes/data/bin/kaiju/nr/nodes.dmp -n /Volumes/data/bin/kaiju/nr/names.dmp -i ../reassembly_taxon/tax_contigs.txt -o ../reassembly_taxon/tax_contigs.tsv -r phylum,class

anvi-export-splits-and-coverages -p ../reassembly_anvio/SAMPLES_MERGED/PROFILE.db -c ../reassembly_anvio/CONTIGS.db -o ../reassembly_anvio/SAMPLES_MERGED/
python reassembly_tax_cohort.py
python reassembly_ordering_items.py
anvi-import-misc-data ../reassembly_anvio/SAMPLES_MERGED/items_order.txt -p ../reassembly_anvio/SAMPLES_MERGED/PROFILE.db --target-data-table items

anvi-export-misc-data -p ../reassembly_anvio/SAMPLES_MERGED/PROFILE.db -t layers -o -p ../reassembly_anvio/SAMPLES_MERGED/layers_original.txt
python reassembly_layer_data.py
anvi-import-misc-data ../reassembly_anvio/SAMPLES_MERGED/layers_new.txt -p ../reassembly_anvio/SAMPLES_MERGED/PROFILE.db --target-data-table items --just-do-it
