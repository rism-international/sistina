require 'rails_helper'

RSpec.describe Part, type: :model do
  it { should belong_to(:piece) }
  it { should validate_presence_of(:nr) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:composer) }
  #pending "add some examples to (or delete) #{__FILE__}"
end
