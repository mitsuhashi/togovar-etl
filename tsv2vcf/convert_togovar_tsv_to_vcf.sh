DATADIR=/mnt/nas05/togovar/original/
DOWNLOAD_DIR=/mnt/nas05/togovar/public/downloads/release/20231027/

#nohup cwltool --debug --cachedir cache --outdir $DOWNLOAD_DIR/grch37/frequency/vcf --log-dir logs convert_togovar_tsv_grch37_to_vcf.cwl input_togovar_tsv_grch37.yml >& nohup_logs/convert_togovar_tsv_grch37_to_vcf.log &

nohup cwltool --debug --cachedir cache --outdir $DOWNLOAD_DIR/grch38/frequency/vcf --log-dir logs convert_togovar_tsv_grch38_to_vcf.cwl input_togovar_tsv_grch38.yml >& nohup_logs/convert_togovar_tsv_grch38_to_vcf.log &

