class ChangePieces < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :cs
    remove_foreign_key :code_id
  end
end
