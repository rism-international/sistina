class RemovePiecesCodeid < ActiveRecord::Migration[5.2]
  def change
    remove_columns(:pieces, :code_id)
  end
end
