class AddComputerToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :computer, :boolean
  end
end
