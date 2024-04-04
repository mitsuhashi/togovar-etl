#!/bin/bash

set -eu

ENS_VERSION=111
REF_VERSION=GRCh38
#CACHE_DIR=/mnt/nas05/togovar/original/grch38/vep/2023.1/cache/
CACHE_DIR=./vep_cache/
#FASTA_DIR=/mnt/nas05/togovar/original/grch38/reference_genome/
FASTA_DIR=./vep_cache/reference_genome/
FASTA_FILE=Homo_sapiens.GRCh37.dna.primary_assembly.fa
DOCKER_IMAGE=ensemblorg/ensembl-vep:release_111.0

function docker_run(){

  IN_DIR=$1
  IN_VCF=$2
  IN_VCF_EXT=$3
  OUT_DIR=$4

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
   --format vcf --input_file /opt/vep/.vep/$IN_VCF.$IN_VCF_EXT \
   --json --output_file /opt/vep/json/$IN_VCF.json \
   --fasta /opt/vep/fasta/$FASTA_FILE \
   --fork 4 --offline --cache --dir_cache /opt/vep/cache --cache_version $ENS_VERSION \
   --variant_class \
   --symbol \
   --protein \
   --hgvs \
   --hgvsg \
   --merged \
   --mane \
   --flag_pick \
   --sift b --polyphen b \
   --regulatory --distance 0 \
   --check_existing \
   --force_overwrite  \
   --no_stats
}

function run_for_frequency_vcf(){
  chr_no=$1
	
  IN_DIR="/mnt/nas05/togovar/downloads/"
  IN_VCF="chr_${chr_no}_frequency"
  IN_VCF_EXT="vcf.gz"
  OUT_DIR="./json/grch38/"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $IN_VCF_EXT $OUT_DIR

  end_date=`date`
  echo "Completed at $end_date"
}

function run_for_gnomad_vcf(){
  IN_DIR="/mnt/nas05/togovar/original/grch38/vep/2023.1/vcf"
  IN_VCF="gnomad.genomes.v3.1.1.variants.GRCh38.id.only_00"
  IN_VCF_EXT="vcf.gz"
  OUT_DIR="./json/grch38/"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $IN_VCF_EXT $OUT_DIR

  end_date=`date`
  echo "Completed at $end_date"
}


function run_for_clinvar_vcf(){
  IN_DIR="/mnt/nas05/togovar/original/grch38/clinvar/2023.2/"
  IN_VCF="clinvar"
  IN_VCF_EXT="vcf.gz"
  OUT_DIR="/mnt/nas05/togovar/original/grch38/vep/2023.2/json"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $IN_VCF_EXT $OUT_DIR 

  end_date=`date`
  echo "Completed at $end_date"
}

function run_for_kawai_sv_vcf(){
  IN_DIR="/mnt/nas05/togovar/original/grch38/kawai/20230327/JPT.graphtyper/"
  IN_VCF="JPT.graphtyer.chr22"
  IN_VCF_EXT="vcf.gz"
  OUT_DIR="/mnt/nas05/togovar/original/grch38/kawai/20230327/vep/"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $IN_VCF_EXT $OUT_DIR

  end_date=`date`
  echo "Completed at $end_date"
}


dataset=$1

if [ "$dataset" = "frequency" ] ; then
  chr_no=$2
  run_for_frequency_vcf $chr_no
elif [ "$dataset" = "gnomad" ] ; then
  run_for_gnomad_vcf
elif [ "$dataset" = "clinvar" ] ; then
  run_for_clinvar_vcf
elif [ "$dataset" = "kawai" ] ; then
  run_for_kawai_sv_vcf
else
  echo "unknown dataset: $dataset"
fi
