DATADIR=/mnt/nas05/togovar/original/

#ln -s $DATADIR data

cwltool --debug --cachedir cache --outdir $DATADIR/grch38/tommo/find_multialleic --log-dir logs find_mutiallelic.cwl input_tommo_54kjpn.yml

