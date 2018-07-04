class Concordance < ApplicationRecord
  belongs_to :piece
  validates_presence_of :nr, :ccd0, :title
end
