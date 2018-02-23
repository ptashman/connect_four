class Player < ApplicationRecord
  has_many :discs
  has_many :spaces, through: :disc

  def move(column)
    Space.fill(column, id)
  end
end
