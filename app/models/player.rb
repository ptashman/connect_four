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
end
