class: CommandLineTool
cwlVersion: v1.2

label: convert-togovar-tsv-grch38-to-vcf-data
doc: This tools convert GRCh38 tsv files from TogoVar to VCF data lines. 

hints:
  DockerRequirement:
    dockerImageId: cwl-convert-togovar-tsv-to-vcf-data:3.9
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
      - entryname: convert-togovar-tsv-grch38-to-vcf-data.py
        entry: |
          import sys
          import csv
          import gzip

          def make_dataset_info(dataset_name, row):
            if(row[0] == '-'):
              info = []
            else:
              info = ["AC_" + dataset_name + "=" + row[0],
                      "AN_" + dataset_name + "=" + row[1],
                      "AF_" + dataset_name + "=" + row[2]]
            if(row[3] != '-'):
               info.append("QC_STATUS_" + dataset_name + "=" + row[3])
            return info

          def make_dataset_info_with_genotype_count(dataset_name, row):
            if(row[0] == '-'):
              info = []
            else:
              info = ["AC_" + dataset_name + "=" + row[0],
                      "AN_" + dataset_name + "=" + row[1],
                      "AF_" + dataset_name + "=" + row[2],
                      "GC_" + dataset_name + "=" + ",".join([row[5],row[4],row[3]])] # See Genotype Ordering at https://samtools.github.io/hts-specs/VCFv4.3.pdf
            if(row[6] != '-'):
               info.append("QC_STATUS_" + dataset_name + "=" + row[6])
            return info

          def make_info_element(key, value):
            if(value == '-' or value == ''):
              info = []
            else:
              info = [key + "=" + value]
            return info

          def make_info(row):
            rs_id = make_info_element("RS_ID", row[1])
            gene_symbol = make_info_element("GENE_SYMBOL", row[7])
            jga_ngs = make_dataset_info("JGA_NGS", row[8:12])
            jga_snp = make_dataset_info_with_genotype_count("JGA_SNP", row[12:19])
            tommo = make_dataset_info("TOMMO", row[19:23])
            hgvd = make_dataset_info("HGVD", row[23:27])
            gem_j_wga = make_dataset_info("GEM_J_WGA", row[27:31])
            gnomad_genomes = make_dataset_info("GNOMAD_GENOMES", row[31:35])

            info = []
            for info_element in [rs_id, gene_symbol, jga_ngs, jga_snp, tommo, gem_j_wga, gnomad_genomes]:
              if info_element:
                info.append(";".join(info_element))
            info = ";".join(info)

            return info

          def convert_tsv_to_vcf_dataline(tsv_gz_file):
            with gzip.open(tsv_gz_file, "rt", encoding="utf-8", newline="") as tsv_file:
              tsv_reader = csv.reader(tsv_file, delimiter="\t")
              tsv_header = next(tsv_reader) # skip tsv header line
              for row in tsv_reader:
                chr = row[3]
                pos = row[4]
                tgv_id = "" if row[0] == '-' else row[0]
                ref = row[5]
                alt = row[6]
                qual = "."
                format = "."
                info = make_info(row)
                print("\t".join([chr, pos, tgv_id, ref, alt, qual, format, info]))

          if __name__ == '__main__':
            tsv_gz_file = sys.argv[1]
            convert_tsv_to_vcf_dataline(tsv_gz_file)

inputs:
  tsv_gz_file:
    type: File
    inputBinding:
      position: 1
  outFileName:
    type: string
    inputBinding:
      position: 2
outputs:
  output:
    type: stdout

stdout: $(inputs.outFileName)

baseCommand: ["python","convert-togovar-tsv-grch38-to-vcf-data.py"]

$namespaces:
  s: http://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0003-3300-7308
    s:email: mailto:mitsuhashi@dbcls.rois.ac.jp
    s:name: Nobutaka Mitsuhashi

$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf
