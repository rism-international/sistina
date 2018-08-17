class Unit < ApplicationRecord
#  belongs_to :code, foreign_key: :cs
  validates_presence_of :cs
end

