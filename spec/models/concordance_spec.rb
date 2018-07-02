require 'rails_helper'

RSpec.describe Concordance, type: :model do
  it { should have_many(:pieces).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:ccd0) }
#  pending "add some examples to (or delete) #{__FILE__}"
end
