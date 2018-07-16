require 'csv'
require 'pry'
require 'net/http'

class ImportSistina 
  def initialize
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

  def codes_uri
    URI('http://localhost:3000/codes')
  end

  def get_codes
    Net::HTTP.get(codes_uri)
  end

  def load_codes
    CSV.foreach(
      codes_file, 
      :encoding => 'iso-8859-1:utf-8'
    ) do |row|
      Net::HTTP.post_form(
        codes_uri, 
        'cs' => row[0], 
        'non10' => row[1],
        'content' => row[2], 
        't_' => row[3],
        'material' => row[4],
        'n_' => row[5],
        'size' => row[6],
        'place' => row[7],
        'date' => row[8],
        'owner0' => row[9],
        'title_comment' => row[10],
        'binding_comment' => row[11],
        'pagenumbering' => row[12],
        'non0' => row[13],
        'non4' => row[14],
        'comment0' => row[15],
        'non1' => row[16],
        'non2' => row[17],
        'comment1' => row[18],
        'non11' => row[19],
        'notation' => row[20],
        'non3' => row[21],
        'owner1' => row[22],
        'non12' => row[23],
        'non5' => row[24],
        'non13' => row[25],
        'non6' => row[26],
        'comment2' => row[27],
        'non7' => row[28],
        'libsig' => row[29],
        'lit' => row[30],
        'non14' => row[31],
        'non8' => row[32],
        'sig0' => row[33],
        'non15' => row[34],
        'non9' => row[35],
        'sig1' => row[36],
        'sig2' => row[37],
        'comment3' => row[38]
      )
    end
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

