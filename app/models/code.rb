class Code < ApplicationRecord
  self.primary_key = "cs"
  has_many :pieces
  has_many :units
  validates_presence_of :cs
  offset = 0
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
    marcxml.datafield("041", "a", "Latin")
    t, sh = make_standardTitle
    df = marcxml.datafield("240", "a", t)
    marcxml.datafield("245", "a", make_titleOnSource)
    df = marcxml.datafield("260", "a", make_place)
    marcxml.addSubfield(df, "c", make_date)
    marcxml.addSubfield(df, "8", 01)
    # to Supplementary Material (525 $a)
    marcxml.datafield("525", "a", @supplement) unless @supplement.blank?
    df = marcxml.datafield("593", "a", make_type)
    marcxml.addSubfield(df, "8", 01)

    marcxml.datafield("650", "a", sh) unless sh.blank? # standardized
    # Bibliographical reference
    marcxml.datafield("691", "a", lit) unless lit.blank?

    # if there is no Piece in Code throw an error
    ids, collection = make_content(Code.rismid, cs)
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
      marcxml.addSubfield(df, "z", "Digitalisat")
    end
    return marcxml, collection
  end

  def make_content(rismid, cs)
    # for all the picese
    # export cs to a global variable
    # or as an argument to Piece.build_xml($cs)
    # call Piece.build_xml
    # and add them to $774
    # returns array of pieces ids
    ids = []
    content = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.content('xmlns' => "http://www.loc.gov/MARC21/slim") do
      end
    end
    Piece.where(cs: cs).each do |p|
      id, marc = p.build_xml(rismid)
      content.doc.root << marc.doc.children.first
      ids << id 
    end
    return ids, content
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
    case t_
    when ""
      t = "Sacred songs"
      sh = t
    when "Alleluia", "Alleluja, Tractus", "Alleluja-Vers"
      t = "Alleluia"
      sh = "Sacred songs"
    when "Antiphon",
       "Antiphon (Motette)", 
       "Antiphon und Proprium", 
       "Antiphon zum Magnificat", 
       "Antiphon, Alleluia", 
       "Antiphon, Alleluja", 
       "Antiphon-Motette", 
       "Antiphon/Cantus?", 
       "Antiphon/Responsorium?", 
       "Antiphon/Tractus", 
       "Antiphonen", 
       "Antiphonen, Gebete", 
       "Antiphonen, Psalmen", 
       "Antiphonen, Psalmen, Lektionen", 
       "Antiphonen, Psalmen, Lektionen, Responsorien", 
       "Antiphonen, Psalmen, Responsorien, Lektionen", 
       "Antiphonen, Psalmi, Lektionen, Responsorien", 
       "Antiphonen, Vespern",
       "Versikel-Antiphon",
       "Vesperantiphonen", 
       "Vesperantiphonen, Introitus"
      t = "Antiphonies"
      sh = t
    when "Arie"
      t = "Arias"
      sh = "Arias (voc.)"
    when "Canon?", "Kanon"
      t = "Canons"
      sh = "Canons (voc.)"
    when "Cantus"
      t = "Cantus choralis"
      sh = t
    when "Falsibordoni", 
      "Falsobordone"
      t = "Falsibordoni"
      sh = "Falsi bordoni"
    when "Gloria", 
      "Gloria Patri"
      t = "Gloria"
      sh = t
    when "Graduale"
      t = "Graduale"
      sh = "Gradual"
    when "Graduale, Offertorium"
      t = "Graduale et Offertorium"
    when "Benedicamus", 
      "Benedictus", 
      "Canticum", 
      "Communio", 
      "Credo", 
      "Kyrie", 
      "Magnificat", 
      "Pater noster", 
      "Proprium", 
      "Sanctus", 
      t = t_
      sh = "Sacred songs"
    when "Hymnus",
      "Hymnen", 
      "Hymnus, nach Stäblein kein Hymnus, p. XVII Anm. 21"
      t = "Hymns"
      sh = t
    when "Improperien", "Improperium"
      t = "Imporperia"
      sh = t
    when "Introitus"
      t = "Introits"
      sh = "Sacred songs"
    when "Invitatorium, Antiphonen, Responsorien", "Invitatorium, Psalm",
      "Absolutionen", "Kapitel"
      t = "Sacred songs"
      sh = t
    when "Kammerduett"
      t = "Duets"
      sh = "Duets"
    when "Lamentation", 
      "Lamentationen" 
      t = "Lamentations"
      sh = t
    when "Lectio Epistolae", 
      "Lectio IX sancti Evangelii", 
      "Lektionen" 
      t = "Lections"
      sh = t
    when "Litanei", 
      "Litaneien"
      t = "Litanies" 
      sh = t
    when "Madrigal", "Madrigale"
      t = "Madrigals"
      sh = t
    when "Messe", "Meßordinarium", "Meßproprium",
      "Messe", 
      "Messe: Agnus Dei", 
      "Messe: Credo", 
      "Messe: Credo (Fragm.)", 
      "Messe: Gloria", 
      "Messe: Kyrie", 
      "Messe: Kyrie, Gloria", 
      "Messe: Sanctus"
      t = "Masses"
      sh = t
    when "Madrigal"
      t = "Madrigals"
      sh = t
    when "Motette",
      "Laudenmotette",
      "Litaneimotette",
      "Passionsmotette",
      "Psalm (Motette)",
      "Psalmmotette",
      "Sequenz-/Litaneimotette", 
      "Sequenzmotette",
      "Tractus-Motette" 
      t = "Motets"
      sh = t
    when "Offertorium", "Offertorium / Responsorium",
      t = "Offertories"
      sh = t
    when "Offizium", "Weihoffizium", "Totenoffizium"
      t = "Sacred song"
      sh = t
      
    when "Passion",
      "Requiem"
      t = t_
      sh = t
    when "Psalm", 
      "Psalm - Responsorium", 
      "Psalmen", 
      "Psalmtexte"
      t = "Psalm"
      sh = t
    when "Responsorien", 
      "Responsorium", 
      "Responsorium/Antiphon?", 
      "15 Responsorien zur Passion"
      t = "Responsories"
      sh = t
    when "Sequentia sancti evangelii", 
      "Sequenz", 
      "Sequenz, Antiphon"
      t = "Sequences"
      sh = t
    when "Tractus", 
      "Tractus und Alleluja"
      t = "Tracts"
      sh = t
    when "Versus", 
      "Versus ad salutandam crucem"
      t = "Versi"
      sh = t
    else
      t = "Sacred songs"          # if empty it gets an edit-request
      sh = t_
      # "XX" 
    end
    return t, sh
   
  end

  def make_subjectHeading
    # will be more accurate then $240
    # set at least one field with "Sacred vocal music"
    # unless :t_ differs from Chorbuch (cs 364)
    # alternatively use $520 (description summary)
  end

  def self.export

    outfile = File.new("#{Rails.root}/export/samples/test.xml", "w")

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
#      binding.pry
    end
    outfile.write(collection.doc.to_xml)
  end
  
  def self.sample
    return Code.where(cs: 63)
  end
end
