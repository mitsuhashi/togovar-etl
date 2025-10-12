cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bcftools", "annotate"]

inputs:
  removed_fields:
    type: string
    doc: Fields to remove 
    inputBinding:
      position: 1
      prefix: --remove
  file:
    type: File
    inputBinding:
      position: 2
  outFileName:
    type: string
    doc: Output file name
    inputBinding:
      position: 3
      prefix: -o

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
