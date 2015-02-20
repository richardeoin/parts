## Takes a simple whitespace-separated parts list and outputs in
## markdown

require_relative 'farnell'
require_relative 'mouser'

puts "Tracking parts..."

input_filename = 'parts'
output_filename = 'Parts.md'

output = File.open(output_filename, "w")

# Parse the input file
File.readlines(input_filename).each do |line|
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
    output.puts supplier_details+"|#{quantity}|#{fields[i+1..-1].join(" ")}"
  else
    # Output unchanged
    output << line
  end

end

output.close
