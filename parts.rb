## Takes a simple whitespace-separated parts list and outputs in
## markdown

require 'parallel'

require_relative 'farnell'
require_relative 'mouser'

puts "Tracking parts..."

input_filename = 'parts'
output_filename = 'Parts.md'

# Read the input file into a Hash
input_rows = File.readlines(input_filename)

# Process each input row concurrently
output_rows = Parallel.map(input_rows){|line|

  fields = line.split
  i = 0

  # Try farnell
  farnell = scrape_farnell(fields[i])
  if farnell
    i = i + 1
  end

  # Try mouser
  mouser = scrape_mouser(fields[i])
  if mouser
    i = i + 1
  end

  # Next we should have a quantity
  quantity = fields[i].to_i

  if farnell and quantity
    puts " -- Found at Farnell: "+farnell[:partname]

    supplier_details = "|#{farnell[:partname]}"+
      "|#{farnell[:desc]}"+
      "|[#{farnell[:order_code]}](#{farnell[:page]})"
  end

  if mouser and quantity
    puts " -- Found at Mouser: "+mouser[:partname]

    supplier_details = "|#{mouser[:partname]}"+
      "|#{mouser[:desc]}"+
      "|[#{mouser[:order_code]}](#{mouser[:page]})"
  end

  if supplier_details
    # Processed output
    output = supplier_details+"|#{quantity}|#{fields[i+1..-1].join(" ")}"
  else
    # Output unchanged
    output = line
  end

  output
}

# And dump to the output file
output = File.open(output_filename, "w")
output.puts output_rows
output.close
