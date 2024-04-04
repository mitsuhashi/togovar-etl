#!/usr/bin/bash

vcf_grch38="/mnt/nas05/togovar/public/downloads/release/20231107/grch38/frequency/vcf/"chr__frequency.vcf.gz"
tsv_grch38="/mnt/nas05/togovar/public/downloads/release/20231107/grch38/frequency/tsv/"chr_12_frequency.tsv.gz"

for chr in (1..22) do;
 zcat $vcf_grch38 | wc -l
zcat $tsv_grch38 | wc -l

echo "---------"

vcf_grch37="/mnt/nas05/togovar/public/downloads/release/20231107/grch37/frequency/vcf/chr_12_frequency.vcf.gz"
tsv_grch37="/mnt/nas05/togovar/public/downloads/release/20231107/grch37/frequency/tsv/chr_12_frequency.tsv.gz"

echo "GRCh37"
zgrep -v "^#" $vcf_grch37 | wc -l
zcat $tsv_grch37 | wc -l
