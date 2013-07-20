require_relative 'spec_helper'

describe Position do
  let(:pos) { Position.new(0,0) }
  context "Moving" do
    it "should move along its xvel and yvel vectors" do
      pos.xvel = 5
      pos.yvel = 10

      pos.step
      pos.move

      expect(pos.x).to eq(5)
      expect(pos.y).to eq(10)
    end

    it "should be slowed linearly by friction" do
      pos.xfrict = 1
      pos.yfrict = 1

      pos.xvel=5
      pos.yvel=3

      3.times do
        pos.step
        pos.move
      end

      expect(pos.x).to eq(5+4+3)
      expect(pos.y).to eq(3+2+1)
    end

    it "should never drop below 0 velocity" do
      pos.xvel = 5
      pos.yvel = 10
      pos.xfrict = 9999
      pos.yfrict = 9999

      100.times do
        pos.step
        pos.move
      end

      expect(pos.xvel).to eq(0)
      expect(pos.yvel).to eq(0)
    end

    it "should snap back from its delta position on #back" do
      pos.xvel = 5
      pos.yvel = 7

      pos.step
      expect(pos.x).to_not eq(pos.dx)
      expect(pos.y).to_not eq(pos.dy)
      
      pos.back
      expect(pos.x).to eq(pos.dx)
      expect(pos.y).to eq(pos.dy)
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
        pos.step
        pos.move
      end
      expect(pos.x).to eq(0)
      expect(pos.y).to eq(0)
    end

  end
end
