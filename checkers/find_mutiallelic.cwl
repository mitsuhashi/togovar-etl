cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  in_vcfsdir: Directory
  include_pattern: string 
  exclude_vcfs:
    type:
      type: array
      items: File 
  reheader_file: File

steps:
  get_vcf_gz:
    doc: input vcf.gz files from 
    run: ./commands/get-vcf.cwl
    in:
      vcfsdir: in_vcfsdir
      include_pattern: include_pattern
      exclude_vcfs: exclude_vcfs
    out: [output]

  gunzip_vcf:
    doc: unzip input vcf file
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/gzip.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      d: { default: True }
      file: get_vcf_gz/output
    out: [output] 

  collect_multiallelic_alt:
    doc: collect a converted variant that has multiallelic ALT
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($5 ~ /[,]/){ print $0 }}' }
      file: gunzip_vcf/output
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + "_multi_alt.vcf";}
    out: [output]

  bgzip_vcf:
    doc: bgzip output vcf file
    run: https://raw.githubusercontent.com/nigyta/rice_reseq/master/tools/bgzip-vcf.cwl 
    scatter: vcf 
    scatterMethod: dotproduct
    in:
      vcf: collect_multiallelic_alt/output 
    out: [bgzipped_vcf]

outputs:
  multiallelic_vcf:
    type: 
      type: array
      items: File
    outputSource: collect_multiallelic_alt/output
