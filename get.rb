require 'csv'
require 'pry'

CSV.foreach(
  "import/Konkordanzen.csv", 
  :encoding => 'iso-8859-1:utf-8'
) do |row|
  item = row
  binding.pry
end
