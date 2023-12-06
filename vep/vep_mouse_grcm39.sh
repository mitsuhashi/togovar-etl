#!/bin/bash

set -eu

ENS_VERSION=110
REF_VERSION=GRCm39
#CACHE_DIR=/mnt/nas05/togovar/original/grcm39/vep/cache/
CACHE_DIR=./vep_cache/
#FASTA_DIR=/mnt/nas05/togovar/original/grcm39/reference_genome/
FASTA_DIR=./vep_cache/reference_genome/
FASTA_FILE=Mus_musculus.GRCm39.dna.primary_assembly.fa
DOCKER_IMAGE=ensemblorg/ensembl-vep:release_110.1

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
   --species mus_musculus \
   --assembly $REF_VERSION \
   --format vcf --input_file /opt/vep/.vep/$IN_VCF.$IN_VCF_EXT \
   --tab --output_file /opt/vep/json/$IN_VCF.tsv --compress_output gzip \
   --fasta /opt/vep/fasta/$FASTA_FILE \
   --fork 4 --offline --cache --dir_cache /opt/vep/cache --cache_version $ENS_VERSION \
   --variant_class \
   --symbol \
   --protein \
   --hgvs \
   --hgvsg \
   --merged \
   --sift b \
   --regulatory --distance 0 \
   --check_existing \
   --force_overwrite  \
   --no_stats
}

function run_for_mogplus_vcf(){
  IN_DIR="/mnt/nas05/togovar/original/grcm39/vep/vcf"
  IN_VCF="mogplus_vcf_v2_snp_74"
  IN_VCF_EXT="vcf.gz"
  OUT_DIR="/mnt/nas05/togovar/original/grcm39/vep/json"

  start_date=`date`
  echo "start $IN_VCF at $start_date"

  docker_run $IN_DIR $IN_VCF $IN_VCF_EXT $OUT_DIR 

  end_date=`date`
  echo "Completed at $end_date"
}

run_for_mogplus_vcf
