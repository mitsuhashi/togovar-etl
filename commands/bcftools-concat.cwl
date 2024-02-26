cwlVersion: v1.2
class: CommandLineTool
baseCommand: [bcftools, concat]

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

stdout: $(inputs.output_file)
