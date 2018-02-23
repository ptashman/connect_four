class AddSpaceIdAndPlayerIdToDiscs < ActiveRecord::Migration[5.1]
  def change
    add_column :discs, :space_id, :integer
    add_column :discs, :player_id, :integer
    add_index :discs, :space_id, unique: true
    add_index :discs, :player_id
  end
end
