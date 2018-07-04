class Piece < ApplicationRecord
  belongs_to :code
  validates_presence_of :nr
  validates_presence_of :cs
  validates_presence_of :title
end
