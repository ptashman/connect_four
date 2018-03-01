class Space < ApplicationRecord
  has_one :disc
  has_one :player, through: :disc

  def self.fill(column, player)
    space_to_fill = first_open_space_in_column(column)
    Disc.create(space: space_to_fill, player: player) if space_to_fill
  end

  def self.first_open_space_in_column(column)
    where(column: column).each do |s|
      return s unless s.disc
    end
    return nil
  end

  def self.empty_that_could_win_game_for(player, min_discs_per_set)
    sets_with_min_discs = winning_sets_for(player, true).select do |space_set|
      space_set.select { |space| space.player == player }.count >= min_discs_per_set
    end
    empty_spaces = []
    sets_with_min_discs.each do |space_set|
      space_set = remove_dangling_spaces_from(space_set)
      empty_spaces << space_set.select { |space| space.disc.nil? }
    end
    return empty_spaces.flatten.select do |s|
      s.row == 1 || Space.find_by_column_and_row(s.column, s.row-1).disc.present?
    end
  end

  def self.winning_sets_for(player, including_potential_wins)
    sets = []
    ["horizontal", "vertical", "diagonal_up", "diagonal_down"].each do |direction|
      sets += sets_of_four_in_one_direction(direction, player, including_potential_wins)
    end
    sets
  end

  def self.sets_of_four_in_one_direction(direction, player, including_empty_spaces=false)
    sets = []
    lines_of_spaces(direction, player).each do |spaces|
      if including_empty_spaces
        spaces_to_check = spaces.select { |s| s.player == player || s.player.nil? }.compact
      else
        spaces_to_check = spaces.select { |s| s.player == player }.compact
      end
      (0..2).each do |n|
        set = check_set(spaces_to_check[n..n+3], 0, direction)
        sets << set if set.present?
      end
    end
    sets
  end

  private

  def self.check_set(spaces, index, direction, disc_set=[])
    return [] unless spaces.present?
    disc_set << spaces[index]
    return disc_set if disc_set.count > 3
    return [] unless spaces[index+1]
    next_column = spaces[index].column + direction_translation(direction)[0]
    next_row = spaces[index].row + direction_translation(direction)[1]
    if spaces[index+1].column == next_column && spaces[index+1].row == next_row
      check_set(spaces, index+1, direction, disc_set)
    else
      check_set(spaces, index+1, direction)
    end
  end

  def self.lines_of_spaces(direction, player)
    case direction
    when "horizontal"
      all.group_by(&:row).values.compact
    when "vertical"
      all.group_by(&:column).values.compact
    when "diagonal_up"
      sliced = all.group_by(&:row).values
      right_diagonals = (0..6).map { |x| (0..5).map { |i| sliced[i].try(:[], i+x) }.compact }
      left_diagonals = (0..4).map { |x| (0..(4-x)).map { |i| sliced[i+x+1].try(:[], i) }.compact }
      (right_diagonals + left_diagonals)
    when "diagonal_down"
      sliced = all.group_by(&:row).values
      right_diagonals = (0..4).map { |x| (0..(4-x)).map { |i| sliced[i+x+1].try(:[], -i-1) }.compact }.compact
      left_diagonals = (0..6).map { |x| (0..5).map { |i| sliced[i].try(:[], -i-1-x) }.compact }.compact
      (right_diagonals + left_diagonals)
    end
  end

  def self.direction_translation(direction)
    case direction
    when "horizontal"
      [1, 0]
    when "vertical"
      [0, 1]
    when "diagonal_up"
      [1, 1]
    when "diagonal_down"
      [-1, 1]
    end
  end

  def self.remove_dangling_spaces_from(space_set)
    space_set.compact!
    space_set.delete(space_set[0]) if space_set[0].disc.nil? && space_set[1].disc.nil?
    space_set.delete(space_set.last) if space_set.last(2)[1].disc.nil? && space_set.last(2)[0].disc.nil?
    space_set
  end
end
