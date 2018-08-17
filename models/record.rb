=begin
# Just a scratch, for now
module FCS
  class Record
    @count = 0

    class << self
      attr_reader :count
    end

    # Print and Manuscript are differenciated
    # Code._t contains "Druck" for Prints
    # and "Hs." for Manuscripts

    def initialize
      Record.instance_eval {@count += 1}
      @rismid = Record.count
      @siglum = "V-CVbav" # We do have a second entry in the database: (I-Rvat)
    end

    def title
      t = "..."
      if @collection
        t = @code.title if @code.title != ""
      elsif @work
        t = @piece.title if @piece.title != ""
      end
      return t
    end

    # Works

    def composer

    end

    def place

    end

    def year

    end

    # Collections

    def material

    end

    def extent

    end

    def content

    end

    def to_xml
      marcxml = FCS::Node.new
      marcxml.leader
      marcxml.controlfield("001", @rismid)
      # individual title (130)
      marcxml.datafield("245", "a", title)
      df = marcxml.datafield("260", "a", place) # specially for prints?
      marcxml.addSubfield(df, "c", year) unless year.blank? # are we actually looking at prints?
      return marcxml.document
    end
  end
end
=end
