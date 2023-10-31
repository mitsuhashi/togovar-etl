cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["sort", "-k", "2n"]

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
