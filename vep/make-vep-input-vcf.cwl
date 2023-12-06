cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  vcf_dir: Directory
  vcf_include_pattern: string 
  vcf_exclude_files:
    type:
      type: array
      items: File
  split_variants_per_file: long 
  suffix_length: int 
  vcf_header_file: File

steps:
  get_vcf_gz:
    doc: get input vcf files from directory 
    run: ./commands/get-files.cwl
    in:
      in_dir: vcf_dir
      include_pattern: vcf_include_pattern
      exclude_files: vcf_exclude_files
    out: [output]

  gunzip_vcf:
    doc: unzip input vcf files
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/gzip.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      d: { default: True }
      file: get_vcf_gz/output
    out: [output]

  get_chr_pos_ref_alt_from_vcf:
    doc: 
    run: https://raw.githubusercontent.com/ncbi/cwl-ngs-workflows-cbb/master/tools/basic/awk.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      F: { default: "\t" }
      text: { default: 'BEGIN{ OFS="\t" }{ if($0 !~ /^#/){ print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 }}' }
      file: gunzip_vcf/output
      outFileName:
        valueFrom: ${ return inputs.file.basename; }
    out: [output]

  split_vcf:
    doc: split vcf body lines into a number of vcf files 
    run: ./commands/split-vcf.cwl
    scatter: file 
    scatterMethod: dotproduct
    in:
       lines: split_variants_per_file
       additional_suffix:
         valueFrom: ${ return ".vcf"; }
       suffix_length: suffix_length
       file: get_chr_pos_ref_alt_from_vcf/output 
       basename:
         valueFrom: ${ return inputs.file.basename.replace('.vcf','_'); }
    out: [output]

  flatten-vcf-array:
    run: ./commands/flatten-array-file.cwl
    in:
      2d-array: split_vcf/output
    out: [flattened_array]

  sort_vcf_body:
    doc: sort vcf body
    run: commands/sort-vcf.cwl
    scatter: file
    scatterMethod: dotproduct
    in:
      file: flatten-vcf-array/flattened_array
      outFileName:
        valueFrom: ${ return inputs.file.nameroot + ".vcf";}
    out: [output]

  cat_header_body:
    doc: cat VCF header and body
    run: ./commands/cat.cwl
    scatter: tail_file
    scatterMethod: dotproduct
    in:
      head_file: vcf_header_file
      tail_file: sort_vcf_body/output
      outFileName:
        valueFrom: ${ return inputs.tail_file.nameroot + ".vcf"; }
    out: [output]

  bgzip_vcf:
    doc: bgzip output vcf file
    run: https://raw.githubusercontent.com/nigyta/rice_reseq/master/tools/bgzip-vcf.cwl 
    scatter: vcf 
    scatterMethod: dotproduct
    in:
      vcf: cat_header_body/output 
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
