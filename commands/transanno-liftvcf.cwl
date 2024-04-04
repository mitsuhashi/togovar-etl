cwlVersion: v1.2
class: CommandLineTool

#hints:
#- $import: transanno-docker.yml

baseCommand: ["transanno", "liftvcf", "--no-left-align-chain"]
inputs:
  chain_file:
    type: File
    inputBinding:
      prefix: --chain
  succeeded_vcf_filename:
    type: string 
    inputBinding:
      prefix: --output
      valueFrom: "$(runtime.outdir)/$(inputs.succeeded_vcf_filename)"
  query_fasta:
    type: File
    inputBinding:
      prefix: --query
    secondaryFiles:
      - .fai
  ref_fasta:
    type: File
    inputBinding:
      prefix: --reference
    secondaryFiles:
      - .fai
  input_vcf:
    type: File
    inputBinding:
      prefix: --vcf
  failed_vcf_filename:
    type: string
    inputBinding:
      prefix: --fail
      valueFrom: "$(runtime.outdir)/$(inputs.failed_vcf_filename)"
outputs:
  vcf_succeeded:
    type: File
    outputBinding:
      glob: "$(inputs.succeeded_vcf_filename)"
  vcf_failed:
    type: File
    outputBinding:
      glob: "$(inputs.failed_vcf_filename)"
