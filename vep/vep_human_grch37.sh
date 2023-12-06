#!/bin/bash

set -eu

ENS_VERSION=110
IN_DIR=/mnt/nas05/togovar/public/downloads/release/20221005/grch37/frequency/vcf/
REF_VERSION=GRCh37
#CACHE_DIR=/mnt/nas05/togovar/original/grch37/vep/cache/
CACHE_DIR=./vep_cache/
#FASTA_DIR=/mnt/nas05/togovar/original/grch37/reference_genome/
FASTA_DIR=./vep_cache/reference_genome/
FASTA_FILE=Homo_sapiens.GRCh37.dna.primary_assembly.fa
#OUT_DIR=/mnt/nas05/togovar/original/grch37/vep/2023.1/json/
OUT_DIR=./json
DOCKER_IMAGE=ensemblorg/ensembl-vep:release_110.1

function docker_run(){

  IN_DIR=$1
  IN_VCF=$2
  OUT_DIR=$3

docker run \
   --rm \
   -v $IN_DIR:/opt/vep/.vep:rw \
   -v $CACHE_DIR:/opt/vep/cache \
   -v $FASTA_DIR:/opt/vep/fasta \
   -v $OUT_DIR:/opt/vep/json:rw \
   $DOCKER_IMAGE \
   /opt/vep/src/ensembl-vep/vep \
   --verbose \
   --species homo_sapiens \
   --assembly $REF_VERSION \
   --format vcf --input_file /opt/vep/.vep/$IN_VCF.vcf.gz \
   --json --output_file /opt/vep/json/$IN_VCF.json \
   --fasta /opt/vep/fasta/$FASTA_FILE \
   --fork 4 --offline --cache --dir_cache /opt/vep/cache --cache_version $ENS_VERSION \
   --variant_class \
   --symbol \
   --protein \
   --hgvs \
   --hgvsg \
   --merged \
   --sift b --polyphen b \
   --regulatory --distance 0 \
   --check_existing \
   --force_overwrite  \
   --no_stats

bgzip $OUT_DIR/$IN_VCF.json

}

function run_for_frequency_vcf(){
  chr_no=$1
	
  IN_DIR="/mnt/nas05/togovar/public/downloads/release/20221005/grch37/frequency/vcf/"
  IN_VCF="chr_${chr_no}_frequency"
  IN_VCF_EXT="vcf.gz"
  OUT_DIR="./json/grch37/"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $OUT_DIR

  end_date=`date`
  echo "completed at $end_date"
}

function run_for_clinvar_vcf(){
  IN_DIR="/mnt/nas05/togovar/original/grch37/clinvar/2023.1"
  IN_VCF="clinvar"
  OUT_DIR="/mnt/nas05/togovar/original/grch37/vep/2023.1/json"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $OUT_DIR 

  end_date=`date`
  echo "completed at $end_date"
}

dataset=$1

dataset=$1

if [ "$dataset" = "frequency" ] ; then
  chr_no=$2
  run_for_frequency_vcf $chr_no
elif [ "$dataset" = "gnomad" ] ; then
  run_for_gnomad_vcf
elif [ "$dataset" = "clinvar" ] ; then
  run_for_clinvar_vcf
else
  echo "unknown dataset: $dataset"
fi
