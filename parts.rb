## Takes a simple whitespace-separated parts list and outputs in
## markdown

require 'parallel'

require_relative 'farnell'
require_relative 'mouser'

puts "Tracking parts..."

input_filename = 'parts'
output_markdown = 'Parts.md'
output_farnell_csv = 'farnell.csv'
output_mouser_csv = 'mouser.csv'

# Read the input file into a Hash
input_rows = File.readlines(input_filename)

# Process each input row concurrently
output_rows = Parallel.map(input_rows){|line|

  fields = line.split
  suppliers = []
  output = Hash.new
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
    output[:markdown] = "|#{suppliers[0][:partname]}|#{suppliers[0][:desc]}"+
      "|#{links.join(" ")}|#{quantity}|#{fields[i+1..-1].join(" ")}"

    desc = fields[i+1..-1].join(" ").gsub(",", " -")

    # Farnell CSV
    if farnell
      output[:farnell_csv] = "#{farnell[:order_code]}, #{quantity}, #{desc}"
    end

    # Mouser CSV
    if mouser
      output[:mouser_csv] = "#{mouser[:order_code]}, #{quantity}, #{desc}"
    end

  else
    # Output unchanged
    output[:markdown] = line
  end

  output
}

# Write out markdown
File.open(output_markdown, "w") do |markdown|
  markdown.puts output_rows.map{ |m| m[:markdown] }
end

# Write out farnell csv
File.open(output_farnell_csv, "w") do |fcsv|
  # Output valid rows
  for f in output_rows.map{ |f| f[:farnell_csv] }
    if f
      fcsv.puts f
    end
  end
end

# Write out mouser csv
File.open(output_mouser_csv, "w") do |mcsv|
  # Header
  mcsv.puts "Mouser Part Number, Quantity 1, Description"
  # Output valid rows
  for m in output_rows.map{ |m| m[:mouser_csv] }
    if m
      mcsv.puts m
    end
  end
end
