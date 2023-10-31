cwlVersion: v1.0
class: ExpressionTool
doc: Transpose a given array (https://raw.githubusercontent.com/wtsi-hgi/arvados-pipelines/master/cwl/expression-tools/flatten-array-file.cwl)

requirements:
  - class: InlineJavascriptRequirement

expression: "$({'flattened_array': [].concat.apply([], inputs['2d-array'])})"

inputs:
  - id: 2d-array
    type:
      type: array
      items:
        type: array
        items: File

outputs:
  - id: flattened_array
    type:
      type: array
      items: File
