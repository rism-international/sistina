require 'csv'
require 'pry'

csv_files = Dir.glob("import/*.csv")

csv_files.each do |f|
  
  cntr = 0
  item = []
  CSV.foreach(
   f, 
    :encoding => 'iso-8859-1:utf-8'
  ) do |row|
    item << row if cntr < 20 
    cntr += 1
  end
  
  sample = File.basename(f, ".csv") + ".spl"
  spl = File.new( "import/samples/" + sample, "w")
  spl.write(item.join("\n"))
#  puts item.join("\t") 
  tab = f.size > 22 ? "\t" : "\t\t"
  puts f + ":" + tab + cntr.to_s
end
