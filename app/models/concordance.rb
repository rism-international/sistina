class Concordance < ApplicationRecord
  belongs_to :piece
  validates_presence_of :nr
  validates_presence_of :ccd0
end
