class Piece < ApplicationRecord
  belongs_to :code
  has_many :concordances, dependent: :destroy
  validates_presence_of :nr, :cs, :title
#  # Cathastrophic workaround for `no method for 'done='` Error
#  def done=(x)
#    true
#  end
end
