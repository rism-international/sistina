class Code < ApplicationRecord
  has_many :pieces, dependent: :destroy
  validates_presence_of :cs, :content, :t_
end
