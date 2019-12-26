class Code < ApplicationRecord
  self.primary_key = "cs"
  has_many :pieces
  has_many :units
  validates_presence_of :cs
  offset = 85700001
  @rismid = offset

  class << self
    attr_reader :rismid
  end

#  def initialize
#    Code.instance_eval { @rismid += 1 }
#  end

  def build_xml
    Code.instance_eval { @rismid += 1 }
    marcxml = FCS::Node.new
    if make_type == "Print"
      marcxml.leader("ncc")
    else 
      marcxml.leader
    end
    marcxml.controlfield("001", Code.rismid)
    marcxml.datafield("041", "a", "lat")
    tit, shelf, cmpsr = make_standardTitle
    marcxml.datafield("100", "a", cmpsr) unless cmpsr.blank?
    marcxml.datafield("130", "a", tit) # Einordnungstitel
    marcxml.datafield("245", "a", make_titleOnSource)
    df = marcxml.datafield("260", "a", make_place)
    marcxml.addSubfield(df, "b", owner1.gsub(/\v/, ''))
    marcxml.addSubfield(df, "c", make_date)
    marcxml.addSubfield(df, "8", "01")

    # Physical description
    # Dimensions
    df = marcxml.datafield("300", "a", make_format)
    marcxml.addSubfield(df, "b", material.gsub( /\v/, '')) unless material.blank?
    marcxml.addSubfield(df, "c", size)
    marcxml.addSubfield(df, "8", "01")
    if not non0.blank?  
      df = marcxml.datafield("500", "a", "Aktuelle Lagenstrukturen: " + non0.gsub( /\v/, '')) 
      marcxml.addSubfield(df, "8", "01")
    end
    # Comments
    df = marcxml.datafield("500", "a", comment1.gsub( /\v/, ''))
    marcxml.addSubfield(df, "a", title_comment.gsub( /\v/, '').force_encoding("utf-8")) unless title_comment.blank?
    marcxml.addSubfield(df, "a", "Aktuelle Blattzählung: " + pagenumbering.gsub( /\v/, '')) unless pagenumbering.blank?
    marcxml.addSubfield(df, "a", "Notation: #{notation}") unless notation.blank?
#    marcxml.addSubfield(df, "a", "Signatur: " + non7.gsub( /\v/, '')) unless non7.blank?
    marcxml.addSubfield(df, "a", "Dekoration: " + non4.gsub( /\v/, '')) unless non4.blank?
    marcxml.addSubfield(df, "a", "Kommentar zur Lagenstruktur: " + comment0.gsub( /\v/, '')) unless comment0.blank?
    marcxml.addSubfield(df, "a", comment2.gsub( /\v/, '')) unless comment2.blank? # Benutzungsspuren
    marcxml.addSubfield(df, "a", comment3.gsub( /\v/, '')) unless comment3.blank?
    marcxml.addSubfield(df, "a", non1.gsub( /\v/, '')) unless non1.blank?
    marcxml.addSubfield(df, "a", non2.gsub( /\v/, '')) unless non2.blank?
    marcxml.addSubfield(df, "a", non3.gsub( /\v/, '')) unless non3.blank?
    marcxml.addSubfield(df, "a", non11.gsub( /\v/, '')) unless non11.blank?
    marcxml.addSubfield(df, "a", non12.gsub( /\v/, '')) unless non12.blank?
    marcxml.addSubfield(df, "a", non13.gsub( /\v/, '')) unless non13.blank?
    marcxml.addSubfield(df, "a", non14.gsub( /\v/, '')) unless non14.blank?
    marcxml.addSubfield(df, "a", place) unless place.blank?
    p = Part.where(nr: cs * 1000)
    unless p.empty?
      p.each do |i|
        str = ""
        str += "Vorsatz Nr. " + i.part_nr unless i.part_nr.blank?
        str += " " + i.part_fol unless i.part_fol.blank?
        str += " " + i.title unless i.title.blank?
        str += " " + i.composer unless i.composer.blank?
        str += " " + i.textincipit unless i.textincipit.blank?
        str += " " + i.voices unless i.voices.blank?
        str += " " + i.comment.gsub(/\v/, '') unless i.comment.blank?
        marcxml.addSubfield(df, "a", str) unless str.blank?
      end
    end
    u = Unit.where(cs: cs)
    unless u.empty?
      u.each do |i|
        str = ""
        str += (i.non0.gsub(/\v/, '') + ". (Nr. im Codes) ") unless i.non0.blank?
        str += "eigenst. Einh. " + i.pages unless i.pages.blank?
        str += " "
        str += i.t_ unless i.t_.blank?
        str += "; Material: " + i.material unless i.material.blank?
        str += "; Papierfarbe: " + i.comment1 unless i.comment1.blank?
        str += "; Konsistenz: " + i.comment3.gsub(/\v/, '') unless i.comment3.blank?
        str += "; Blindline: " + i.comment0 unless i.comment0.blank?
        str += "; Notation: " + i.notation.gsub(/\v/, '') unless i.notation.blank?
        str += "; " + i.comment5.gsub(/\v/, '') unless i.comment5.blank?
        str += "; " + i.comment6.gsub(/\v/, '') unless i.comment6.blank?
        str += "; " + i.comment7.gsub(/\v/, '') unless i.comment7.blank?
        str += "; Tinte (Raster): " + i.color0.gsub(/\v/, '') unless i.color0.blank?
        str += "; Tinte (Text): " + i.color1.gsub(/\v/, '') unless i.color1.blank?
        str += "; Tinte (Noten): " + i.color2.gsub(/\v/, '') unless i.color2.blank?
        str += "; Tinte (Kalligraphien): " + i.color3.gsub(/\v/, '') unless i.color3.blank?
        str += "; Schreiber:  " + i.owner.gsub(/\v/, '') unless i.owner.blank?
        str += "; Schriftform:  " + i.non1.gsub(/\v/, '') unless i.non1.blank?
        str += "; Schriftspiegel:  " + i.size.gsub(/\v/, '') unless i.size.blank?
        str += "; Seitenzahlen:  " + i.comment8.gsub(/\v/, '') unless i.comment8.blank?
