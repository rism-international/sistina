require 'rails_helper'

RSpec.describe Code, type: :model do
  it { should have_many(:pieces).with_foreign_key('cs') }
  it { should have_many(:units).with_foreign_key('cs') }
  it { should validate_presence_of(:cs) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:t_) }
  #pending "add some examples to (or delete) #{__FILE__}"
end
