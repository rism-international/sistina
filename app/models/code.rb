class Code < ApplicationRecord
  self.primary_key = "cs"
  has_many :pieces, foreign_key: "cs"
  has_many :units, foreign_key: 'cs'
  validates_presence_of :cs, :content, :t_
end