#        str += "; Wasserzeichen: " + i.non3.gsub(/\v/, '') unless i.non3.blank? # Watermark
        str += "; Kalligraphien:  " + i.comment2.gsub(/\v/, '') unless i.comment2.blank?
        marcxml.addSubfield(df, "a", str)
      end
      u.each do |i|
        df = marcxml.datafield("592", "a", i.non3.gsub(/\v/, '')) unless i.non3.blank? # Watermark
        marcxml.addSubfield(df, "8", "01")
      end
    end

    # Many of the codes have a supplemented page
    # documenting the restauration
    marcxml.datafield("525", "a", @supplement) unless @supplement.blank?
    #marcxml.datafield("563", "a", binding_comment.gsub( /\v/, '')) unless binding_comment.blank?
    if not binding_comment.blank?  
      df = marcxml.datafield("563", "a", binding_comment.gsub( /\v/, '')) 
      marcxml.addSubfield(df, "8", "01")
    end
    df = marcxml.datafield("593", "a", make_type)
    marcxml.addSubfield(df, "8", "01")

    marcxml.datafield("650", "a", shelf) unless shelf.blank?
 
    # Bibliographical reference
    if x = make_lit 
      then 
      x.each do |i|
        df = marcxml.datafield("691", "a", i[0].strip) unless i[0].blank?
        marcxml.addSubfield(df, "n", i[1].strip) unless i[1].blank?
        marcxml.addSubfield(df, "0", i[2]) unless i[2].blank?
      end
    end
   
    df = marcxml.datafield("700", "a", owner0.gsub( /\v/, ''))
    marcxml.addSubfield(df, "4", "oth")
    
    df = marcxml.datafield("700", "a", owner1.gsub( /\v/, ''))
    marcxml.addSubfield(df, "4", "oth")
    
    df = marcxml.datafield("710", "a", "Capella Sistina")
    marcxml.addSubfield(df, "0", 51000666)
    marcxml.addSubfield(df, "4", "evp")

    # if there is no Piece in Code throw an error
    ids, collection = make_include(Code.rismid, cs, make_type)
    if ids.empty?
      puts "Empty Code generated: ".red + cs.to_s
    else 
      ids.each do |id|
        marcxml.datafield("774", "w", id)
      end
    end

    df = marcxml.datafield("852", "a", "V-CVbav")
    marcxml.addSubfield(df, "c", "CS " + cs.to_s)
    marcxml.addSubfield(df, "d", "lib " + libsig) unless libsig.blank?
    marcxml.addSubfield(df, "d", sig0) unless sig0.blank?
    marcxml.addSubfield(df, "d", sig1) unless sig1.blank?
    marcxml.addSubfield(df, "d", sig2) unless sig2.blank?
    marcxml.addSubfield(df, "d", non7.gsub( /\v/, '')) unless non7.blank?
    marcxml.addSubfield(df, "z", "Fondo Cappella Sistina")

    # if digitized add link to 856
    unless not digivatlib.include?(cs)
      df = marcxml.datafield(
        "856", "u", "https://digi.vatlib.it/view/MSS_Capp.Sist." + cs.to_s
      ) 
      marcxml.addSubfield(df, "x", "Digitalization")
      marcxml.addSubfield(df, "z", "Digitalisat")
    end
    return marcxml, collection
  end

  def make_lit
    r = []
    should = false
    [lit, sig0, non6, sig2, sig1, non15].each do |i|
      should = should || (not i.blank?)
    end
    if should
      lit.split(";").each_with_index do |v,i|
        if not v.empty?
          r[i] = v.split(',')
          r[i][1] = r[i].drop(1).join(', ') unless r[i][1].blank?
          case r[i][0]
          when /Llorens/
            r[i][0] = "LlorensS 1960"
            r[i][2] = 144
          when /Haberl/
            r[i][0] = "HaberlV 1888"
            r[i][2] = 3122
          end
        end
      end
      # Panuzzi :sig0
      if not sig0.blank?
        r << [ "PanuzziL 1687", sig0, 41001975 ]
      end
      # Celi :non6
      if not non6.blank?
        r << [ "CeliL 1753", non6, 41001973 ]
      end
      # Storace :sig2
      if not sig2.blank?
        r << [ "StoraceP 1813", sig2, 41001976 ]
      end
      # Salvati :sig1
      if not sig1.blank?
        r << [ "SalvatiL 1863", sig1, 41001978 ]
      end
      # Perfetti :non15
      if not non15.blank?
        r << [ "PerfettiL 1856", non15, 41001977 ]
      end
      # Zappini --
    else
      r = false
    end
    return r
  end

  def make_format
    if /Chorbuch/.match(t_)
      f = "1 choirbook: " << n_ << "f."
    else
      f = "1 score: " << n_ << "f."
    end
    return f
  end

  def make_include(rismid, cs, type)
    # for all the picese
    # export cs as an argument to Piece.build_xml($cs)
    # call Piece.build_xml
    # and add them to $774
    # returns array of pieces ids and the pieces xml
    ids = []
    includes = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.content('xmlns' => "http://www.loc.gov/MARC21/slim") do
      end
    end
    Piece.where(cs: cs).each do |p|
      if not p.nr%1000==0
        id, marc = p.build_xml(rismid, type)
        includes.doc.root << marc.doc.children.first
        ids << id 
      end
    end
    return ids, includes
  end

  def make_type
    case t_
    when /Druck/
      type = "Print"
    when /Hs./
      type = "Manuscript copy"
    end
    return type
  end

  def make_provenance
    # one of the non fields might be provenance
    # put them in the field $561 a
  end
  
  def digivatlib
    # if cs is in digitized.yml
    # make the URL just like in models/import.rb:
    # baseurl = "https://digi.vatlib.it/view/MSS_Capp.Sist."
    # url = URI.parse(baseurl + n.to_s)
    # and put it into $856
    digitized = YAML.load_file("#{Rails.root}/models/digitized.yml")
    return digitized
  end

  def make_publishing
    # (260 $a place) only what is before the first ":"
    # also consult owner1 which might be the editor (260 $f)
    # and (260 $e) for the Place (before the ":")
    # and the copyist for the manuscripts 
    # or put all together into (260 $b)
    # (260 $c date)
  end

  def make_date
    if date == ""
      d = "[s.d.]"
    else
      d = date
    end
    return d
  end

  def make_place
    if place == ""
      if make_type == "Print"
        p = "[s.l.]"
      else
        p = ""
      end
    else
      p = place.split(":")[0]
    end
    return p
  end

  def make_persons
    # add all names (composer, owners, copyist)
    # to $700
    # set $700 j to ascertained
    # depending on the field the name is taken
    # set $700 $4 to one of the following:
    # copyist [scr]
    # editor [edt]
    # illustrator [ill]
    # publisher [pbl]
    # maybe some can be extracted to $260
  end
  
  def make_institution
    # same as make_person
    # but with datafield 710
    # and restricted to 
    # editor [edt]
    # and publisher [pbl]
  end

  def make_titleOnSource
    if title_comment.blank?
      t = "[without title]"
    else
      # Put Restauration Marks
      # to Supplementary Material (525 $a)
      if 
        title_comment.match(/estauration|kein|fehlt|Neubindung/)
        @supplement = title_comment.gsub('/', '|').gsub("\v", ' ') 
        t = "[without title]"
      else 
        t = title_comment.gsub('/','|').gsub("\v", ' ')
      end
    end
    return t
  end

  def make_standardTitle
    # if :content is not clear
    # set $240 to "Sacred vocal music"
    # else set $240 to :content
    # use yaml-file to link german names to terms
    # use $650 where appropriate
    # maybe even $730
    # Code.where("content LIKE ?", '%:%').pluck(:content)
    if content.match(/:/)
      composer, ttl = content.split(':')
      ttl = ttl.strip
    else
      ttl = content
    end
    case ttl
    when ""
      t = "Sacred songs"
      sh = t
    when /Alle/
      t = "Alleluia"
      sh = "Sacred songs"
    when /ntiphon/
     t = "Antiphones"
      sh = t
    when /Ari/
      t = "Arias"
      sh = "Arias (voc.)"
    when /anon/
      t = "Canons"
      sh = "Canons (voc.)"
    when /Cantus/
      t = "Cantus choralis"
      sh = t
    when /Falsibordon/
      t = "Falsibordoni"
      sh = "Falsi bordoni"
    when /Gloria/
      t = "Gloria"
      sh = t
    when /Graduale/
      t = "Graduale"
      sh = "Gradual"
    when "Benedicamus", 
      "Benedictus", 
      "Canticum", 
      "Communio", 
      "Credo", 
      "Kyrie", 
      "Magnificat", 
      "Pater noster", 
      "Proprium", 
      "Sanctus"
      t = ttl
      sh = "Sacred songs"
    when /Hymn/
      t = "Hymns"
      sh = t
    when /Imprope/
      t = "Imporperia"
      sh = t
    when /Introitus/
      t = "Introits"
      sh = "Sacred songs"
    when /Invitatorium/
      t = "Sacred songs"
      sh = t
    when /Lamentation/
      t = "Lamentations"
      sh = t
    when /Le[c,k]tio/
      t = "Lections"
      sh = t
    when /Litanei/
      t = "Litanies" 
      sh = t
    when /Madrigal/
      t = "Madrigals"
      sh = t
    when /Me[s,ß]/
      t = "Masses"
      sh = t
    when "Madrigal"
      t = "Madrigals"
      sh = t
    when /otett/
      t = "Motets"
      sh = t
    when /Offertorium/
      t = "Offertories"
      sh = t
    when /ffizium/
      t = "Sacred song"
      sh = t
    when /Passion/,
      /Requiem/
      t = ttl
      sh = t
    when /Psalm/
      t = "Psalm"
      sh = t
    when /Responsori/
      t = "Responsories"
      sh = t
    when /Sequen/
      t = "Sequences"
      sh = t
    when /Tractus/
      t = "Tracts"
      sh = t
    when /Versus/
      t = "Versi"
      sh = t
    else
      t = "Sacred songs"          # if empty it gets an edit-request
      sh = ttl
      # "XX" 
    end
    return t, sh, composer
  end

  def make_subjectHeading
    # will be more accurate then $240
    # set at least one field with "Sacred vocal music"
    # unless :t_ differs from Chorbuch (cs 364)
    # alternatively use $520 (description summary)
  end

  def self.export

    outfile = File.new("#{Rails.root}/export/export.xml", "w")

    collection = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.collection('xmlns' => "http://www.loc.gov/MARC21/slim") do
      end
    end
    rx = Code.all
    #rx = Code.sample
    rx.each do |r|
      marc, pieces = r.build_xml
      collection.doc.root << marc.document.doc.children.first
      collection.doc.root << pieces.doc.children.first
    end
    outfile.write(collection.to_xml)
  end
  
  def self.sample
    #return Code.where(cs: 63)
    return Code.where("content LIKE ?", '%:%')
  end
end
