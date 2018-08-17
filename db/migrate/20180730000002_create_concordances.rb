class CreateConcordances < ActiveRecord::Migration[5.2]
  def change
    create_table :concordances do |t|
      t.integer :nr
      t.string :ccd0
      t.string :ccd1
      t.string :ccd2
      t.text :comment
      t.string :composer
      t.string :title
      t.timestamps
    end
  end
end

