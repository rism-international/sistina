require 'rails_helper'

RSpec.describe Piece, type: :model do
  it { should belong_to(:code) }
  it { should have_many(:concordances).dependent(:destroy) }
  it { should validate_presence_of(:nr) }
  it { should validate_presence_of(:cs) }
  it { should validate_presence_of(:title) }
  #pending "add some examples to (or delete) #{__FILE__}"
end
