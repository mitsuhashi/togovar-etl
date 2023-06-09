DATADIR=/mnt/nas05/togovar/original/
OUTDIR=$DATADIR/liftover_grch37_38/

#ln -s $DATADIR data

cwltool --debug --cachedir cache --outdir $OUTDIR --log-dir logs liftover_grch37_to_grch38.cwl input_grch37_with_tgvid.yml

