cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bcftools", "annotate", "-x", "INFO", "-Oz"]

inputs:
  file:
    type: File
    inputBinding:
      position: 1
  outFileName:
    type: string
    doc: Output file name
    inputBinding:
      position: 2
      prefix: -o

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
