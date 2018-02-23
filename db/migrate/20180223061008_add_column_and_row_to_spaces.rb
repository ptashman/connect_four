class AddColumnAndRowToSpaces < ActiveRecord::Migration[5.1]
  def change
    add_column :spaces, :column, :integer
    add_column :spaces, :row, :integer
  end
end
