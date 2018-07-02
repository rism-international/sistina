require 'rails_helper'

RSpec.describe Piece, type: :model do
  it { should belong_to(:concordance) }
  it { should validate_presence_of(:current) }
#  pending "add some examples to (or delete) #{__FILE__}"
end
