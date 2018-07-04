require 'rails_helper'

RSpec.describe Concordance, type: :model do
  it { should belong_to(:piece) }
  it { should validate_presence_of(:nr) }
  it { should validate_presence_of(:ccd0) }
  #pending "add some examples to (or delete) #{__FILE__}"
end
