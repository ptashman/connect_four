class Player < ApplicationRecord
  has_many :discs

  def move(column_number)
    Space.fill(column_number, id)
  end
end
