require_relative 'spec_helper'

describe Sprite do
  let(:spr){ Sprite.new }
  before do
    anim_hash = {
      :name => :anim1,
      :loop => true,
      :speed => 5,
      :index => 0,
      :paused => false,
      :images => %w[ a b c d e f g h i j ] 
      } 
    spr.add_anim anim_hash

    anim_hash = {
      :name => :anim2,
      :loop => false,
      :speed => 3,
      :index => 3,
      :paused => true,
      :images => %w[ 1 2 3 4 5 ] 
    }
    spr.add_anim anim_hash
  end

  it "can add animations" do
    spr.set_anim :anim1
    expect(spr.current_anim[:images].count).to eq(10)
    spr.set_anim :anim2
    expect(spr.current_anim[:images].count).to eq(5)
  end

  it "can't add animations with bad anim data" do
    anim_hash = { :name => :bad }
    expect(spr.add_anim anim_hash).to be_false
    spr.set_anim :bad
    expect(spr.current_anim).to be_nil
  end

  it "increments index when updated 'speed' times" do
    spr.set_anim :anim1 #speed 5, index 0
    4.times { spr.update }
    expect(spr.current_anim[:index]).to eq(0)
    expect{ spr.update }.to change{ spr.current_anim[:index] }.by(1)
  end

  context "When it's a non-looping animation" do
    it "stops at the last index while updating" do
      spr.set_anim :anim2 #nonlooping, index 3, speed 3, 5 images
      spr.unpause
      100.times { spr.update }
      expect(spr.current_anim[:index]).to eq(spr.current_anim[:images].count - 1)
    end
  end
  context "When it's a looping animation" do
    it "rolls over index after updating past the last image" do
      spr.set_anim :anim1 #looping, index 0, speed 5, count 10
      (5 * 10 - 1).times { spr.update }
      expect(spr.current_anim[:index]).to eq(spr.current_anim[:images].count - 1)
      expect{ spr.update }.to change{ spr.current_anim[:index] }.to(0)
    end
  end
  
  it "doesn't update the index when paused" do
    spr.set_anim :anim1 #unpaused anim 
    
    spr.pause
    expect { spr.update }.to_not change{ spr.current_anim[:counter] }
    spr.unpause
    expect { spr.update }.to change{ spr.current_anim[:counter] }
  end

  it "draws the current index" do
    spr.set_anim :anim1
    expect(spr.current_anim[:images][spr.current_anim[:index]]).to receive(:draw)
    spr.draw(0,0)
  end
end
