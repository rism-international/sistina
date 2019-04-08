# This Class provides an interface to a maintence script.
# It selects the collections that are of type "Print",
# changes the record type to "Edition"
# and creates one Holding for every Record.
#
# For a clean transformation go through the following steps:
# > Source.delete_all ; Holding.delete_all
# > import = MarcImport.new("#{Rails.root}/../export/export.xml", "Source")
# > import.import
# > load "makeHoldings.rb" ; s = Sistina.new 
# > s.colls2editions 

class Sistina
  def initialize
    @prints = []
    collectPrints
  end
  def makeHolding(source, old_852)
    holding = Holding.new
    new_marc = MarcHolding.new(
      File.read("#{Rails.root}/config/marc/#{RISM::MARC}/holding/default.marc")
    )
    new_marc.load_source false
    new_marc.each_by_tag("852") do 
      |t| t.destroy_yourself
    end
    new_852 = old_852.deep_copy 
    new_marc.root.children.insert(
      new_marc.get_insert_position("852"), 
      new_852
    )
    new_marc.suppress_scaffold_links
    new_marc.import
    holding.marc = new_marc
    holding.source = source
    holding.suppress_reindex
    holding.save
  end
  def colls2editions
    getPrints.each do |p|
      marc = p.marc
      #marc.load_source false
      t = marc.by_tags("852")[0]
      makeHolding(p, t)
      t.destroy_yourself
      p.record_type = MarcSource::RECORD_TYPES[:edition]
      p.marc = MarcSource.new(marc.to_marc, p.record_type)
      p.save
    end
  end
  def collectPrints
    Source.where([
      "record_type = ?", 
      MarcSource::RECORD_TYPES[:collection]
    ]).each do |source| 
      marc = source.marc
      if marc.by_tags("593").to_s.match(/Print/) 
        then @prints << source
      end
    end
  end
  def getPrints
    return @prints
  end
  def showPrints
    @prints.each do |p|
      puts p.id.to_s + ": " + p.shelf_mark
    end
    return nil
  end
end
#marc.each_by_tag("852") do |t| new_852 = t.deep_copy end
#
#new_marc.suppress_scaffold_links  # Not sure what this does!?
#source.record_type = MarcSource::RECORD_TYPES[:edition]
#MarcSource::RECORD_TYPES[:edition]
#
#holding.save
#source.save
