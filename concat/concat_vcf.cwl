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

inputs:
  vcf_files:
    type: File[]
    inputBinding:
      position: 1
  output_file:
    type: string?
    inputBinding:
      position: 2
      prefix: -o

outputs:
  merged_vcf:
    type: File
    outputBinding:
      glob: $(inputs.output_file)

arguments:
  - position: 3
    valueFrom: "-o"

steps:
  bcftools_concat:
    doc: concat vcf files using bcftools concat  
    run: ./commands/bcftools-concat.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      d: { default: True }
      file: input_vcf
    out: [output]

    in:
      vcf_files: in_tsv_dir
      include_pattern: include_pattern
      exclude_files: exclude_files
    out: [output]

  sort_vcf:
    doc: sort vcf
    run: commands/bcftools-sort.cwl
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
  vcf:
    type: 
      type: array
      items: File
    outputSource: bgzip_vcf/bgzipped_vcf
  biallelic_vcf_tbi:
    type: 
      type: array
      items: File
    outputSource: tabix_vcf/tbi
