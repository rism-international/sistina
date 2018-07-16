class Part < ApplicationRecord
  belongs_to :piece
  validates_presence_of :nr, :title, :composer, :piece_id
end
