#!/usr/bin/bash

id="tgv47264307"

echo "GRCh38"
vcf_grch38="/mnt/nas05/togovar/public/downloads/release/20231107/grch38/frequency/vcf/chr_12_frequency.vcf.gz"
bcftools query -i "ID='$id'" -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%INFO\n' $vcf_grch38

echo "---------"

echo "GRCh37"
vcf_grch37="/mnt/nas05/togovar/public/downloads/release/20231107/grch37/frequency/vcf/chr_12_frequency.vcf.gz"
bcftools query -i "ID='$id'" -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%INFO\n' $vcf_grch37
