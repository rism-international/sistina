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
    marcxml.leader
    marcxml.controlfield("001", Code.rismid)
    marcxml.datafield("041", "a", "lat")
    tit, shelf, cmpsr = make_standardTitle
    marcxml.datafield("100", "a", cmpsr) unless cmpsr.blank?
    marcxml.datafield("130", "a", tit) # Einordnungstitel
    marcxml.datafield("245", "a", make_titleOnSource)
    df = marcxml.datafield("260", "a", make_place)
    marcxml.addSubfield(df, "c", make_date)
    marcxml.addSubfield(df, "8", "01")

    # Physical description
    # Dimensions
    df = marcxml.datafield("300", "a", make_format)
    marcxml.addSubfield(df, "b", material.gsub( /\v/, '')) unless material.blank?
    marcxml.addSubfield(df, "c", size)
    marcxml.addSubfield(df, "8", 01)

    # Bibliographical reference
    df = marcxml.datafield("500", "a", lit) unless lit.blank?
    marcxml.addSubfield(df, "a", notation) unless notation.blank?
    # Comments
    marcxml.addSubfield(df, "a", comment1.gsub( /\v/, '')) unless comment1.blank?
    marcxml.addSubfield(df, "a", non7.gsub( /\v/, '')) unless non7.blank?
    marcxml.addSubfield(df, "a", title_comment.gsub( /\v/, '').force_encoding("utf-8")) unless title_comment.blank?
    marcxml.addSubfield(df, "a", binding_comment.gsub( /\v/, '')) unless binding_comment.blank?
    marcxml.addSubfield(df, "a", pagenumbering.gsub( /\v/, '')) unless pagenumbering.blank?
    marcxml.addSubfield(df, "a", non0.gsub( /\v/, '')) unless non0.blank?
    marcxml.addSubfield(df, "a", non4.gsub( /\v/, '')) unless non4.blank?
    marcxml.addSubfield(df, "a", comment0.gsub( /\v/, '')) unless comment0.blank?
    marcxml.addSubfield(df, "a", non1.gsub( /\v/, '')) unless non1.blank?
    marcxml.addSubfield(df, "a", non2.gsub( /\v/, '')) unless non2.blank?
    marcxml.addSubfield(df, "a", non11.gsub( /\v/, '')) unless non11.blank?
    marcxml.addSubfield(df, "a", non3.gsub( /\v/, '')) unless non3.blank?
    marcxml.addSubfield(df, "a", non12.gsub( /\v/, '')) unless non12.blank?
    marcxml.addSubfield(df, "a", non13.gsub( /\v/, '')) unless non13.blank?
    marcxml.addSubfield(df, "a", comment2.gsub( /\v/, '')) unless comment2.blank?
    marcxml.addSubfield(df, "a", non7.gsub( /\v/, '')) unless non7.blank?
    marcxml.addSubfield(df, "a", non14.gsub( /\v/, '')) unless non14.blank?
    marcxml.addSubfield(df, "a", comment3.gsub( /\v/, '')) unless comment3.blank?

    # Many of the codes have a supplemented page
    # documenting the restauration
    marcxml.datafield("525", "a", @supplement) unless @supplement.blank?
    df = marcxml.datafield("593", "a", make_type)
    marcxml.addSubfield(df, "8", "01")

    marcxml.datafield("650", "a", shelf) unless shelf.blank?
    marcxml.datafield("710", "a", place) unless place.blank?

    # if there is no Piece in Code throw an error
    ids, collection = make_include(Code.rismid, cs)
    #if ids.empty?
    #else
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

  def make_format
    if /Chorbuch/.match(t_)
      f = "1 choirbook: " << n_ << "f."
    else
      f = "1 score: " << n_ << "f."
    end
    return f
  end

  def make_include(rismid, cs)
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
      id, marc = p.build_xml(rismid)
      includes.doc.root << marc.doc.children.first
      ids << id 
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
      #marc = r.build_xml(rismid += 1)
      collection.doc.root << marc.document.doc.children.first
#      collection.doc.root << marc.node
      collection.doc.root << pieces.doc.children.first
    end
    outfile.write(collection.doc.to_xml)
  end
  
  def self.sample
    #return Code.where(cs: 63)
    return Code.where("content LIKE ?", '%:%')
  end
end
