cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bcftools", "head", "--headers"]

inputs:
  file:
    type: File
    inputBinding:
      position: 1
  outFileName:
    type: string
    doc: Out put file name
    inputBinding:
      position: 2

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
