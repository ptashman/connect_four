class CreateDiscs < ActiveRecord::Migration[5.1]
  def change
    create_table :discs do |t|

      t.timestamps
    end
  end
end
