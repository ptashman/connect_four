class Player < ApplicationRecord
  has_many :discs
  has_many :spaces, through: :discs

  DIFFICULTIES = ["easy", "hard"]

  def move(column)
    Space.fill(column, self)
  end

  def has_won?
    Space.winning_sets_for(self, false).flatten.present?
  end

  def has_room_for_win?
    Space.winning_sets_for(self, true).flatten.present?
  end

  def column_for_computer(human_player, difficulty=DIFFICULTIES[0])
    targets = []
    computer_priorities(human_player, difficulty).each do |player, min_discs_per_set|
      targets << Space.empty_that_could_win_game_for(player, min_discs_per_set)
    end
    (targets.flatten.map(&:column) << 4).first
  end
  
  private

  def computer_priorities(human_player, difficulty)
    priorities = [[self, 3], [human_player, 3], [self, 2], [self, 1]]
    priorities.insert(2, [human_player, 2]) if difficulty == DIFFICULTIES[1]
    priorities
  end
end
