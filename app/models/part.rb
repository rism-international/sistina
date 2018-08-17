class Part < ApplicationRecord
#  belongs_to :piece
  validates_presence_of :nr
end
