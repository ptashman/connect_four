class Player < ApplicationRecord
  has_many :discs
  has_many :spaces, through: :discs

  def move(column)
    Space.fill(column, self)
  end

  def has_won?
    horizontal_win = Space.horizontal_disc_set?(self)
    vertical_win = Space.vertical_disc_set?(self)
    diagonal_win = Space.diagonal_disc_set?(self)
    horizontal_win || vertical_win || diagonal_win
  end

  def has_room_for_win?
    horizontal_room = Space.horizontal_disc_room?(self)
    vertical_room = Space.vertical_disc_room?(self)
    diagonal_room = Space.diagonal_disc_room?(self)
    horizontal_room || vertical_room || diagonal_room
  end
end
