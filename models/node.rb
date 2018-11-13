require 'nokogiri'

module FCS      # Fondo Capella Sistina
  class Node
    attr_accessor :document, :node
    def initialize
      @document = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.record('xmlns' => "http://www.loc.gov/MARC21/slim") do
        end
      end
      @node=@document.doc.root
    end

    def controlfield(field, content)
      tag = Nokogiri::XML::Node.new "controlfield", node
      tag['tag'] = field
      tag.content = content
      @node << tag
    end

    def datafield(field, code, content)
      tag = Nokogiri::XML::Node.new "datafield", node
      tag['tag'] = field
      tag['ind1'] = ' '
      tag['ind2'] = ' '
      sf = Nokogiri::XML::Node.new "subfield", node
      sf['code'] = code
      sf.content = content
      tag << sf
      @node << tag
      return tag
    end
    
    def addSubfield(datafield, code, content)
      sf = Nokogiri::XML::Node.new "subfield", datafield
      sf['code'] = code
      sf.content = content
      datafield << sf
    end

    def leader(template="ncc")
      tag = Nokogiri::XML::Node.new "leader", node
      tag.content = "00000#{template} a2200000 u 4500" # Has to be checked again!!!
      @node << tag
    end
  end
end
