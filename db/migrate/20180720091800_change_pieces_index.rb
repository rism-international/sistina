class ChangePiecesIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index(:pieces, 'code_id')
    add_index(:pieces, 'cs')
  end
end
