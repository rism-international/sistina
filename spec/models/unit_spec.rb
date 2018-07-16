require 'rails_helper'

RSpec.describe Unit, type: :model do
  it { should belong_to(:code) }
  it { should validate_presence_of(:cs) }
  it { should validate_presence_of(:comment0) }
  #pending "add some examples to (or delete) #{__FILE__}"
end
