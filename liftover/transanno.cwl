cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  in_vcf_dir: Directory
  include_pattern: string
  chain_file: File
  exclude_files:
    type:
      type: array
      items: File
  query_fasta:
    type: File
    secondaryFiles: [.fai]
  ref_fasta:
    type: File
    secondaryFiles: [.fai]

steps:
  get_vcf_gz_files:
    doc: collect vcf.gz files in dirctory
    run: ../commands/get-files.cwl
    in:
      in_dir: in_vcf_dir
      include_pattern: include_pattern
      exclude_files: exclude_files
    out: [output]

  gunzip_vcf:
    doc: unzip input vcf file
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/gzip.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      d: { default: True }
      file: get_vcf_gz_files/output
    out: [output]

  exclude_irregular_ref_alt:
    doc: filter out variants including letters except A,T,G,and C in REF or ALT
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($0 ~ /^#/ || ($4 ~ /^[ATGC]+$/ && $5 ~ /^[ATGC]+$/)){ print $0 }}' }
      file: gunzip_vcf/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + ".vcf";}
    out: [output]

  collect_irregular_ref_alt:
    doc: collect irregular ref or alt variant letters
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($0 !~ /^#/ && ($4 !~ /^[ATGC]+$/ || $5 !~ /^[ATGC]+$/)){ print $0 }}' }
      file: gunzip_vcf/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + "_irregular_ref_alt.vcf";}
    out: [output]

  transanno:
    doc: liftover by transanno liftvcf command
    run: commands/transanno-liftvcf.cwl
    scatter: [input_vcf]
    scatterMethod: dotproduct
    in:
      chain_file: chain_file
      input_vcf: exclude_irregular_ref_alt/output
      ref_fasta: ref_fasta
      query_fasta: query_fasta
      succeeded_vcf_filename:
         valueFrom: ${ return inputs.input_vcf.nameroot + "_transanno_grch37_38.vcf"; }
      failed_vcf_filename: 
         valueFrom: ${ return inputs.input_vcf.nameroot + "_transanno_failed.vcf"; }
    out: [vcf_succeeded, vcf_failed]

  exclude_multiallelic_alt:
    doc: filter out a converted variant that has multiallelic ALT
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($0 ~ /^#/ || $5 !~ /[,]/){ print $0 }}' }
      file: transanno/vcf_succeeded
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + ".vcf";}
    out: [output]

  collect_multiallelic_alt:
    doc: collect a converted variant that has multiallelic ALT
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($0 ~ /^#/ || $5 ~ /[,]/){ print $0 }}' }
      file: transanno/vcf_succeeded
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + "_multi_alt.vcf";}
    out: [output]

  swap_aac_with_rrc:
    doc: swap AAC with RRC in INFO when REF_CHANGED
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($8 ~ /REF_CHANGED/){ aac_val=substr($8, match($8, /AAC=[0-9]+/), RLENGTH); rrc_val=substr($8, match($8, /RRC=[0-9]+/), RLENGTH); gsub(/AAC=[0-9]+/, "AAC=" substr(rrc_val, 5), $8); gsub(/RRC=[0-9]+/, "RRC=" substr(aac_val, 5), $8); } print $0; }' }
      file: exclude_multiallelic_alt/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + ".vcf";}
    out: [output]

  collect_original_ref_ne_alt_when_ref_changed:
    doc: collect a variant ORIGINAL_REF != RDF when REF_CHANGED
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($8 ~ /REF_CHANGED/ && match($8, /ORIGINAL_REF=[^;]+/)){ orig_ref = substr($8, RSTART+13, RLENGTH-13); if ($5 != orig_ref){ print $0; }}}' }
      file: exclude_multiallelic_alt/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + "_original_ref_ne_alt_when_ref_changed.vcf";}
    out: [output]

  sort_vcf:
    doc: sort vcf
    run: commands/bcftools-sort.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      file: swap_aac_with_rrc/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + ".vcf";}
    out: [output]

  bgzip_vcf:
    doc: bgzip output vcf file
    run: https://raw.githubusercontent.com/nigyta/rice_reseq/master/tools/bgzip-vcf.cwl 
    scatter: vcf 
    scatterMethod: dotproduct
    in:
      vcf: sort_vcf/output 
    out: [bgzipped_vcf]

  tabix_vcf:
    doc: generate .tbi index for bgzipped vcf file
    run: commands/tabix.cwl
    scatter: vcf_gz
    scatterMethod: dotproduct
    in:
      vcf_gz: bgzip_vcf/bgzipped_vcf
    out: [tbi]

outputs:
  liftover_succeeded:
    type: 
      type: array
      items: File
    outputSource: bgzip_vcf/bgzipped_vcf
  liftover_succeeded_tbi:
    type:
      type: array
      items: File
    outputSource: tabix_vcf/tbi
  transanno_failed:
    type: 
      type: array
      items: File
    outputSource: transanno/vcf_failed
  transanno_multialelic_alt:
    type: 
      type: array
      items: File
    outputSource: collect_multiallelic_alt/output
  transanno_irregular_ref_alt:
    type: 
      type: array
      items: File
    outputSource: collect_irregular_ref_alt/output
  transanno_original_ref_ne_alt_when_ref_changed:
    type:
      type: array
      items: File
    outputSource: collect_original_ref_ne_alt_when_ref_changed/output
