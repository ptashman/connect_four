namespace :game do
  desc "Allows gameplay via command line interface."
  task play: :environment do
    destroy_all_discs_and_players
    player1 = Player.create(name: request_name(1), number: 1)
    player2 = Player.create(name: request_name(2), number: 2)
    current_player = player1
    move = 1
    while (!the_game_is_tied?(player1, player2))
      current_player = (move%2 == 1) ? player1 : player2
      request_move(current_player, 1)
      announce_winner(current_player) if current_player.has_won?
      move += 1
    end
    p "The game is tied!"
    destroy_all_discs_and_players
  end

  def request_name(number)
    p "Player #{number}, what is your name?"
    player_name = STDIN.gets.strip
    p "#{player_name}, you are player #{number}."
    player_name
  end

  def request_move(player, attempt_number)
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

  def the_game_is_tied?(player1, player2)
    !player1.has_room_for_win? && !player2.has_room_for_win?
  end

  def announce_winner(player)
    p "Congratulations, #{player.name}! You've won!"
    exit
  end

  def destroy_all_discs_and_players
    Disc.destroy_all
    Player.destroy_all
  end
end
