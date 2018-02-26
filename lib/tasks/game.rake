namespace :game do
  desc "Allows gameplay via command line interface."
  task play: :environment do
    Disc.destroy_all
    Player.destroy_all
    player1 = Player.create(name: GamePlay.request_name(1), number: 1)
    player2 = Player.create(name: GamePlay.request_name(2), number: 2)
    current_player = player1
    move = 1
    while (!GamePlay.the_game_is_tied?(player1, player2))
      current_player = (move%2 == 1) ? player1 : player2
      GamePlay.request_move(current_player, 1)
      GamePlay.announce_winner(current_player) if current_player.has_won?
      move += 1
    end
    p "The game is tied!"
    Disc.destroy_all
    Player.destroy_all
  end
end
