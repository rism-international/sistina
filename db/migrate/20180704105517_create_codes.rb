class CreateCodes < ActiveRecord::Migration[5.2]
  def up
    create_table :codes do |t|
      t.string :cs                  # 13.000
      t.string :non10
      t.string :content             # Messen, Motetten
      t.string :t_                  # Hs., Chorbuch mehrstimmig
      t.string :material            # Material
      t.string :n_                  # 188
      t.string :size                # 625x465
      t.string :place               # Rom: Päpstliche Kapelle
      t.string :date                # 1538-1545 ca.
      t.string :owner0              # Paul III.
      t.string :title_comment       # kein Titel, nur Rest (...)
      t.string :binding_comment     # Holz mit rotbraunem Leder (...)
      t.string :pagenumbering       # [01] 1-186 [02], arab. modern, Blei unten Mitte
      t.string :non0                # f01, II4, III10 ... III160 (...)
      t.string :non4               # fol. 3v-4r mehrfarbige Initialen (...)
      t.string :comment0            # Die ursprüngliche Lagenstruktur (...)
      t.string :non1                # 1. in KE 1, 18, 21: jeweils 1-6, arab. rotbraune Tinte obe (...)
      t.string :non2                # 1. fol. 28r, 38r, 57r, 77r, 102r; unten links [großes Lambda] (...)
      t.string :comment1            # Der Kodex wurde aus einer Reihe (...)
      t.string :non11
      t.string :notation            # weiß mensural
      t.string :non3
      t.string :owner1              # Johannes Parvus
      t.string :non12
      t.string :non5         # 8.000
      t.string :non13
      t.string :non6         # A013
      t.string :comment2     # Leichte Benutzungsspuren unten rechts (...)
      t.string :non7         # fol. 2v, unten links mit roter Tinte: "lib. 51"
      t.string :libsig       # 51 ?
      t.string :lit          # Haberl, p. 6; Llorens, p. 16-18 (...)
      t.string :non14
      t.string :non8         # T
      t.string :sig0         # 013 
      t.string :non15
      t.string :non9         # F
      t.string :sig1         # 013 
      t.string :sig2         # A013 
      t.string :comment3     # 1. i-xxi (= 3-23), xxii-clxxxiii (= 25-186), röm (..)
      t.timestamps
    end
  end
end
