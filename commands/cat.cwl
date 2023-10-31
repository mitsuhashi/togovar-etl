cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["cat"]

inputs:
  head_file:
    type: File
    inputBinding:
      position: 1
  tail_file:
    type: File
    inputBinding:
      position: 2
  outFileName:
    type: string

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
