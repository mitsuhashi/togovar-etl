cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bcftools", "sort"]

inputs:
  file:
    type: File
    inputBinding:
      position: 1

outputs:
  output:
    type: stdout

stdout: $(inputs.file.basename).sorted.vcf
