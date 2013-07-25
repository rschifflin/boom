require_relative 'spec_helper'

describe Position do
  let(:pos) { Position.new(0,0) }
  context "Moving" do
    it "should move along its xvel and yvel vectors" do
      pos.xvel = 5
      pos.yvel = 10

      pos.move

      expect(pos.x).to eq(5)
      expect(pos.y).to eq(10)
    end

    it "should never drop below 0 velocity" do
      pos.xvel = 5
      pos.yvel = 10

      100.times do
        pos.move
      end

      expect(pos.xvel).to be >= 0
      expect(pos.yvel).to be >= 0 
    end

    it "should teleport instantly" do
      pos.teleport(100,103)
      expect(pos.x).to eq(100)
      expect(pos.y).to eq(103)
    end

    it "should kill all velocity on stop" do
      pos.xvel = 5
      pos.yvel = 7
      pos.stop
      5.times do
        pos.move
      end
      expect(pos.x).to eq(0)
      expect(pos.y).to eq(0)
    end

  end
end
