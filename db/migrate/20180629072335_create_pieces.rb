class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.references :concordance, foreign_key: true
      t.integer :current
      t.integer :original
      t.string :fol
      t.string :title
      t.string :title0

      t.timestamps
    end
  end
end
