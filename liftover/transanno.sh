#
#  Run transanno2024.cwl which is used since 2024/4
#
#

DATADIR=/mnt/nas05/togovar/original/
OUTDIR=$DATADIR/liftover_grch37_38/

#cwltool --debug --cachedir cache --outdir $OUTDIR/jga_snp --log-dir logs transanno.cwl input_jga_snp.yml

#toil-cwl-runner --logDebug --workDir ./toil_work --outdir $OUTDIR/bbj_riken --logFile toil_logs/bbj_riken.log transanno.cwl input_bbj_riken_freq.yml

