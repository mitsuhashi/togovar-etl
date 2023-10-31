cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bgzip", "-c"]

inputs:
  file:
    type: File
    inputBinding:
      position: 1
  outFileName:
    type: string

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
