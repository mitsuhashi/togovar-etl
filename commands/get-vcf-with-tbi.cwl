cwlVersion: v1.2
class: ExpressionTool
doc: "Process a directory of bgzipped and indexed vcf files into an array with indices as secondary files."
requirements:
  InlineJavascriptRequirement: {}
hints:
  LoadListingRequirement:
    loadListing: shallow_listing
inputs:
  vcfsdir: Directory
  include_pattern: string?
  exclude_vcfs:
    type: File[]?
outputs:
  vcfs:
    type: File[]
    secondaryFiles: [.tbi]
expression: |
  ${
    var vcfs = [];
    var include_pattern = new RegExp(inputs.include_pattern);
    for (var i = 0; i < inputs.vcfsdir.listing.length; i++) {
      var file = inputs.vcfsdir.listing[i];
      if (include_pattern.test(file.basename)) {
        var main = file;
        for (var j = 0; j < inputs.vcfsdir.listing.length; j++) {
          var file = inputs.vcfsdir.listing[j];
          if (file.basename == main.basename+".tbi") {
            main.secondaryFiles = [file];
            break;
          }
        }
        var is_exclude = false;
        for (var k = 0; k < inputs.exclude_vcfs.length; k++) {
          if(main.basename == inputs.exclude_vcfs[k].basename){ is_exclude = true; }
        }
        if (is_exclude == false){ vcfs.push(main); }
      }
    }
    return {"vcfs": vcfs};
  }
