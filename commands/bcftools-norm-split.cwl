cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["bcftools", "norm", "--do-not-normalize", "--multiallelics", "-any"]

inputs:
  file:
    type: File
    inputBinding:
      position: 1
  output_type:
    type: string
    inputBinding:
      prefix: --output-type
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
