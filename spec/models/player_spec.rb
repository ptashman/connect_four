require 'rails_helper'

RSpec.describe Player, type: :model do
  subject(:player) { FactoryBot.create(:player) }
  before do
    @third_column_first_row_space = FactoryBot.create(:space, column: 3, row: 1)
  end
  describe "#move" do
    it "creates a disc for the user in the correct space" do
      expect { player.move(3) }.to change(
        Disc.where(space_id: @third_column_first_row_space.id, player_id: player.id),
      :count).by(1)
    end
  end
end
