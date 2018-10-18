class Piece < ApplicationRecord
#  has_many :concordances
#  has_many :parts
  offset = 600
  @rismid = offset 

  class << self
    attr_reader :rismid
  end

#  def initialize
#    Piece.instance_eval { @rismid += 1 }
#  end


  validates_presence_of :nr

  def build_xml(parent_record)
    Piece.instance_eval { @rismid += 1 }
    marcxml = FCS::Node.new
    marcxml.leader
    marcxml.controlfield("001", Piece.rismid)

    # Parts with Textincipits
    p = Part.where(nr: nr)
    unless p.empty? 
      p.each do |i|
        df = marcxml.datafield("031", "a", make_workNumber(i))
        marcxml.addSubfield(df, "b", i.part_nr)
        # Although there are pieces with parts, that are devided into movements,
        # the differentiation is not clear enough to have them numbered
        # and with their own incipit
        marcxml.addSubfield(df, "c", 1)
        marcxml.addSubfield(df, "t", make_textIncipit(i)) unless make_textIncipit(i).blank?
        marcxml.addSubfield(df, "m", make_scoring(i)) unless make_scoring(i).blank?
        # add language!
      end
    end


    marcxml.datafield("100", "a", composer0) unless composer0.blank?
    # standardized title
    t, sh = make_title
    df = marcxml.datafield("240", "a", t)
    marcxml.addSubfield(df, "m", make_totalScoring)
    # title on source
    marcxml.datafield("245", "a", make_titleOnSource)
#    marcxml.datafield("246", "a", title1) # variant title on source
    # Subject heading
    marcxml.datafield("650", "a", sh) unless sh.blank? # standardized
    # Liturgical festival
    l = make_litFeast
    marcxml.datafield("657", "a", l) unless l.blank?
    # Bibliographical reference
    marcxml.datafield("691", "a", lit) unless lit.blank?
    # additional title
    marcxml.datafield("730", "a", title1) unless title1.blank?
    marcxml.datafield("730", "a", t_) unless t_.blank? # original subject heading
    marcxml.datafield("773", "w", parent_record)

    df = marcxml.datafield("852", "a", "V-CVbav")
    marcxml.addSubfield(df, "c", "CS " + cs.to_s)
    marcxml.addSubfield(df, "z", "Fondo Cappella Sistina")
    #marcxml.addSubfield(df, "d", "lib " + libsig) unless libsig.blank?
    #marcxml.addSubfield(df, "d", sig0) unless sig0.blank?
    #marcxml.addSubfield(df, "d", sig1) unless sig1.blank?
    #marcxml.addSubfield(df, "d", sig2) unless sig2.blank?
    # marcxml.datafield("594", "b", @partsVoicings) unless @partsVoicings.blank?
    #
    return Piece.rismid, marcxml.document
  end

  def make_litFeast           # Liturgical feasts
    if title == title2        # title turned out to hold the liturgical feast in some cases
      f = ""                  # we hope to elemenate those that hold the standard title out by comparing it
    else
      f = title
    end
    return f
  end

  def make_title
    case t_
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
      t = "[edit]"          # if empty it gets an edit-request
      # "XX" 
    end
    return t, sh
  end

  def make_titleOnSource
    if title0 == ""
      t = "[without title]"
    else
      t = title0
    end
    return t
  end

  def make_totalScoring # $594
    @partsVoicings = Part.where(nr: nr).pluck(:voices)
    # summ up for scoring summary (240 $m)
    maxVoices = 0
    result = ""
    @partsVoicings.each do |part| 
      part.split("/").each do |subpart| 
        spVoices = subpart.scan(/C|S|T|A|B/).count 
        if spVoices.to_i > 0
          spVoices = spVoices
        else
          spVoices = subpart
        end
        maxVoices = spVoices.to_i unless maxVoices.to_i >= spVoices.to_i
        result = "V (" + maxVoices.to_s + ")"
        if subpart.match(/Orgel/)
          result += ", org"
        end
      end 
    end
    return result
  end

  # Ignore Pieces where nr == cs * 1000!!!
  # for those, put the Part.comments somewhere in the Collection entry

  def make_textIncipit(p)
    # Part.where(nr: 13002).pluck(:textincipit)
    #tIncpts = Part.where(nr: nr).pluck(:textincipit)

    #result = ""
    # (031 $t) Latin
    # lanugage code (041 $a) => deutsch
    #tIncpts.each do |i|
    #  result += i unless i.blank?
    #end
    return p.textincipit
  end

  def make_workNumber(p)
    # At the Works number, the unit table might get importent.
    # For now, we set the value to 1
    return 1
  end

  def make_scoring(p)
    result = ""
    # Deal with entries that consist of numbers only
    if p.voices.to_i.to_s == p.voices 
      result = "V " + p.voices
    else
      result = p.voices
    end
    return result
  end
end
