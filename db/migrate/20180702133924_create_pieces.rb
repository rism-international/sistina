class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    drop_table :pieces
    create_table :pieces do |t| 
      t.integer :nr
      t.string :cs
      t.integer :current
      t.string :original
      t.string :fol
      t.string :title
      t.string :title0
      t.string :composer
      t.references :code, foreign_key: true
      t.timestamps
    end
  end
end
