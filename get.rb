require 'csv'
require 'pry'

csv_files = Dir.glob("import/*.csv")

csv_files.each do |f|
  
  cntr = 0
  CSV.foreach(
   f, 
    :encoding => 'iso-8859-1:utf-8'
  ) do |row|
    item = row
    cntr += 1
  end
  
  tab = f.size > 22 ? "\t" : "\t\t"
  puts f + ":" + tab + cntr.to_s
end
