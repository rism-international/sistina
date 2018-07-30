class ChangeCsType < ActiveRecord::Migration[5.2]
  def change
    change_column :pieces, :cs, :integer
    change_column :units, :cs, :integer
    change_column :codes, :cs, :integer
  end
end
