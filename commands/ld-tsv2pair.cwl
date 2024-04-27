class: CommandLineTool
cwlVersion: v1.2

label: convert-ld-tsv-pear
doc: This tool converts linkage disequilibrium coefficient data in tsv format to pear format. 

hints:
  DockerRequirement:
    dockerImageId: cwl-ld-tsv2pear:3.9
    dockerFile: |
      # Base Image
      FROM quay.io/biocontainers/python:3.9

      # Metadata
      LABEL base.image="quay.io/biocontainers/python:3.9"
      LABEL version="1"
      LABEL software="Python3"
      LABEL software.version="3.9"
      LABEL description="Python based docker image"
      LABEL tags="Python"

      # Maintainer
      MAINTAINER Nobutaka Mitsuhashi

      USER root

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entryname: 'convert-tsv-to-pear.py'
        entry: |
          import sys
          input_file = sys.argv[1]
          output_file = sys.argv[2]
          score_type = sys.argv[3]
          with open(input_file, 'r') as f:
            for line in f:
              if line.startswith('chr'):
                parts = line.strip().split('\t')
                str1 = "0"
                chr1, pos1, _, _ = parts[0].split(':')
                frag1 = "0"
                str2 = "0"
                chr2, pos2, _, _ = parts[1].split(':')
                frag2 = "0"
                if(score_type == "R2"):
                  score = parts[2]  # Using R2 as the score
                elif(score_type == "Dprime"):
                  score = parts[3]  # Using Dprime as the score
                else:
                  raise ValueError("score_type must be 'R2' or 'Dprime'")
                print(f"{str1} {chr1} {pos1} {frag1} {str2} {chr2} {pos2} {frag2} {score}")

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1
  output_file:
    type: string
    inputBinding:
      position: 2
  score_type:
    doc: "LD score type: R2 or Dprime"
    type: string
    inputBinding:
      position: 3
outputs:
  output:
    type: stdout

stdout: $(inputs.output_file)


baseCommand: ["python","convert-tsv-to-pear.py"]

$namespaces:
  s: http://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0003-3300-7308
    s:email: mailto:mitsuhashi@dbcls.rois.ac.jp
    s:name: Nobutaka Mitsuhashi

$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf
