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
  jar_path: File
  output_file_prefix: string

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
    doc: convert tsv format to the Short with score format including R2, which can be converted to *.hic
    run: ../commands/ld-tsv2pair.cwl
    scatter: input_file 
    scatterMethod: dotproduct
    in:
      input_file: gunzip_tsv/output
      output_file: 
        valueFrom: ${ return inputs.input_file.nameroot + ".tsv";}
      score_type: { default: "R2" }
    out: [output] 

  pair2hic_r2:
    doc: convert pair format to hic format including R2
    run: ../commands/ld-pair2hic.cwl
    scatter: input_short_with_score
    scatterMethod: dotproduct
    in:
      jar_path: jar_path
      pre: { default: "pre" }
      input_short_with_score: tsv2pair_r2/output
      output_file_prefix: output_file_prefix 
      output_hic_name:
        valueFrom: |
          ${
            var match = inputs.input_short_with_score.basename.match(/chr(\d+|X|Y|M)/);
            var chr = match[0];
            return inputs.output_file_prefix + "." + chr + ".r2.hic";
          }
      genome_id: { default: "hg38" }
    out: [output_hic]

  tsv2pair_dprime:
    doc: convert tsv format to pair format including DPrime
    run: ../commands/ld-tsv2pair.cwl
    scatter: input_file
    scatterMethod: dotproduct
    in:
      input_file: gunzip_tsv/output
      output_file:
        valueFrom: ${ return inputs.input_file.nameroot + ".tsv";}
      score_type: { default: "Dprime" }
    out: [output]

  pair2hic_dprime:
    doc: convert pair format to hic format including DPrime
    run: ../commands/ld-pair2hic.cwl
    scatter: input_short_with_score
    scatterMethod: dotproduct
    in:
      jar_path: jar_path
      pre: { default: "pre" }
      input_short_with_score: tsv2pair_dprime/output
      output_file_prefix: output_file_prefix
      output_hic_name:
        valueFrom: |
          ${
            var match = inputs.input_short_with_score.basename.match(/chr(\d+|X|Y|M)/);
            var chr = match[0];
            return inputs.output_file_prefix + "." + chr + ".dprime.hic";
          }
      genome_id: { default: "hg38" }
    out: [output_hic]

outputs:
  hic_r2:
    type:
      type: array
      items: File
    outputSource: pair2hic_r2/output_hic
  hic_dprime:
    type:
      type: array
      items: File
    outputSource: pair2hic_dprime/output_hic
