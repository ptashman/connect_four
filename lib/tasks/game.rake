namespace :game do
  desc "Allows gameplay via command line interface."
  task play: :environment do
    Disc.destroy_all
    Player.destroy_all
    player1_name = GamePlay.request_name(1)
    computer_is_playing = GamePlay.request_computer_player
    player2_name = computer_is_playing ? "Computer" : GamePlay.request_name(2)
    player1 = Player.create(name: player1_name, number: 1)
    player2 = Player.create(name: player2_name, number: 2, computer: computer_is_playing)
    current_player = player1
    move = 1
    while (!GamePlay.the_game_is_tied?(player1, player2))
      current_player = (move%2 == 1) ? player1 : player2
      if computer_is_playing && current_player == player2
        GamePlay.request_move_from_computer(current_player, player1)
      else
        GamePlay.request_move(current_player, 1)
      end
      GamePlay.announce_winner(current_player) if current_player.has_won?
      move += 1
    end
    p "The game is tied!"
    Disc.destroy_all
    Player.destroy_all
  end
end
