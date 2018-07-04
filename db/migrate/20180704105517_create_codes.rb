class CreateCodes < ActiveRecord::Migration[5.2]
  def change
    drop_table :codes
    create_table :codes do |t|
      t.string :cs
      t.string :content
      t.string :t_
      t.string :material
      t.string :n_
      t.string :size
      t.string :place
      t.string :date
      t.string :owner0
      t.string :title_comment
      t.string :binding_comment
      t.string :pagenumbering
      t.string :non0
      t.string :comment0
      t.string :non1
      t.string :non2
      t.string :comment1
      t.string :notation
      t.string :non3
      t.string :owner1
      t.timestamps
    end
  end
end
