class Player < ApplicationRecord
  has_many :discs

  def move(column_number)
    Space.occupy(column_number, id)
  end
end
