cwlVersion: v1.2
class: CommandLineTool
label: "Convert the Short with score format to .hic format using Juicer Tools"
id: "juicertools-pre"
baseCommand: ["java", "-Xms40000m", "-Xmx40000m", "-jar"]

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 40000 
    ramMax: 400000 

inputs:
  jar_path:
    type: File
    inputBinding:
      position: 1
    doc: "Path of JuicerTool.jar"

  pre:
    type: string
    inputBinding:
      position: 2
    doc: "Argument of JuicerTool.jar for specifying 'pre' commnad"

  input_short_with_score:
    type: File
    inputBinding:
      position: 3
    doc: "Input file in 'Short with score' format."

  output_hic_name:
    type: string
    inputBinding:
      position: 4
    doc: "Name for the output .hic file."

  genome_id:
    type: string
    inputBinding:
      position: 5
    doc: "Genome identifier, e.g., hg19, mm10."

outputs:
  output_hic:
    type: File
    outputBinding:
      glob: "$(inputs.output_hic_name)"

stdout: output.log
stderr: error.log
