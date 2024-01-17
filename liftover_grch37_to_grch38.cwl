cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  chain_file: File
  input_vcf:
    type:
      type: array
      items: File
  output_vcf: 
    type: string[] 
  query_fasta: File
  query_fasta_fai: File
  ref_fasta: File
  ref_fasta_fai: File

steps:
  gunzip_vcf:
    doc: unzip input vcf file
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/gzip.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      d: { default: True }
      file: input_vcf
    out: [output]

  fix_mt_length_in_vcf:
    doc: set length of MT in input vcf as ##contig=<ID=MT,length=16569,assembly=GRCh37>
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      text: { default: '{ if($0 ~ /^##contig=<ID=MT,/){ print "##contig=<ID=MT,length=16569,assembly=GRCh37>" }else{ print $0 }}' } 
      file: gunzip_vcf/output
      outFileName: 
        valueFrom: ${ return inputs.file.nameroot + "_mt_fixed.vcf";} 
    out: [output]

  to_upper_ref_alt:
    doc: convert REF and ALT to upper letter and filter out variants including letters except A,T,G,and C in REF or ALT
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ $4 = toupper($4); $5 = toupper($5); if($0 ~ /^#/ || ($4 ~ /^[ATGC]+$/ && $5 ~ /^[ATGC]+$/)){ print $0 }}' }
      file: fix_mt_length_in_vcf/output
      outFileName: 
        valueFrom: ${ return inputs.file.nameroot + "_upper_ref_alt.vcf";} 
    out: [output]

  collect_irregular_ref_alt:
    doc: collect irregular ref or alt variant letters
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ $4 = toupper($4); $5 = toupper($5); if($0 !~ /^#/ && ($4 !~ /^[ATGC]+$/ || $5 !~ /^[ATGC]+$/)){ print $0 }}' }
      file: fix_mt_length_in_vcf/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + "_irregular_ref_alt.vcf";}
    out: [output]

  transanno:
    doc: liftover from GRCh37 to GRCh38 by transanno liftvcf command
    run: commands/transanno-liftvcf.cwl
    scatter: [input_vcf]
    scatterMethod: dotproduct
    in:
      chain_file: chain_file
      input_vcf: to_upper_ref_alt/output
      ref_fasta: ref_fasta
      ref_fasta_fai: ref_fasta_fai
      query_fasta: query_fasta
      query_fasta_fai: query_fasta_fai
      succeeded_vcf_filename:
         valueFrom: ${ return inputs.input_vcf.nameroot + "_transanno_succeeded.vcf"; }
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
        valueFrom: ${ return inputs.file.nameroot + "_excl_multi_alt.vcf";}
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

  sort_vcf:
    doc: sort vcf 
    run: commands/bcftools-sort.cwl
    scatter: [file, outFileName]
    scatterMethod: dotproduct
    in:
      file: exclude_multiallelic_alt/output
      outFileName: output_vcf 
    out: [output]

  bgzip_vcf:
    doc: bgzip output vcf file
    run: https://raw.githubusercontent.com/nigyta/rice_reseq/master/tools/bgzip-vcf.cwl 
    scatter: vcf 
    scatterMethod: dotproduct
    in:
      vcf: sort_vcf/output 
    out: [bgzipped_vcf]

outputs:
  liftover_succeeded:
    type: 
      type: array
      items: File
    outputSource: bgzip_vcf/bgzipped_vcf
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
