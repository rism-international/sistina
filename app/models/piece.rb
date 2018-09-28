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
    marcxml.datafield("100", "a", composer0) unless composer0.blank?
    # standardized title
    df = marcxml.datafield("240", "a", make_title)
    marcxml.addSubfield(df, "m", make_totalScoring)
    # marcxml.datafield("594", "b", @partsVoicings) unless @partsVoicings.blank?
    # title on source
    marcxml.datafield("245", "a", make_titleOnSource)
#    marcxml.datafield("246", "a", title1) # variant title on source
    # additional title
    marcxml.datafield("730", "a", title1) unless title1.blank?
    # Subject heading
    marcxml.datafield("650", "a", t_) unless t_.blank?
    # Bibliographical reference
    marcxml.datafield("691", "a", lit) unless lit.blank?
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
    marcxml.datafield("773", "w", parent_record)
    return Piece.rismid, marcxml.document
  end

  def make_title
    if title == ""              # Empty title
      if t_ == ""               # gets either genre
        if title0 == ""         # or, if genre is empty, title on surce
          t = "[edit]"          # if they are all empty
        else                    # it gets an edit-request
          t = title0 
        end
      else
        t = t_
      end
    else
      t = title
    end
    return t
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
