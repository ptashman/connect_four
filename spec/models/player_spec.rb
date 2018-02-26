require 'rails_helper'

RSpec.describe Player, type: :model do
  subject(:player) { FactoryBot.create(:player) }
  let(:other_player) { FactoryBot.create(:player) }
  describe "#move" do
    let(:space1) { Space.find_by_column_and_row(3, 1) }
    let(:space2) { Space.find_by_column_and_row(3, 2) }
    let(:space3) { Space.find_by_column_and_row(3, 3) }
    let(:space4) { Space.find_by_column_and_row(3, 4) }
    let(:space5) { Space.find_by_column_and_row(3, 5) }
    let(:space6) { Space.find_by_column_and_row(3, 6) }
    context "when player attempts a move into a column with an empty space" do
      it "creates a disc for the user in the correct space" do
        expect { player.move(3) }.to change(
          Disc.where(space: space1, player: player),
        :count).by(1)
      end
      it "returns new disc" do
        expect(player.move(3)).to eq Disc.find_by_space_id_and_player_id(space1, player)
      end
    end
    context "when player attempts a move into a full column" do
      before do
        Disc.create(space: space1, player: player)
        Disc.create(space: space2, player: player)
        Disc.create(space: space3, player: player)
        Disc.create(space: space4, player: player)
        Disc.create(space: space5, player: player)
        Disc.create(space: space6, player: player)
      end
      it "does not create a disc" do
        expect { player.move(3) }.to_not change(
          Disc.where(space: space1, player: player),
        :count)
      end
      it "returns false" do
        expect(player.move(3)).to eq nil
      end
    end
  end
  describe "#has_won?" do
    context "when player has 4 in a row horizontally" do
      let(:space1) { Space.find_by_column_and_row(2, 3) }
      let(:space2) { Space.find_by_column_and_row(3, 3) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 3) }
      before do
        Disc.create(space: space1, player: player)
        Disc.create(space: space2, player: player)
        Disc.create(space: space3, player: player)
        Disc.create(space: space4, player: player)
      end
      it "return true" do
        expect(player.has_won?).to eq true
      end
    end
    context "when player has 4 in a row vertically" do
      let(:space1) { Space.find_by_column_and_row(4, 1) }
      let(:space2) { Space.find_by_column_and_row(4, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(4, 4) }
      before do
        Disc.create(space: space1, player: player)
        Disc.create(space: space2, player: player)
        Disc.create(space: space3, player: player)
        Disc.create(space: space4, player: player)
      end
      it "return true" do
        expect(player.has_won?).to eq true
      end
    end
    context "when player has 4 in a row diagonally" do
      let(:space1) { Space.find_by_column_and_row(2, 1) }
      let(:space2) { Space.find_by_column_and_row(3, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 4) }
      before do
        Disc.create(space: space1, player: player)
        Disc.create(space: space2, player: player)
        Disc.create(space: space3, player: player)
        Disc.create(space: space4, player: player)
      end
      it "return true" do
        expect(player.has_won?).to eq true
      end
    end
    context "when player does not have 4 in a row" do
      it "returns false" do
        expect(player.has_won?).to eq false
      end
    end
  end
  describe "#has_room_for_win?" do
    context "when player has room for a 4 in a row horizontally" do
      let(:space1) { Space.find_by_column_and_row(2, 3) }
      let(:space2) { Space.find_by_column_and_row(3, 3) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 3) }
      before do
        Space.all.each do |s|
          Disc.create(space: s, player: other_player)
        end
        Disc.find_by_space_id(space1.id).update_attributes(player: player)
        Disc.find_by_space_id(space2.id).update_attributes(player: player)
        Disc.find_by_space_id(space3.id).update_attributes(player: player)
        Disc.find_by_space_id(space4.id).destroy
      end
      it "return true" do
        expect(player.has_room_for_win?).to eq true
      end
    end
    context "when player has room for a 4 in a row vertically" do
      let(:space1) { Space.find_by_column_and_row(4, 1) }
      let(:space2) { Space.find_by_column_and_row(4, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(4, 4) }
      before do
        Space.all.each do |s|
          Disc.create(space: s, player: other_player)
        end
        Disc.find_by_space_id(space1.id).update_attributes(player: player)
        Disc.find_by_space_id(space2.id).update_attributes(player: player)
        Disc.find_by_space_id(space3.id).update_attributes(player: player)
        Disc.find_by_space_id(space4.id).destroy
      end
      it "return true" do
        expect(player.has_room_for_win?).to eq true
      end
    end
    context "when player has room for a 4 in a row diagonally" do
      let(:space1) { Space.find_by_column_and_row(2, 1) }
      let(:space2) { Space.find_by_column_and_row(3, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 4) }
      before do
        Space.all.each do |s|
          Disc.create(space: s, player: other_player)
        end
        Disc.find_by_space_id(space1.id).update_attributes(player: player)
        Disc.find_by_space_id(space2.id).update_attributes(player: player)
        Disc.find_by_space_id(space3.id).update_attributes(player: player)
        Disc.find_by_space_id(space4.id).destroy
      end
      it "return true" do
        expect(player.has_room_for_win?).to eq true
      end
    end
    context "when player does not have room for a 4 in a row" do
      let(:space1) { Space.find_by_column_and_row(2, 1) }
      let(:space2) { Space.find_by_column_and_row(3, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      before do
        Space.all.each do |s|
          Disc.create(space: s, player: other_player)
        end
        Disc.find_by_space_id(space1.id).update_attributes(player: player)
        Disc.find_by_space_id(space2.id).update_attributes(player: player)
        Disc.find_by_space_id(space3.id).update_attributes(player: player)
      end
      it "returns false" do
        expect(player.has_room_for_win?).to eq false
      end
    end
  end
  describe "#column_for_computer" do
    let(:computer_player) { FactoryBot.create(:player, name: "computer", computer: true) }
    let!(:human_player) { FactoryBot.create(:player, name: "computer", computer: false) }
    context "when all spaces are void of discs" do
      it "returns 4" do
        expect(computer_player.column_for_computer(human_player)).to eq 4
      end
    end
    context "when other player has 3 in a row with an open space for a 4th" do
      let(:space1) { Space.find_by_column_and_row(2, 1) }
      let(:space2) { Space.find_by_column_and_row(3, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 4) }
      let(:space5) { Space.find_by_column_and_row(7, 1) }
      let(:space6) { Space.find_by_column_and_row(6, 2) }
      let(:space7) { Space.find_by_column_and_row(5, 3) }
      let(:space8) { Space.find_by_column_and_row(4, 4) }
      context "when computer also has 3 in a row with an open space for a 4th" do
        before do
          Disc.create(space: space1, player: computer_player)
          Disc.create(space: space2, player: computer_player)
          Disc.create(space: space3, player: computer_player)
          Disc.create(space: space6, player: human_player)
          Disc.create(space: space7, player: human_player)
          Disc.create(space: space8, player: human_player)
        end
        it "moves to add to its own, largest, open set" do
          expect(computer_player.column_for_computer(human_player)).to eq 5
        end
      end
      context "when computer does not have an open set of 3" do
        before do
          Disc.create(space: space1, player: computer_player)
          Disc.create(space: space2, player: computer_player)
          Disc.create(space: space3, player: computer_player)
          Disc.create(space: space4, player: human_player)
          Disc.create(space: space6, player: human_player)
          Disc.create(space: space7, player: human_player)
          Disc.create(space: space8, player: human_player)
        end
        it "moves to add to its own, largest, open set" do
          expect(computer_player.column_for_computer(human_player)).to eq 7
        end
      end
    end
    context "when other player does not have 3 in a row with an open space for a 4th" do
      let(:space1) { Space.find_by_column_and_row(1, 1) }
      let(:space2) { Space.find_by_column_and_row(2, 1) }
      let(:space3) { Space.find_by_column_and_row(3, 1) }
      before do
        Disc.create(space: space1, player: computer_player)
        Disc.create(space: space2, player: computer_player)
        Disc.create(space: space3, player: computer_player)
      end
      it "moves to add to its own, largest, open set" do
        expect(computer_player.column_for_computer(human_player)).to eq 4
      end
    end
  end
end
