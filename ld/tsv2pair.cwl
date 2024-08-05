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

steps:
  get_tsv_gz_files:
    doc: collect vcf.gz files in dirctory
    run: ../commands/get-files.cwl
    in:
      in_dir: in_tsv_dir
      include_pattern: include_pattern
      exclude_files: exclude_files
    out: [output]

  gunzip_tsv:
    doc: unzip input tsv file
    run: ../commands/gzip.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      d: { default: True }
      file: get_tsv_gz_files/output 
    out: [output]

  tsv2pair_r2:
    doc: convert tsv format to pair format including R2
    run: ../commands/ld-tsv2pair.cwl
    scatter: input_file 
    scatterMethod: dotproduct
    in:
      input_file: gunzip_tsv/output
      output_file: 
        valueFrom: ${ return inputs.input_file.nameroot + ".tsv";}
      score_type: { default: "R2" }
    out: [output] 

outputs:
  hic_r2:
    type:
      type: array
      items: File
    outputSource: tsv2pair_r2/output
