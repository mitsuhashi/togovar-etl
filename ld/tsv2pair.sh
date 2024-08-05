DATADIR=/mnt/nas05/togovar/original/
OUTDIR=$DATADIR/grch38/jbrowse2/ld/

DATASET=JGAD000220

cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs tsv2pair.cwl input_$DATASET.yml
