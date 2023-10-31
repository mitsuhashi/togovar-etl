cwlVersion: v1.0
class: CommandLineTool

baseCommand: [cat]

inputs:
  input_files:
    type: File[]
  outFileName:
    type: string

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
