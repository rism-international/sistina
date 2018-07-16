class Piece < ApplicationRecord
  belongs_to :code
  has_many :concordances, dependent: :destroy
  validates_presence_of :nr, :cs, :title, :code_id
end
