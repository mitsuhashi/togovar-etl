#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.vcf_gz)

baseCommand: ["tabix", "-f"]

inputs:
  vcf_gz:
    type: File
    inputBinding:
      position: 0

outputs:
  tbi:
    type: File
    outputBinding:
      glob: "$(inputs.vcf_gz.basename).tbi"
