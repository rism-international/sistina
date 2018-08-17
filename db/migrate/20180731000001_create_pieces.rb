class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t| 
      t.string :non0
      t.string :non1
      t.integer :cs
      t.string :lit
      t.string :non2
      t.string :pages
      t.string :t_
      t.string :non3
      t.integer :current
      t.string :title
      t.string :non4
      t.integer :nr
      t.string :non5
      t.integer :nr0
      t.string :title0
      t.string :title1
      t.string :title2
      t.string :composer
      t.string :composer0
      t.timestamps
    end
  end
end
