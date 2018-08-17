class Code < ApplicationRecord
  self.primary_key = "cs"
  has_many :pieces
  has_many :units
  validates_presence_of :cs

  def build_xml
    marcxml = FCS::Node.new
    marcxml.leader
    marcxml.controlfield("001", cs)
    df = marcxml.datafield("852", "a", "V-CVbav")
    marcxml.addSubfield(df, "z", "Fondo Cappella Sistina")
    marcxml.addSubfield(df, "p", "CS " + cs.to_s)
    marcxml.addSubfield(df, "d", "lib " + libsig) unless libsig.blank?
    marcxml.addSubfield(df, "d", sig0) unless sig0.blank?
    marcxml.addSubfield(df, "d", sig1) unless sig1.blank?
    marcxml.addSubfield(df, "d", sig2) unless sig2.blank?
    marcxml.datafield("593", "a", make_type)
    return marcxml.document

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

  def make_publishing
    # (260 $a place) only what is before the first ":"
    # also consult owner1 which might be the editor (260 $f)
    # and (260 $e) for the Place (before the ":")
    # and the copyist for the manuscripts 
    # or put all together into (260 $b)
    # (260 $c date)
    if date == ""
      d = "[s.d.]"
    else
      d = date
    end
    return d
  end
end
