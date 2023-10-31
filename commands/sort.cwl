cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["sort"]

doc: SORT command
label: sort
hints:
  - class: DockerRequirement
    dockerPull: 'ubuntu:22.04'

requirements:
  - class: InlineJavascriptRequirement

inputs:
  k:
    type: int?
    inputBinding:
      position: 1
      prefix: '-k'
  u:
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-u'
  n: 
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-n'
  file:
    type: File
    inputBinding:
      position: 2
  outFileName:
    type: string
outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
