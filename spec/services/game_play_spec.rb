require 'rails_helper'

RSpec.describe GamePlay, type: :model do
  before do
    allow($stdout).to receive(:write)
  end
  describe ".request_computer_player" do
    context "when user says they want a computer player" do
      before do
        allow(STDIN).to receive_message_chain(:gets, :strip) { "y" }
      end
      it "returns true" do
        expect(GamePlay.request_computer_player).to eq true
      end
    end
    context "when user says they do not want a computer player" do
      before do
        allow(STDIN).to receive_message_chain(:gets, :strip) { "n" }
      end
      it "returns false" do
        expect(GamePlay.request_computer_player).to eq false
      end
    end
  end
  describe ".request_move_from_computer" do
    let(:computer_player) { FactoryBot.create(:player, computer: true) }
    let(:human_player) { FactoryBot.create(:player, computer: false) }
    let(:column) { computer_player.column_for_computer(human_player) }
    it "moves into the correct column" do
      expect(computer_player).to receive(:move).with(column)
      GamePlay.request_move_from_computer(computer_player, human_player)
    end
  end
  describe ".request_name" do
    it "asks for player name" do
      expect(STDIN).to receive_message_chain(:gets, :strip) { "John" }
      GamePlay.request_name(1)
    end
    it "returns player name" do
      allow(STDIN).to receive_message_chain(:gets, :strip) { "John" }
      expect(GamePlay.request_name(1)).to eq "John"
    end
  end
  describe ".request_move" do
  	let(:player) { FactoryBot.create(:player) }
    it "asks for column in which to move" do
      expect(STDIN).to receive_message_chain(:gets, :strip) { "1" }
      GamePlay.request_move(player, 1)
    end
    it "does not call move on player more than 3 times" do
      allow(player).to receive(:move).and_return(nil)
      expect(GamePlay).to receive(:request_move).with(player, 1).at_most(3).times
      GamePlay.request_move(player, 1)
    end
  end
  describe ".the_game_is_tied?" do
  	let(:player1) { FactoryBot.create(:player) }
    let(:player2) { FactoryBot.create(:player) }
    context "neither player has room to win" do
    	before do
	      allow(player1).to receive(:has_room_for_win?).and_return(false)
	      allow(player2).to receive(:has_room_for_win?).and_return(false)
	    end
	    it "returns true" do
	      expect(GamePlay.the_game_is_tied?(player1, player2)).to eq true
	    end
	  end
	  context "one player has room to win" do
	  	before do
	      allow(player1).to receive(:has_room_for_win?).and_return(false)
	    end
	    it "returns false" do
	      expect(GamePlay.the_game_is_tied?(player1, player2)).to eq false
	    end
	  end
  end
  describe ".announce_winner" do
    let(:player) { FactoryBot.create(:player, name: "John") }
    it "exits" do
      expect(GamePlay.announce_winner(player)).to raise_error(SystemError)
    end
  end
end
