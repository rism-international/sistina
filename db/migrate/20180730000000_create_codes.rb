class CreateCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :codes, :primary_key => :cs, :id => false do |t|
      t.integer :cs                  # 13.000
      t.string :non10               # (=83) [same as], n.c. ["nicht consultierbar"], -183 [several]
      t.string :content             # Messen, Motetten
      t.string :t_                  # Hs., Chorbuch mehrstimmig
      t.string :material            # Material
      t.string :n_                  # 188 [pages?]
      t.string :size                # 625x465
      t.string :place               # Rom: Päpstliche Kapelle
      t.string :date                # 1538-1545 ca.
      t.string :owner0              # Paul III.
      t.text :title_comment       # kein Titel, nur Rest (...)
      t.text :binding_comment     # Holz mit rotbraunem Leder (...)
      t.string :pagenumbering       # [01] 1-186 [02], arab. modern, Blei unten Mitte
      t.text :non0                # f01, II4, III10 ... III160 (...)
      t.text :non4               # fol. 3v-4r mehrfarbige Initialen (...)
      t.text :comment0            # Die ursprüngliche Lagenstruktur (...)
      t.text :non1                # 1. in KE 1, 18, 21: jeweils 1-6, arab. rotbraune Tinte obe (...)
      t.text :non2                # 1. fol. 28r, 38r, 57r, 77r, 102r; unten links [großes Lambda] (...)
      t.text :comment1            # Der Kodex wurde aus einer Reihe (...)
      t.string :non11             # [nur in cs 14 belegt => Comments]
      t.string :notation            # weiß mensural
      t.string :non3                # [=> Comments]
      t.string :owner1              # Johannes Parvus (for prints: place: printer [gedruckt bei printer])
      t.string :non12               # [Nr. and type of systems]
      t.string :non5         # 8.000
      t.string :non13        # [=> Comments size]
      t.string :non6         # A013
      t.text :comment2     # Leichte Benutzungsspuren unten rechts (...)
      t.string :non7         # fol. 2v, unten links mit roter Tinte: "lib. 51"
      t.string :libsig       # 51 ?
      t.text :lit          # Haberl, p. 6; Llorens, p. 16-18 (...)
      t.string :non14       # [=> Comments size]
      t.string :non8         # T
      t.string :sig0         # 013 
      t.string :non15         # [Possabilly concordance to A... Signatures]
      t.string :non9         # F
      t.string :sig1         # 013 
      t.string :sig2         # A013 
      t.text :comment3     # 1. i-xxi (= 3-23), xxii-clxxxiii (= 25-186), röm (..)
      t.timestamps
    end
  end
end
