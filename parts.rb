## Takes a simple whitespace-separated parts list and outputs in
## markdown

require_relative 'farnell'

output = File.open("Parts.md", "w")

# Parse the input file
File.readlines('parts').each do |line|
  fields = line.split
  i = 0

  # Try farnell
  farnell = scrape_farnell(fields[i])
  if farnell
    i = i + 1
  end

  # Next we should have a quantity
  quantity = fields[i].to_i

  if farnell and quantity
    puts farnell[:partname]

    output.puts "|#{farnell[:partname]}"+
      "|#{farnell[:desc]}"+
      "|[#{farnell[:order_code]}](#{farnell[:page]})"+
      "|#{quantity}"+
      "|#{fields[i..-1].join}"
  else

    # Output unchanged
    output << line
  end

end

output.close
