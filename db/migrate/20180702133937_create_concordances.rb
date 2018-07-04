class CreateConcordances < ActiveRecord::Migration[5.2]
  def change
    drop_table :concordances
    create_table :concordances do |t|
      t.integer :nr
      t.string :ccd0
      t.string :ccd1
      t.string :ccd2
      t.string :comment
      t.string :composer
      t.string :title
      t.references :piece, foreign_key: true
      t.timestamps
    end
  end
end