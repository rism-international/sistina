require 'csv'
require 'pry'
require 'net/http'

#module FCS    # Fondo Capella Sistina
  class Import
    def initialize
      @uri = URI('http://localhost')
    end

    def csv_files
      Dir.glob("import/*.csv")
    end

    def pieces_file
      csv_files.find {|e| e.match(/St.cke/) }
    end

    def pieces_uri
      URI('http://localhost:3010/pieces')
    end

    def load_pieces
      CSV.foreach(
        pieces_file, 
        :encoding => 'iso-8859-1:utf-8'
      ) do |row|
        Net::HTTP.post_form(
          pieces_uri,
          'non0' => row[0],
          'non1' => row[1],
          'cs' => row[2], 
          'lit' => row[3], 
          'non2' => row[4],
          'pages' => row[5],
          't_' => row[6],
          'non3' => row[7],
          'current' => row[8],
          'title' => row[9],
          'non4' => row[10],
          'nr' => row[11], 
          'non5' => row[12],
          'nr0' => row[13], 
          'title0' => row[14],
          'title1' => row[15],
          'title2' => row[16],
          'composer' => row[17],
          'composer0' => row[18],
        )
      end
    end
   
    def parts_file
      csv_files.find {|e| e.match(/Teile/) }
    end

    def parts_uri
      URI('http://localhost:3010/parts')
    end

    def load_parts
      CSV.foreach(
        parts_file, 
        :encoding => 'iso-8859-1:utf-8'
      ) do |row|
        Net::HTTP.post_form(
          parts_uri, 
          'nr' => row[0], 
          'part_nr' => row[1], 
          'part_fol' => row[2], 
          'composer' => row[3], 
          'title' => row[4], 
          'textincipit' => row[5], 
          'voices' => row[6], 
          'comment' => row[7], 
        )
      end
    end
   
    def codes_file
      csv_files.find {|e| e.match(/Kodizes/) }
    end

    def codes_uri
      URI('http://localhost:3010/codes')
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

    def concordances_uri
      URI('http://localhost:3010/concordances')
    end

    def get_concordances
      Net::HTTP.get(concordances_uri)
    end

    def load_concordances
      CSV.foreach(
        concordances_file, 
        :encoding => 'iso-8859-1:utf-8'
      ) do |row|
        Net::HTTP.post_form(
          concordances_uri, 
          'nr' => row[0], 
          'ccd0' => row[1], 
          'ccd1' => row[2], 
          'ccd2' => row[3], 
          'comment' => row[4], 
          'composer' => row[5], 
          'title' => row[6], 
        )
      end
    end
   
    def units_file
      csv_files.find {|e| e.match(/Einh/) }
    end

    def units_uri
      URI('http://localhost:3010/units')
    end

    def load_units
      CSV.foreach(
        units_file, 
        :encoding => 'iso-8859-1:utf-8'
      ) do |row|
        Net::HTTP.post_form(
          units_uri,
          't_' => row[0],
          'material' => row[1],
          'comment0' => row[2],
          'cs' => row[3],
          'comment1' => row[4],
          'pages' => row[5],
          'comment2' => row[6],
          'unit_nr' => row[7],
          'comment3' => row[8],
          'notation' => row[9],
          'non0' => row[10],
          'comment5' => row[11],
          'comment6' => row[12],
          'comment7' => row[13],
          'owner' => row[14],
          'non1' => row[15],
          'size' => row[16],
          'non2' => row[17],
          'color0' => row[18],
          'color1' => row[19],
          'color2' => row[20],
          'color3' => row[21],
          'non3' => row[22],
          'comment8' => row[23],
        )
      end
    end

    def populate()
      load_codes
      load_units
      load_pieces
      load_parts
      load_concordances
    end
   
    def load_sample(num)
      cntr = 0
      item = []
      CSV.foreach(
        units_file, 
        :encoding => 'iso-8859-1:utf-8'
      ) do |row|
        item << row if cntr < num
        cntr += 1
      end
      return item
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

    def digivatlib
      baseurl = "https://digi.vatlib.it/view/MSS_Capp.Sist."
      n = 1
      result = []
      while n < 700 do
        url = URI.parse(baseurl + n.to_s)
        puts url
        res = Net::HTTP.get_response(url)
        if res.instance_of? Net::HTTPOK
          result << n
        end
        n += 1
      end
      return result
    end
  end
#end
