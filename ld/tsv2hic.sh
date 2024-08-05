DATADIR=/mnt/nas05/togovar/original/
OUTDIR=$DATADIR/grch38/jbrowse2/ld/

DATASET=JGAD000220

#cwltool --debug --cachedir cache --outdir $OUTDIR/bbj1k --log-dir logs tsv2hic.cwl input_$DATASET.yml
cwltool --debug --cachedir cache --outdir $OUTDIR/bbj1k --log-dir logs tsv2hic.cwl input_$DATASET.yml

#mkdir -p toil_work
#mkdir -p toil_logs

#toil-cwl-runner --logDebug --workDir ./toil_work --tmpdir-prefix /data/togovar/etl/togovar-etl/tmp --outdir $OUTDIR/bbj1k --logFile toil_logs/$DATASET.log tsv2hic.cwl input_$DATASET.yml 
