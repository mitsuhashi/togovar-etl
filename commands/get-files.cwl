cwlVersion: v1.2
class: ExpressionTool
doc: "Retrieve files in the in_dir that match include_patten and don't match exclude_files."
requirements:
  InlineJavascriptRequirement: {}
hints:
  LoadListingRequirement:
    loadListing: shallow_listing
inputs:
  in_dir: Directory
  include_pattern: string?
  exclude_files:
    type: File[]?
outputs:
  output:
    type: File[]
expression: |
  ${
    var output = [];
    var include_pattern = new RegExp(inputs.include_pattern);
    for (var i = 0; i < inputs.in_dir.listing.length; i++) {
      var file = inputs.in_dir.listing[i];
      if (include_pattern.test(file.basename)) {
        var main = file;
        var is_exclude = false;
        for (var j = 0; j < inputs.exclude_files.length; j++) {
          if(main.basename == inputs.exclude_files[j].basename){ is_exclude = true; }
        }
        if (is_exclude == false){ output.push(main); }
      }
    }
    return {"output": output};
  }
