class GamePlay < ApplicationRecord

  def self.request_computer_player
    p "Would you like to play against the computer? (Y/y/N/n)"
    comp = STDIN.gets.strip.upcase
    comp == "Y" ? (p "Now playing against the computer."; true) : false
  end

  def self.request_move_from_computer(computer_player, human_player)
    column = computer_player.column_for_computer(human_player)
    computer_player.move(column)
    p "The computer has moved into column #{column}."
  end

  def self.request_name(number)
    p "Player #{number}, what is your name?"
    player_name = STDIN.gets.strip
    p "#{player_name}, you are player #{number}."
    player_name
  end

  def self.request_move(player, attempt_number)
    p "#{player.name}, in which column would you like to drop a disc?"
    column = STDIN.gets.strip
    if player.move(column)
    	p "#{player.name}, you are dropping a disc in column #{column}."
    elsif attempt_number <= 3
    	p "#{player.name}, #{column} is full. Please choose a different column."
    	attempt_number += 1
    	request_move(player, attempt_number)
    else
    	p "Sorry, too many attempts to move into a full column. Aborting now."
      exit
    end
  end

  def self.the_game_is_tied?(player1, player2)
    !player1.has_room_for_win? && !player2.has_room_for_win?
  end

  def self.announce_winner(player)
    p "Congratulations, #{player.name}! You've won!"
    exit
  end
end
