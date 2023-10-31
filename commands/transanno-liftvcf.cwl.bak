cwlVersion: v1.2
class: CommandLineTool

##hints:
#  - $import: transanno-docker.yml
# - $import: transanno-transanno.yml

baseCommand: ["transanno", "liftvcf"]
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
      prefix: --new-assembly
  query_fasta_fai:
    type: File
    inputBinding:
      prefix: --new-assembly-fai
  ref_fasta:
    type: File
    inputBinding:
      prefix: --original-assembly
  ref_fasta_fai:
    type: File
    inputBinding:
      prefix: --original-assembly-fai
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
      glob: "*_succeeded.vcf"
  vcf_failed:
    type: File
    outputBinding:
      glob: "*_failed.vcf"
