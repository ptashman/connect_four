require 'rails_helper'

RSpec.describe Space, type: :model do
  before do
    @space1 = Space.find_by_column_and_row(3, 1)
    @space2 = Space.find_by_column_and_row(3, 2)
    @space3 = Space.find_by_column_and_row(3, 3)
    @space4 = Space.find_by_column_and_row(3, 4)
    @space5 = Space.find_by_column_and_row(3, 5)
    @space6 = Space.find_by_column_and_row(3, 6)
    @player = FactoryBot.create(:player)
    @disc1 = FactoryBot.create(:disc, space: @space1, player: @player)
    @disc2 = FactoryBot.create(:disc, space: @space2, player: @player)
    @disc3 = FactoryBot.create(:disc, space: @space3, player: @player)
    @disc4 = FactoryBot.create(:disc, space: @space4, player: @player)
  end
  describe "instance seed" do
    it "has the correct spaces stored in the db" do
      expect(Space.where(column: 1).map(&:row)).to eq ([1,2,3,4,5,6])
      expect(Space.where(column: 2).map(&:row)).to eq ([1,2,3,4,5,6])
      expect(Space.where(column: 3).map(&:row)).to eq ([1,2,3,4,5,6])
      expect(Space.where(column: 4).map(&:row)).to eq ([1,2,3,4,5,6])
      expect(Space.where(column: 5).map(&:row)).to eq ([1,2,3,4,5,6])
      expect(Space.where(column: 6).map(&:row)).to eq ([1,2,3,4,5,6])
      expect(Space.where(column: 7).map(&:row)).to eq ([1,2,3,4,5,6])
    end
  end
  describe "#fill" do
    context "when there is a space to be filled" do
      it "creates a disc in the first, empty space" do
        expect { Space.fill(3, @player.id) }.to change(
          Disc.where(space: @space5),
        :count).by(1)
      end
    end
    context "when there is not a space to be filled" do
      it "does not create a new disc" do
        @disc5 = Disc.create(space: @space5, player: @player)
        @disc6 = Disc.create(space: @space6, player: @player)
        expect { Space.fill(3, @player.id) }.to_not change(
          Disc.where(space: @space5),
        :count)
      end
    end
  end
  describe "#first_open_space_in_column" do
    context "when there is an open space" do
      it "returns the correct open space" do
        expect(Space.first_open_space_in_column(3)).to eq(@space5)
      end
    end
    context "when there is no open space" do
      it "returns nil" do
        @disc5 = Disc.create(space: @space5, player: @player)
        @disc6 = Disc.create(space: @space6, player: @player)
        expect(Space.first_open_space_in_column(3)).to be(nil)
      end
    end
  end
end
