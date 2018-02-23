class Space < ApplicationRecord
  has_one :disc

  def self.fill(column, player_id)
    space_to_fill = first_open_space_in_column(column)
    Disc.create(space_id: space_to_fill.id, player_id: player_id) if space_to_fill
  end

  def self.first_open_space_in_column(column)
    where(column: column).each do |s|
      return s unless s.disc
    end
    return nil
  end
end
