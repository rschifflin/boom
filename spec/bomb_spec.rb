require_relative 'spec_helper'

describe Bomb do
  let(:b) { Bomb.new(0,0,:left,30) }
 
  it "Flies at a constant velocity" do
    5.times do 
      b.pos.move
    end
    expect(b.pos.x).to eq(5 * b.pos.xvel)
  end

  it "Ticks off its fuse each update" do
    expect{ b.update }.to change{ b.fuse }.by (-1)
  end

end
