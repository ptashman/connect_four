require 'rails_helper'

RSpec.describe Space, type: :model do
  before do
    @space1 = FactoryBot.create(:space, column: 3, row: 1)
    @space2 = FactoryBot.create(:space, column: 3, row: 2)
    @space3 = FactoryBot.create(:space, column: 3, row: 3)
    @player = FactoryBot.create(:player)
    @disc1 = FactoryBot.create(:disc, space: @space1, player: @player)
    @disc2 = FactoryBot.create(:disc, space: @space2, player: @player)
  end
  describe "#fill" do
    context "when there is a space to be filled" do
      it "creates a disc in the first, empty space" do
        expect { Space.fill(3, @player.id) }.to change(
          Disc.where(space: @space3),
        :count).by(1)
      end
    end
    context "when there is not a space to be filled" do
      it "does not create a new disc" do
        @disc3 = Disc.create(space: @space3, player: @player)
        expect { Space.fill(3, @player.id) }.to_not change(
          Disc.where(space: @space3),
        :count)
      end
    end
  end
  describe "#first_open_space_in_column" do
    context "when there is an open space" do
      it "returns the correct open space" do
        expect(Space.first_open_space_in_column(3)).to eq(@space3)
      end
    end
    context "when there is no open space" do
      it "returns nil" do
        @disc3 = Disc.create(space: @space3, player: @player)
        expect(Space.first_open_space_in_column(3)).to be(nil)
      end
    end
  end
end
