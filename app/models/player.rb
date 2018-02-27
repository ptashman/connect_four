class Player < ApplicationRecord
  has_many :discs
  has_many :spaces, through: :discs

  def move(column)
    Space.fill(column, self)
  end

  def has_won?
    Space.winning_sets_for(self, false).flatten.present?
  end

  def has_room_for_win?
    Space.winning_sets_for(self, true).flatten.present?
  end

  def column_for_computer(human_player)
    target_spaces = []
    target_spaces << Space.empty_that_could_win_game_for(self, 3)
    target_spaces << Space.empty_that_could_win_game_for(human_player, 3)
    target_spaces << Space.empty_that_could_win_game_for(self, 2)
    target_spaces << Space.empty_that_could_win_game_for(self, 1)
    (target_spaces.flatten.map(&:column) << 4).first
  end
end
