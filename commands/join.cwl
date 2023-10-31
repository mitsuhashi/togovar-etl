cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["join"]

doc: join two files 
label: join 

inputs:
  one:
    type: string?
    inputBinding:
      prefix: '-1'
      position: 1
  two:
    type: string?
    inputBinding:
      prefix: '-2'
      position: 1
  t:
    type: string?
    inputBinding:
      prefix: -t
      position: 1
  a:
    type: string?
    inputBinding:
      prefix: -a
      position: 1
  e:
    type: string?
    inputBinding:
      prefix: -e
      position: 1
  o:
    type: string?
    inputBinding:
      prefix: -o
      position: 1
  input1:
    type: File
    doc: input file to join input2
    inputBinding:
      position: 2
  input2:
    type: File
    doc: input file to join input1
    inputBinding:
      position: 3
  outFileName:
    type: string
    doc: Output file name
outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)
