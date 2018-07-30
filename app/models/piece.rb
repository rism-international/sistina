class Piece < ApplicationRecord
  belongs_to :code, foreign_key: "cs"
  has_many :concordances, foreign_key: :nr
  has_many :parts, foreign_key: :nr
  validates_presence_of :nr, :cs, :title
end
