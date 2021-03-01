##############
# Author: Ben Joris
# Created: July 31st, 2020
# Purpose: Run all scripts required for binning the reassemblies
##############

mkdir ../binning/
mkdir ../binning/general
mkdir ../binning/general/reads
mkdir ../binning/infant
mkdir ../binning/infant/reads

./binning_copy_reads.sh

./binning_general_mapping.sh

./binning_general_binning.sh

./binning_infant_mapping.sh

./binning_infant_binning.sh

./checkm_gen_na.sh
./checkm_qa_gen_na.sh

./checkm_infant.sh
./checkm_qa_infant.sh

mkdir ../binning_information
python conjugative_bin_check.py
python refine_binning_info.py > ../binning_information/summary_stats.txt
