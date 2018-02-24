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

  def self.horizontal_disc_set?(player)
    set_of_four?("horizontal", player)
  end

  def self.vertical_disc_set?(player)
    set_of_four?("vertical", player)
  end

  def self.diagonal_disc_set?(player)
    return true if set_of_four?("diagonal_up", player)
    set_of_four?("diagonal_down", player)
  end

  private

  def self.set_of_four?(direction, player)
    lines_of_spaces(direction, player).each do |spaces|
      spaces = spaces.select { |s| s.disc.present? }.compact
      return true if spaces.present? && check_set(spaces, 0, direction)
    end
    return false
  end

  def self.lines_of_spaces(direction, player)
    case direction
    when "horizontal"
      select { |s| s.player == player }.group_by(&:row).values
    when "vertical"
      select { |s| s.player == player }.group_by(&:column).values
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

  def self.check_set(spaces, index, direction, disc_set=[])
    disc_set << spaces[index]
    return true if disc_set.count > 3
    next_column = spaces[index].column + direction_translation(direction)[0]
    next_row = spaces[index].row + direction_translation(direction)[1]
    if spaces[index+1].try(:column) == next_column && spaces[index+1].try(:row) == next_row
      check_set(spaces, index+1, direction, disc_set)
    else
      return false
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
end
