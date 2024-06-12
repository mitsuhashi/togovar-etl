function split_clinvar_2024_1_grch38 {
  DATASET=grch38_clinvar_2024_1
  OUTDIR=/mnt/nas05/togovar/original/grch38/vep/2024.1/vcf/split/clinvar
  mkdir -p $OUTDIR
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_$DATASET.yml >& nohup_logs/grch38/make_vep_input_vcf_$DATASET.log &
#  cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_$DATASET.yml
}

function split_clinvar_2024_1_grch37 {
  DATASET=grch37_clinvar_2024_1
  OUTDIR=/mnt/nas05/togovar/original/grch37/vep/2024.1/vcf/split/clinvar
  mkdir -p $OUTDIR
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_$DATASET.yml >& nohup_logs/grch37/make_vep_input_vcf_$DATASET.log &
}


function split_togovar_2024_1_grch38 {
  DATASET=grch38_togovar_2024_1 
  OUTDIR=/mnt/nas05/togovar/original/grch38/vep/2024.1/vcf/split/togovar
  mkdir -p $OUTDIR
#  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_$DATASET.yml >& nohup_logs/grch38/make_vep_input_vcf_$DATASET.log &
  cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_$DATASET.yml
}


function split_togovar_2024_1_grch37 {
  DATASET=grch37_togovar_2024_1 
  OUTDIR=/mnt/nas05/togovar/original/grch37/vep/2024.1/vcf/split/togovar
  mkdir -p $OUTDIR
#  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_$DATASET.yml >& nohup_logs/grch38/make_vep_input_vcf_$DATASET.log &
  TMPDIR=/home/togovar/etl/togovar-etl/vep/toil/
#nohup toil-cwl-runner --logDebug  --tmpdir-prefix $TMPDIR --tmp-outdir-prefix $TMPDIR --workDir $TMPDIR/toil_work --outdir $OUTDIR make-vep-input-vcf.cwl input_vep_$DATASET.yml >& nohup_logs/grch37/make_vep_input_vcf_${DATASET}_toil.log &
nohup toil-cwl-runner --logDebug  --tmpdir-prefix $TMPDIR --tmp-outdir-prefix $TMPDIR --workDir $TMPDIR/toil_work --outdir $OUTDIR make-vep-input-vcf.cwl input_vep_$DATASET.yml >& nohup_logs/grch37/make_vep_input_vcf_${DATASET}_toil.log &
}

function split_tgvid_grch37 {
  OUTDIR=/mnt/nas05/togovar/original/grch37/vep/2023.1/vcf/tgvid/split
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grch37_tgvid.yml >& nohup_logs/grch37/make_vep_input_vcf_grch37_tgvid.log &
}

function split_tgvid_grch38 {
  OUTDIR=/mnt/nas05/togovar/original/grch38/vep/2023.1/vcf/split/tgvid
  mkdir -p $OUTDIR
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grch38_tgvid.yml >& nohup_logs/grch38/make_vep_input_vcf_grch38_tgvid.log &
}

function split_clinvar_grch38 {
  OUTDIR=/mnt/nas05/togovar/original/grch38/vep/2024.1/vcf/split/clinvar
  mkdir -p $OUTDIR
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grch38_clinvar.yml >& nohup_logs/grch38/make_vep_input_vcf_grch38_clinvar.log &
}

function split_clinvar_grch37 {
  OUTDIR=/mnt/nas05/togovar/original/grch37/vep/2024.1/vcf/split/clinvar
  mkdir -p $OUTDIR
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grch37_clinvar.yml >& nohup_logs/grch37/make_vep_input_vcf_grch37_clinvar.log &
}

function split_gnomad_grch38 {
  OUTDIR=/mnt/nas05/togovar/original/grch38/vep/2024.1/vcf/split/gnomad/4.0

  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grch38_gnomad.yml >& nohup_logs/grch38/make_vep_input_vcf_grch38_gnomad.log &
}

function split_gnomad_grch37 {
  OUTDIR=/mnt/nas05/togovar/original/grch37/vep/2023.1/vcf/split/gnomad/2.1.1
  TMPDIR=/data/togovar/etl/tmp/toil/

  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grch37_gnomad.yml >& nohup_logs/grch37/make_vep_input_vcf_grch37_gnomad.log &

  nohup toil-cwl-runner --logDebug  --tmpdir-prefix $TMPDIR --tmp-outdir-prefix $TMPDIR --workDir $TMPDIR/toil_work --outdir $OUTDIR make-vep-input-vcf.cwl input_vep_grch37_gnomad.yml >& nohup_logs/grch37/make_vep_input_vcf_grch37_gnomad_toil.log &
}

function split_mogplus_grcm39 {
  OUTDIR=/mnt/nas05/togovar/original/grcm39/vep/vcf
  nohup cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs make-vep-input-vcf.cwl input_vep_grcm39_mogplus.yml >& nohup_logs/grcm39/make_vep_input_vcf_grcm39_mogplus.log &
}

split_clinvar_2024_1_grch37
split_clinvar_2024_1_grch38

#split_togovar_2024_1_grch37
#split_togovar_2024_1_grch38

#split_clinvar_grch38
#split_clinvar_grch37

#split_tgvid_grch37

#split_mogplus_grcm39

#OUTDIR=./gnomad
#TMPDIR=/data/togovar/etl/tmp/toil/

#nohup toil-cwl-runner --logDebug --workDir toil_work --outdir $OUTDIR --logFile nohup_logs/grch38/grch38/make_vep_input_vcf_grch38_gnomad_toil.log make-vep-input-vcf.cwl input_vep_grch38_gnomad.yml >& nohup_logs/grch38/make_vep_input_vcf_grch38_gnomad_toil.log

#nohup toil-cwl-runner --logDebug  --tmpdir-prefix $TMPDIR --tmp-outdir-prefix $TMPDIR --workDir $TMPDIR/toil_work --outdir $OUTDIR make-vep-input-vcf.cwl input_vep_grch38_gnomad.yml >& nohup_logs/grch38/make_vep_input_vcf_grch38_gnomad_toil.log &
