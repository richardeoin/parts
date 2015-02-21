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
  suppliers = []
  i = 0

  # Try farnell
  farnell = scrape_farnell(fields[i])
  if farnell
    puts " -- Found at Farnell: "+farnell[:partname]
    suppliers.push(farnell)
    i = i + 1
  end

  # Try mouser
  mouser = scrape_mouser(fields[i])
  if mouser
    puts " -- Found at Mouser: "+mouser[:partname]
    suppliers.push(mouser)
    i = i + 1
  end

  # Next we should have a quantity
  quantity = fields[i].to_i

  # If this is a valid output
  if suppliers[0] and quantity

    # Parse links into markdown
    links = suppliers.map do |supplier|
      "[#{supplier[:order_code]}](#{supplier[:page]})"
    end

    # Processed output
    output = "|#{suppliers[0][:partname]}|#{suppliers[0][:desc]}"+
      "|#{links.join(" ")}|#{quantity}|#{fields[i+1..-1].join(" ")}"

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
