class Unit < ApplicationRecord
  belongs_to :code
  validates_presence_of :cs, :comment0, :code_id
end

