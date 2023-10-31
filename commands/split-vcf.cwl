cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["split", "-d"]
inputs:
  lines:
    type: long 
    inputBinding:
      prefix: --lines
      position: 1
  additional_suffix:
    type: string
    inputBinding:
      prefix: --additional-suffix
      position: 2
  suffix_length:
    type: int
    inputBinding:
      prefix: --suffix-length
      position: 3
  file:
    type: File
    inputBinding:
      position: 4
  basename:
    type: string
    inputBinding:
      position: 5
outputs:
  output:
    type: File[]
    outputBinding: 
      glob: "*.vcf"

#stdout: $(inputs.outFileName)
