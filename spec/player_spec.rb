require_relative 'spec_helper'

describe Player do
  let(:p) { Player.new }
  let(:w) { GameWindow.instance }

  before do
    w.add_object(p, {input: true})
    p.input_adapter = WindowPlayerInputAdapter.new(w,p)
    p.bind_input(:p1left, :left)
    p.bind_input(:p1right, :right)
  end

  context "On recognized input" do
    it "Properly translates HW keypresses into player keypresses" do
      w.button_down(Gosu::Gp0Left) 
      expect(p.game_input[:left][:is]).to be_true
    end
  end

  context "On update" do
    it "Moves left on left input" do
      p.game_input[:left][:is] = true
      expect{ p.update }.to change{ p.pos.x }.by(-5)
    end

    it "Moves right on right input" do
      p.game_input[:right][:is] = true
      expect{ p.update }.to change{ p.pos.x }.by(5)
    end

  end
end
