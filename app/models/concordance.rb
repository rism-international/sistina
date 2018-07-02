class Concordance < ApplicationRecord
  has_many :pieces, dependent: :destroy
  validates_presence_of :title, :ccd0
end
