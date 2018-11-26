class Piece < ApplicationRecord
#  has_many :concordances
#  has_many :parts
  offset = 85701000
  @rismid = offset 

  class << self
    attr_reader :rismid
  end

  validates_presence_of :nr

  def build_xml(parent_record)
    Piece.instance_eval { @rismid += 1 }
    marcxml = FCS::Node.new
    marcxml.leader("ndd")
    marcxml.controlfield("001", Piece.rismid)

    # Parts with Textincipits
    p = Part.where(nr: nr)
    unless p.empty? 
      p.each do |i|
        if ( not make_textIncipit(i).blank? or not make_scoring(i).blank? )
          df = marcxml.datafield("031", "a", make_workNumber(i))
          marcxml.addSubfield(df, "b", i.part_nr)
          # Although there are pieces with parts, that are devided into movements,
          # the differentiation is not clear enough to have them numbered
          # and with their own incipit
          marcxml.addSubfield(df, "c", 1)
          marcxml.addSubfield(df, "d", i.title) unless i.title.blank?
          marcxml.addSubfield(df, "t", make_textIncipit(i)) unless make_textIncipit(i).blank?
          marcxml.addSubfield(df, "m", make_scoring(i)) unless make_scoring(i).blank?
          marcxml.addSubfield(df, "q", "composed by " << i.composer) unless i.composer.blank?
          marcxml.addSubfield(df, "q", i.comment.gsub(/\v/, '')) unless i.comment.blank?
        end
      end
    end

    composer0.blank? ?  marcxml.datafield("100", "a", "Anonymus") : marcxml.datafield("100", "a", composer0)
    # standardized title
    tit, shelfm = make_title
    df = marcxml.datafield("240", "a", tit)
    marcxml.addSubfield(df, "m", make_totalScoring)
    # title on source
    marcxml.datafield("245", "a", make_titleOnSource)
    df = marcxml.datafield("300", "a", "f. " << pages) unless pages.blank?
    marcxml.addSubfield(df, "8", "01") unless pages.blank?
    # Bibliographical reference
    df = marcxml.datafield("500", "a", lit) unless lit.blank?
    # Reference note
    marcxml.addSubfield(df, "a", non0.gsub(/\v/, '')) unless non0.blank?
    # Comments
    marcxml.addSubfield(df, "a", non1.gsub(/\v/, '')) unless non1.blank?
    marcxml.addSubfield(df, "a", non2.gsub(/\v/, '')) unless non2.blank?
    marcxml.addSubfield(df, "a", title.gsub(/\v/, '')) unless title.blank?
    marcxml.addSubfield(df, "a", title2.gsub(/\v/, '')) unless title2.blank?
    marcxml.addSubfield(df, "a", non4.gsub(/\v/, '')) unless non4.blank?
    # Concordances
    c = Concordance.where(nr: nr)
    unless c.empty? 
      c.each do |i|
        marcxml.addSubfield(df, "a", i.ccd0) unless i.ccd0.blank?
        marcxml.addSubfield(df, "a", i.ccd1) unless i.ccd1.blank?
        marcxml.addSubfield(df, "a", i.ccd2) unless i.ccd2.blank?
        marcxml.addSubfield(df, "a", i.comment.gsub(/\v/, '')) unless i.comment.blank?
        marcxml.addSubfield(df, "a", i.composer) unless i.composer.blank?
        marcxml.addSubfield(df, "a", i.title) unless i.title.blank?
      end
    end
    # Additional Names
    marcxml.addSubfield(df, "a", composer.gsub(/\v/, '')) unless composer.blank?
    # Subject heading
    marcxml.datafield("650", "a", shelfm) unless shelfm.blank? # standardized
    # Liturgical festival
    marcxml.datafield("657", "a", make_litFeast) unless make_litFeast.blank?
  # additional title
    marcxml.datafield("730", "a", title1) unless title1.blank?
    marcxml.datafield("730", "a", title0) unless title1.blank?
    marcxml.datafield("730", "a", t_) unless t_.blank? # original subject heading
    marcxml.datafield("773", "w", parent_record)

    df = marcxml.datafield("852", "a", "V-CVbav")
    marcxml.addSubfield(df, "c", "CS " + cs.to_s)
    marcxml.addSubfield(df, "z", "Fondo Cappella Sistina")
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
    tmp = t_
    case tmp
    when ""
      t = "[edit]"
      sh = "Sacred songs"
    when /Allelu/
      t = "Alleluia"
      sh = "Sacred songs"
    when /Antiphon/
      t = "Antiphones"
      sh = t
    when /Arie/
      t = "Arias"
      sh = "Arias (voc.)"
    when /anon/
      t = "Canons"
      sh = "Canons (voc.)"
    when /Cantus/
      t = "Cantus choralis"
      sh = t
    when /Fals[i,o]bordon/
      t = "Falsibordoni"
      sh = "Falsi bordoni"
    when /Gloria/ 
      t = "Gloria"
      sh = t
    when /Graduale/
      t = "Graduale"
      sh = "Gradual"
    when /Graduale, Offertorium/
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
      "Sanctus" 
      t = tmp
      sh = "Sacred songs"
    when /Hymn/
      t = "Hymns"
      sh = t
    when /Improperi/
      t = "Imporperia"
      sh = t
    when /Introitus/
      t = "Introits"
      sh = "Sacred songs"
    when /Kammerduett/
      t = "Duets"
      sh = "Duets"
    when /Lamentation/
      t = "Lamentations"
      sh = t
    when /Lectio/
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
    when /Madrigal/
      t = "Madrigals"
      sh = t
    when /otette/
      t = title1
      sh = "Motets"
    when /Offertori/
      t = "Offertories"
      sh = t
    when /ffizium/, "Weihoffizium", "Totenoffizium"
      t = "Sacred song"
      sh = t
    when /Passion/
      t = tmp
      sh = t
    when /Requiem/
      t = tmp
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
