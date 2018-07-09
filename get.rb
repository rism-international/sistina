require 'csv'
require 'pry'
require 'net/http'

class Sistina 
  def init
    @uri = URI('http://localhost')
  end
  def csv_files
    Dir.glob("import/*.csv")
  end

  def pieces_file
    csv_files.find {|e| e.match(/St.cke/) }
  end

  def parts_file
    csv_files.find {|e| e.match(/Teile/) }
  end

  def codes_file
    csv_files.find {|e| e.match(/Kodizes/) }
  end

  def concordances_file
    csv_files.find {|e| e.match(/Konkordanzen/) }
  end

  def units_file
    csv_files.find {|e| e.match(/Einh/) }
  end

  def load
    CSV.foreach(
      codes_file, 
      :encoding => 'iso-8859-1:utf-8'
    ) do |row|
      row
    end
  end

  def export_sample_files
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
      tab = f.size > 22 ? "\t" : "\t\t"
      puts f + ":" + tab + cntr.to_s
    end
  end
end

