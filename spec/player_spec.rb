require_relative 'spec_helper'

describe Player do
  let(:p) { Player.new }
  let(:w) { GameWindow.instance }

  before do
    w.add_object(p, {input: true})
    w.update
    p.input_adapter = WindowPlayerInputAdapter.new(w,p)
    p.bind_input(:p1left, :left)
    p.bind_input(:p1right, :right)
  end

  context "On recognized input" do
    it "Properly translates HW keypresses into player keypresses" do
      w.button_down(Gosu::Gp0Left) 
      expect(p.game_input[:left][:is]).to be_false
    end
  end

  context "On movement" do
    it "Moves left on left input" do
      p.game_input[:left][:is] = true
      expect{ p.pre_solid; p.post_solid }.to change{ p.pos.x }.by(-5)
    end

    it "Moves right on right input" do
      p.game_input[:right][:is] = true
      expect{ p.pre_solid; p.post_solid }.to change{ p.pos.x }.by(5)
    end
  end

  context "#Collision" do
    context "When colliding with a bomb" do

    end
  end

  context "#Facing" do
    it "should always be facing in the direction of last left/right input" do
      p.game_input[:left][:is] = true #Move player left
      p.move
      expect(p.facing).to eq(:left)
      
      p.game_input[:up][:is] = true #
      p.move
      expect(p.facing).to eq(:left)

      p.game_input[:right][:is] = true #Move player right
      p.move
      expect(p.facing).to eq(:right)

      p.game_input[:down][:is] = true #
      p.move
      expect(p.facing).to eq(:right)
    end
  end
end
