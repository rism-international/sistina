class ChangeReferenceToPieces < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :pieces, :codes, name: :cs
  end
end
