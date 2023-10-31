cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bcftools", "annotate"]

inputs:
  header_line_file:
    type: File
    inputBinding:
      prefix: --header-lines
      position: 1
  file:
    type: File
    inputBinding:
      position: 2
  outFileName:
    type: string
    doc: Out put file name
    inputBinding:
      position: 3

outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
