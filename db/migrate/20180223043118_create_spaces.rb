class CreateSpaces < ActiveRecord::Migration[5.1]
  def change
    create_table :spaces do |t|

      t.timestamps
    end
  end
end
