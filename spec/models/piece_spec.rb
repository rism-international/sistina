require 'rails_helper'

RSpec.describe Piece, type: :model do
  it { should belong_to(:code) }
  it { should have_many(:concordances).with_foreign_key('nr') }
  it { should validate_presence_of(:nr) }
  it { should validate_presence_of(:cs) }
  it { should validate_presence_of(:title) }
#  it { should permit(
#      :cs, :nr, :title, :code_id,
#      :non0,
#      :non1,
#      :lit,
#      :non2,
#      :pages,
#      :t_,
#      :non3,
#      :current,
#      :non4,
#      :non5,
#      :nr0,
#      :title0,
#      :title1,
#      :title2,
#      :composer,
#      :composer0
#  ) }
#  #pending "add some examples to (or delete) #{__FILE__}"
end
