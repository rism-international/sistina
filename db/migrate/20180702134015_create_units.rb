class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :units do |t|
      t.string :t_
      t.string :material
      t.string :comment0
      t.integer :cs
      t.string :comment1
      t.string :pages
      t.string :comment2
      t.integer :unit_nr
      t.string :comment3
      t.string :notation
      t.string :non0
      t.string :comment5
      t.string :comment6
      t.string :comment7
      t.string :owner
      t.string :non1
      t.string :size
      t.string :non2
      t.string :color0
      t.string :color1
      t.string :color2
      t.string :color3
      t.string :non3
      t.string :comment8
      
      t.timestamps
    end
  end
end
