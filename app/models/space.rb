class Space < ApplicationRecord
  has_one :disc

  def self.fill(column_number, player_id)
    if first_open_space_in_column = self.find_by_column_and_row(column_number, 1)
      Disc.create(space_id: first_open_space_in_column.id, player_id: player_id)
    end
  end
end
