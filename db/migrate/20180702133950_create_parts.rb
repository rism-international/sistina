class CreateParts < ActiveRecord::Migration[5.2]
  def change
    create_table :parts do |t|
      t.integer :nr
      t.string :part_nr
      t.string :part_fol
      t.string :title
      t.string :composer
      t.string :textincipit
      t.string :voicesincipit
      t.references :piece, foreign_key: true

      t.timestamps
    end
  end
end
