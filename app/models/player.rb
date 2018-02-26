class Player < ApplicationRecord
  has_many :discs
  has_many :spaces, through: :discs

  def move(column)
    Space.fill(column, self)
  end

  def has_won?
    horizontal_win = Space.sets_of_four("horizontal", self).flatten.present?
    vertical_win = Space.sets_of_four("vertical", self).flatten.present?
    diagonal_up_win = Space.sets_of_four("diagonal_up", self).flatten.present?
    diagonal_down_win = Space.sets_of_four("diagonal_down", self).flatten.present?
    horizontal_win || vertical_win || diagonal_up_win || diagonal_down_win
  end

  def has_room_for_win?
    horizontal_room = Space.sets_of_four("horizontal", self, true).flatten.present?
    vertical_room = Space.sets_of_four("vertical", self, true).flatten.present?
    diagonal_up_room = Space.sets_of_four("diagonal_up", self, true).flatten.present?
    diagonal_down_room = Space.sets_of_four("diagonal_down", self, true).flatten.present?
    horizontal_room || vertical_room || diagonal_up_room || diagonal_down_room
  end

  def column_for_computer
    primary_offense_columns = empty_spaces_that_could_win_game(3).map(&:column)
    return primary_offense_columns.first if primary_offense_columns.present?
    human_player = self.class.find_by_computer(false)
    defense_columns = human_player.empty_spaces_that_could_win_game(3).map(&:column)
    return defense_columns.first if defense_columns.flatten.present?
    secondary_offense_columns = empty_spaces_that_could_win_game(2).map(&:column)
    secondary_offense_columns << empty_spaces_that_could_win_game(1).map(&:column)
    secondary_offense_columns.flatten.first || 4
  end

  def empty_spaces_that_could_win_game(min_discs_per_set)
    sets_with_min_discs = potential_winning_space_sets.select do |space_set|
      space_set.select { |space| space.player == self }.count >= min_discs_per_set
    end
    empty_spaces = []
    sets_with_min_discs.each do |space_set|
      empty_spaces << space_set.select { |space| space.disc.nil? }
    end
    return empty_spaces.flatten.select do |s|
      s.row == 1 || Space.find_by_column_and_row(s.column, s.row-1).disc.present?
    end
  end

  def potential_winning_space_sets
    potential_winning_space_sets = []
    potential_winning_space_sets += Space.sets_of_four("horizontal", self, true)
    potential_winning_space_sets += Space.sets_of_four("vertical", self, true)
    potential_winning_space_sets += Space.sets_of_four("diagonal_up", self, true)
    potential_winning_space_sets += Space.sets_of_four("diagonal_down", self, true)
  end
end
