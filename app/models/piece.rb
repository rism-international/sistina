class Piece < ApplicationRecord
  belongs_to :concordance
  validates_presence_of :current
end
