a = Code.where("lit like ?", "%RISM%").pluck(:cs, :lit)
a.each do |s| pp Piece.where("cs = ?", s).count end
