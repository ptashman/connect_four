require 'rails_helper'

RSpec.describe Space, type: :model do
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
  describe "methods for filling with disc" do
    let(:player) { FactoryBot.create(:player) }
    let(:space1) { Space.find_by_column_and_row(3, 1) }
    let(:space2) { Space.find_by_column_and_row(3, 2) }
    let(:space3) { Space.find_by_column_and_row(3, 3) }
    let(:space4) { Space.find_by_column_and_row(3, 4) }
    let(:space5) { Space.find_by_column_and_row(3, 5) }
    let(:space6) { Space.find_by_column_and_row(3, 6) }
    before do
      FactoryBot.create(:disc, space: space1, player: player)
      FactoryBot.create(:disc, space: space2, player: player)
      FactoryBot.create(:disc, space: space3, player: player)
      FactoryBot.create(:disc, space: space4, player: player)
    end
    describe "#fill" do
      context "when there is a space to be filled" do
        it "creates a disc in the first, empty space" do
          expect { Space.fill(3, player) }.to change(
            Disc.where(space: space5),
          :count).by(1)
        end
      end
      context "when there is not a space to be filled" do
        it "does not create a new disc" do
          FactoryBot.create(:disc, space: space5, player: player)
          FactoryBot.create(:disc, space: space6, player: player)
          expect { Space.fill(3, player) }.to_not change(
            Disc.where(space: space5),
          :count)
        end
      end
    end
    describe "#first_open_space_in_column" do
      context "when there is an open space" do
        it "returns the correct open space" do
          expect(Space.first_open_space_in_column(3)).to eq(space5)
        end
      end
      context "when there is no open space" do
        it "returns nil" do
          FactoryBot.create(:disc, space: space5, player: player)
          FactoryBot.create(:disc, space: space6, player: player)
          expect(Space.first_open_space_in_column(3)).to be(nil)
        end
      end
    end
  end
  describe "disc set methods" do
    describe ".horizontal_disc_set?" do
      let(:player) { FactoryBot.create(:player) }
      let(:space1) { Space.find_by_column_and_row(2, 3) }
      let(:space2) { Space.find_by_column_and_row(3, 3) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 3) }
      context "when there is one horizontal set" do
        before do
          Disc.create(space: space1, player: player)
          Disc.create(space: space2, player: player)
          Disc.create(space: space3, player: player)
          Disc.create(space: space4, player: player)
        end
        it "returns true" do
          expect(Space.sets_of_four_in_one_direction("horizontal", player).flatten.present?).to eq true
        end
      end
      context "when there is no horizontal set" do
        before do
          Disc.create(space: space1, player: player)
          Disc.create(space: space2, player: player)
          Disc.create(space: space3, player: player)
        end
        it "returns false" do
          expect(Space.sets_of_four_in_one_direction("horizontal", player).flatten.present?).to eq false
        end
      end
    end
    describe ".vertical_disc_set?" do
      let(:player) { FactoryBot.create(:player) }
      let(:space1) { Space.find_by_column_and_row(4, 1) }
      let(:space2) { Space.find_by_column_and_row(4, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(4, 4) }
      context "when there is one vertical set" do
        before do
          Disc.create(space: space1, player: player)
          Disc.create(space: space2, player: player)
          Disc.create(space: space3, player: player)
          Disc.create(space: space4, player: player)
        end
        it "returns true" do
          expect(Space.sets_of_four_in_one_direction("vertical", player).flatten.present?).to eq true
        end
      end
      context "when there is no vertical set" do
        before do
          Disc.create(space: space1, player: player)
          Disc.create(space: space2, player: player)
          Disc.create(space: space3, player: player)
        end
        it "returns false" do
          expect(Space.sets_of_four_in_one_direction("vertical", player).flatten.present?).to eq false
        end
      end
    end
    describe ".diagonal_disc_set?" do
      let(:player) { FactoryBot.create(:player) }
      let(:space1) { Space.find_by_column_and_row(2, 1) }
      let(:space2) { Space.find_by_column_and_row(3, 2) }
      let(:space3) { Space.find_by_column_and_row(4, 3) }
      let(:space4) { Space.find_by_column_and_row(5, 4) }
      let(:space5) { Space.find_by_column_and_row(6, 2) }
      let(:space6) { Space.find_by_column_and_row(5, 3) }
      let(:space7) { Space.find_by_column_and_row(4, 4) }
      let(:space8) { Space.find_by_column_and_row(3, 5) }
      context "when there is one bottom left to upper right diagonal set" do
        before do
          Disc.create(space: space1, player: player)
          Disc.create(space: space2, player: player)
          Disc.create(space: space3, player: player)
          Disc.create(space: space4, player: player)
        end
        it "returns true" do
          expect(Space.sets_of_four_in_one_direction("diagonal_up", player).flatten.present?).to eq true
        end
      end
      context "when there is one bottom right to upper left diagonal set" do
        before do
          Disc.create(space: space5, player: player)
          Disc.create(space: space6, player: player)
          Disc.create(space: space7, player: player)
          Disc.create(space: space8, player: player)
        end
        it "returns true" do
          expect(Space.sets_of_four_in_one_direction("diagonal_down", player).flatten.present?).to eq true
        end
      end
      context "when there is no diagonal set" do
        before do
          Disc.create(space: space1, player: player)
          Disc.create(space: space3, player: player)
          Disc.create(space: space4, player: player)
        end
        it "returns false for bottom left to upper right" do
          expect(Space.sets_of_four_in_one_direction("diagonal_up", player).flatten.present?).to eq false
        end
        it "returns false for bottom right to upper left" do
          expect(Space.sets_of_four_in_one_direction("diagonal_down", player).flatten.present?).to eq false
        end
      end
    end
    describe "disc room methods" do
      describe ".horizontal_disc_room?" do
        let(:player) { FactoryBot.create(:player) }
        let(:other_player) { FactoryBot.create(:player) }
        let(:space1) { Space.find_by_column_and_row(2, 3) }
        let(:space2) { Space.find_by_column_and_row(3, 3) }
        let(:space3) { Space.find_by_column_and_row(4, 3) }
        let(:space4) { Space.find_by_column_and_row(5, 3) }
        context "when there is room for one horizontal set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space1.id).update_attributes(player: player)
            Disc.find_by_space_id(space2.id).update_attributes(player: player)
            Disc.find_by_space_id(space3.id).update_attributes(player: player)
            Disc.find_by_space_id(space4.id).destroy
          end
          it "returns true" do
            expect(Space.sets_of_four_in_one_direction("horizontal", player, true).flatten.present?).to eq true
          end
        end
        context "when there is no room for a horizontal set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space1.id).update_attributes(player: player)
            Disc.find_by_space_id(space2.id).update_attributes(player: player)
            Disc.find_by_space_id(space3.id).update_attributes(player: player)
          end
          it "returns false" do
            expect(Space.sets_of_four_in_one_direction("horizontal", player, true).flatten.present?).to eq false
          end
        end
      end
      describe ".vertical_disc_room?" do
        let(:player) { FactoryBot.create(:player) }
        let(:other_player) { FactoryBot.create(:player) }
        let(:space1) { Space.find_by_column_and_row(4, 1) }
        let(:space2) { Space.find_by_column_and_row(4, 2) }
        let(:space3) { Space.find_by_column_and_row(4, 3) }
        let(:space4) { Space.find_by_column_and_row(4, 4) }
        context "when there is room for a vertical set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space1.id).update_attributes(player: player)
            Disc.find_by_space_id(space2.id).update_attributes(player: player)
            Disc.find_by_space_id(space3.id).update_attributes(player: player)
            Disc.find_by_space_id(space4.id).destroy
          end
          it "returns true" do
            expect(Space.sets_of_four_in_one_direction("vertical", player, true).flatten.present?).to eq true
          end
        end
        context "when there is no room for a vertical set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space1.id).update_attributes(player: player)
            Disc.find_by_space_id(space2.id).update_attributes(player: player)
            Disc.find_by_space_id(space3.id).update_attributes(player: player)
          end
          it "returns false" do
            expect(Space.sets_of_four_in_one_direction("vertical", player, true).flatten.present?).to eq false
          end
        end
      end
      describe ".diagonal_disc_room?" do
        let(:player) { FactoryBot.create(:player) }
        let(:other_player) { FactoryBot.create(:player) }
        let(:space1) { Space.find_by_column_and_row(2, 1) }
        let(:space2) { Space.find_by_column_and_row(3, 2) }
        let(:space3) { Space.find_by_column_and_row(4, 3) }
        let(:space4) { Space.find_by_column_and_row(5, 4) }
        let(:space5) { Space.find_by_column_and_row(6, 2) }
        let(:space6) { Space.find_by_column_and_row(5, 3) }
        let(:space7) { Space.find_by_column_and_row(4, 4) }
        let(:space8) { Space.find_by_column_and_row(3, 5) }
        let(:space9) { Space.find_by_column_and_row(3, 5) }
        context "when there is room for one bottom left to upper right diagonal set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space1.id).update_attributes(player: player)
            Disc.find_by_space_id(space2.id).update_attributes(player: player)
            Disc.find_by_space_id(space3.id).update_attributes(player: player)
            Disc.find_by_space_id(space4.id).destroy
          end
          it "returns true" do
            expect(Space.sets_of_four_in_one_direction("diagonal_up", player, true).flatten.present?).to eq true
          end
        end
        context "when there is room for one bottom right to upper left diagonal set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space5.id).destroy
            Disc.find_by_space_id(space6.id).update_attributes(player: player)
            Disc.find_by_space_id(space7.id).update_attributes(player: player)
            Disc.find_by_space_id(space8.id).update_attributes(player: player)
          end
          it "returns true" do
            expect(Space.sets_of_four_in_one_direction("diagonal_down", player, true).flatten.present?).to eq true
          end
        end
        context "when there is no room for a diagonal set" do
          before do
            Space.all.each do |s|
              Disc.create(space: s, player: other_player)
            end
            Disc.find_by_space_id(space1.id).update_attributes(player: player)
            Disc.find_by_space_id(space2.id).update_attributes(player: player)
            Disc.find_by_space_id(space3.id).update_attributes(player: player)
          end
          it "returns false for bottom left to upper right" do
            expect(Space.sets_of_four_in_one_direction("diagonal_up", player, true).flatten.present?).to eq false
          end
          it "returns false for bottom right to upper left" do
            expect(Space.sets_of_four_in_one_direction("diagonal_down", player, true).flatten.present?).to eq false
          end
        end
      end
    end
  end
end
