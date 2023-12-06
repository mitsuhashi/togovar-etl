cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  in_tsv_dir: Directory
  include_pattern: string 
  exclude_files:
    type:
      type: array
      items: File
  vcf_header_file: File

steps:
  get_tsv_gz_files:
    doc: 
    run: ../commands/get-files.cwl
    in:
      in_dir: in_tsv_dir
      include_pattern: include_pattern
      exclude_files: exclude_files
    out: [output]

  convert_togovar_tsv_to_vcf_data:
    doc: convert togovar tsv to vcf data
    run: ../commands/convert-togovar-tsv-grch38-to-vcf-data.cwl
    scatter: tsv_gz_file
    scatterMethod: dotproduct
    in:
      tsv_gz_file: get_tsv_gz_files/output
      outFileName:
        valueFrom: ${ return inputs.tsv_gz_file.nameroot.replace(".tsv","") + ".vcf"; }
    out: [output]

  cat_header_body:
    doc: cat VCF header and body
    run: ../commands/cat.cwl 
    scatter: tail_file
    scatterMethod: dotproduct
    in:
      head_file: vcf_header_file
      tail_file: convert_togovar_tsv_to_vcf_data/output
      outFileName:
        valueFrom: ${ return inputs.tail_file.nameroot + ".vcf"; }
    out: [output]

  sort_vcf:
    doc: sort vcf
    run: ../commands/bcftools-sort.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      file: cat_header_body/output
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
    doc: tabix output vcf file
    run: ./commands/tabix.cwl
    scatter: vcf_gz
    scatterMethod: dotproduct
    in:
      vcf_gz: bgzip_vcf/bgzipped_vcf
    out: [tbi]

outputs:
  biallelic_vcf:
    type:
      type: array
      items: File
    outputSource: bgzip_vcf/bgzipped_vcf
  biallelic_vcf_tbi:
    type:
      type: array
      items: File
    outputSource: tabix_vcf/tbi
