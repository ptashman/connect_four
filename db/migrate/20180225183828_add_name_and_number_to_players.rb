class AddNameAndNumberToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :name, :string
    add_column :players, :number, :string
  end
end
