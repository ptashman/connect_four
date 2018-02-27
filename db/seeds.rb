Disc.destroy_all
Player.destroy_all

Player.create(number: 1, computer: false)
Player.create(number: 2, computer: true)

space_list = [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6]]

space_list.each do |column, row|
  Space.create(column: column, row: row)
end
