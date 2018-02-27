class Disc < ApplicationRecord
  belongs_to :player
  belongs_to :space

  def color
    return "white" unless player
    player.computer ? "black" : "red"
  end
end
