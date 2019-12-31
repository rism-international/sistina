class Piece < ApplicationRecord
#  has_many :concordances
#  has_many :parts
  offset = 85701000
  @rismid = offset 

  class << self
    attr_reader :rismid
  end

  validates_presence_of :nr

  def build_xml(parent_record, type)
    Piece.instance_eval { @rismid += 1 }
    marcxml = FCS::Node.new
    if type == "Print"
      marcxml.leader("ncd") 
    else
      marcxml.leader("ndd") 
    end
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
#          marcxml.addSubfield(df, "d", i.title) unless i.title.blank?
          marcxml.addSubfield(df, "t", make_textIncipit(i)) unless make_textIncipit(i).blank?
          marcxml.addSubfield(df, "m", make_scoring(i)) unless make_scoring(i).blank?
#          marcxml.addSubfield(df, "q", "composed by " << i.composer) unless i.composer.blank?
          marcxml.addSubfield(df, "q", i.comment.gsub(/\v/, '')) unless i.comment.blank?
        end
      end
    end

    composer0.blank? ?  marcxml.datafield("100", "a", "Anonymus") : marcxml.datafield("100", "a", composer0)
    # standardized title
    tit, shelfm = make_title
    voices, vHash = make_totalScoring
    df = marcxml.datafield("240", "a", tit)
    marcxml.addSubfield(df, "m", voices)
    # title on source
    marcxml.datafield("245", "a", make_titleOnSource)
    df = marcxml.datafield("300", "a", "Choirbook, fol. " << pages) unless pages.blank?
    marcxml.addSubfield(df, "8", "01") unless pages.blank?
    # Comments
    df = marcxml.datafield(500, "a", non0.gsub(/\v/, ''))
    if x = make("Textnachweis: ", title2) then marcxml.addSubfield(df, "a", x) end
    if x = make("Cantus Prius Factus: ", non1) then marcxml.addSubfield(df, "a", x) end
    if x = make("Mehrstimmige Vorlage: ", non4) then marcxml.addSubfield(df, "a", x) end
    if x = make("Ursprüngl. laufende Nr.: ", non5) then marcxml.addSubfield(df, "a", x) end
    if x = make("Titel im Index: ", title0) then marcxml.addSubfield(df, "a", x) end
    if x = make("Komponist im Index: ", composer) then marcxml.addSubfield(df, "a", x) end
    marcxml.addSubfield(df, "a", non2.gsub(/\v/, '')) unless non2.blank?
    marcxml.addSubfield(df, "a", title.gsub(/\v/, '')) unless title.blank?
    # Concordances
    c = Concordance.where(nr: nr)
    unless c.empty? 
      c.each do |i|
        x = ""
        if x << make("", i.composer).to_s then x << ": " end
        if x << make("", i.title).to_s then x << ". " end
        [i.ccd0, i.ccd1, i.ccd2].each do |f|
          if y = make("", f) 
            then 
            x << ", " 
            x << y 
          end
        end 
        if df.values[0] == "599"
        then 
          marcxml.addSubfield(df, "a", x) 
        else 
          df = marcxml.datafield(599, "a", '')
        end
      end
    end
    # Additional Names
    marcxml.addSubfield(df, "a", composer.gsub(/\v/, '')) unless composer.blank?
    # Subject heading
    marcxml.datafield("650", "a", shelfm) unless shelfm.blank? # standardized
    # Liturgical festival
    marcxml.datafield("657", "a", make_litFeast) unless make_litFeast.blank?
    # Bibliographical reference
    if x = make_lit 
      then 
      x.each do |i|
        df = marcxml.datafield("691", "a", i[0].strip) unless i[0].blank?
        marcxml.addSubfield(df, "n", i[1].strip) unless i[1].blank?
        marcxml.addSubfield(df, "0", i[2]) unless i[2].blank?
      end
    end
      # Additional titles
    marcxml.datafield("730", "a", title1) unless title1.blank?
    marcxml.datafield("730", "a", title0) unless title0.blank?
    marcxml.datafield("730", "a", t_) unless t_.blank? # original subject heading
    marcxml.datafield("773", "w", parent_record)

    df = marcxml.datafield("852", "a", "V-CVbav")
    marcxml.addSubfield(df, "c", "CS " + cs.to_s)
    marcxml.addSubfield(df, "z", "Fondo Cappella Sistina")
    df = marcxml.datafield("593", "a", type)
    marcxml.addSubfield(df, "8", "01")
    vHash.each { |k, v|
      if v != 0
        df = marcxml.datafield("594", "b", k.to_s)
        marcxml.addSubfield(df, "c", v.to_s)
      end
    }
    return Piece.rismid, marcxml.document
  end

  def make_lit
    r = []
    if not lit.empty?
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
    else
      r = false
    end
    return r
  end

  def make(prefix, input)
    if not input.blank? || input == '-' || input == 'keine'
      r = prefix + input.gsub(/\v/, '')
    end
    return r
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
    if title1 == "" 
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
      end
    else
      t = title1
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

  # Summs up the Voicings for Scoring Summary in 240$m.
  # Also creates a Hash of summs for each Voice for 594$b.
  # @return [Array<String, Hash>]
  def make_totalScoring 
    delimiters = ['-', '[', ']', '/']
    @partsVoicings = Part.where(nr: nr).pluck(:voices)
    maxVoices = 0
    sum = ""
    vCount = {C:0, S:0, A:0, T:0, B:0, V:0}
    organ = false
    @partsVoicings.each do |part| 
      part.split(Regexp.union(delimiters)).each do |subpart| 
        if subpart.to_i != 0
          vCount[:V] = subpart.to_i
        else
          vCount.each {|k, v|
            tmp = subpart.scan(k.to_s).count
            if tmp > vCount[k]
              vCount[k] = tmp
            end
          }
        end
        # Takes Organ into account
        if subpart.match(/Orgel/)
          organ = true
        end
      end 
    end
    vCount.each {|k, v| 
      maxVoices += v
    }
    # @todo Sometimes the field contains only a number
    if vCount[:V] != 0
      sum = "V (" + vCount[:V].to_s + ")"
    else 
      if maxVoices != 0 
        sum = "V (" + maxVoices.to_s + ")"
      else
        sum = "V (X)"
      end
    end
    if organ
      sum += ", org"
    end
    return sum, vCount
  end

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

  # At the Works number, the unit table might get importent.
  # For now, we set the value to 1
  def make_workNumber(p)
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
