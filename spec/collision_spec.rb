require_relative 'spec_helper'

describe "The Collision helper functions" do

  context "Should not collide two bounding boxes when they dont overlap" do

    context "Border intersections" do

      specify "Box2 top touches Box1 bottom" do:w
        box1 = {x: 0, y: 0, w: 10, h: 10}
        box2 = {x: 5, y: -5, w: 10, h: 5}
        expect(box_box?(box1, box2)).to be_false
      end 

      specify "Box2 left touches Box1 right" do
        box1 = {x: 0, y: 0, w: 10, h: 10}
        box2 = {x: 10, y: 5, w: 10, h: 10}
        expect(box_box?(box1, box2)).to be_false
      end
    end

    context "Only intersect on one axis" do
      specify "Y-axis only" do
        box1 = {x: 0, y: 0, w: 10, h: 10}
        box2 = {x: 100, y: 0, w: 10, h: 10}
        expect(box_box?(box1, box2)).to be_false
      end

      specify "X-axis only" do
        box1 = {x: 0, y: 100, w: 10, h: 10}
        box2 = {x: 0, y: 0, w: 10, h: 10}
        expect(box_box?(box1, box2)).to be_false
      end
    end
  end
 
  context "Should collide two bounding boxes when they do overlap" do
    specify "Box1's left edge intrudes into Box2's right edge" do
        box1 = {x: 5, y: 3, w: 10, h: 3}
        box2 = {x: 0, y: 0, w: 6, h: 10}
        expect(box_box?(box1, box2)).to be_true
    end

    specify "Box2's top edge intrudes into Box1's bottom edge" do
        box1 = {x: 0, y: 0, w: 10, h: 10}
        box2 = {x: 2, y: 8, w: 15, h: 5}
        expect(box_box?(box1, box2)).to be_true
    end

    specify "Box2's topright corner touches Box1's bottom left corner" do
        box1 = {x: 0, y: 0, w: 10, h: 10}
        box2 = {x: -5, y: -5, w: 6, h: 6}
        expect(box_box?(box1, box2)).to be_true
    end

    specify "Box1 wholly contains box 2" do 
        box1 = {x: 0, y: 0, w: 10, h: 10}
        box2 = {x: 2, y: 2, w: 4, h: 4}
        expect(box_box?(box1, box2)).to be_true
    end
  end

  context "Should not collide box and circle when they don't overlap" do
    specify "Box topright corner within circle" do
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: 11, y: 11, r: 4}
      expect(box_circle?(box, circle)).to be_true
    end

    specify "Box topleft corner within circle" do
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: -1, y: 11, r: 4}
      expect(box_circle?(box, circle)).to be_true
    end
    
    specify "Box bottomright corner within circle" do
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: 11, y: -1, r: 4}
      expect(box_circle?(box, circle)).to be_true
    end
    
    specify "Box bottomleft corner within circle" do
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: -1, y: -1, r: 4}
      expect(box_circle?(box, circle)).to be_true
    end

    specify "Circle touches left side of box" do 
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: -1, y: 5, r: 2}
      expect(box_circle?(box, circle)).to be_true
    end

    specify "Circle touches top side of box" do 
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: 5, y: 11, r: 2}
      expect(box_circle?(box, circle)).to be_true
    end

    specify "Circle contains box" do
      box = {x: 0, y: 0, w: 1, h: 1}
      circle = {x: 0, y: 0, r: 10}
      expect(box_circle?(box, circle)).to be_true
    end
    
    specify "Box contains circle" do
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: 5, y: 5, r: 1}
      expect(box_circle?(box, circle)).to be_true
    end
  end

  context "Should not collide box and circle when they don't overlap" do
    specify "Box corner very near circle" do
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: 12, y: 12, r: 1}
      expect(box_circle?(box, circle)).to be_false
    end
    
    specify "Box nowhere near circle" do 
      box = {x: 0, y: 0, w: 10, h: 10}
      circle = {x: 100, y: 100, r: 10}
      expect(box_circle?(box, circle)).to be_false
    end
  end

  specify "Should collide circle and circle when they overlap" do
    circle1 = {x: 0, y: 0, r: 5}
    circle2 = {x: 8, y: 0, r: 5}
    expect(circle_circle?(circle1, circle2)).to be_true
  end

  specify "Should not collide circle and circle when they dont overlap" do
    circle1 = {x: 0, y: 0, r: 5}
    circle2 = {x: 15, y: -15, r: 5}
    expect(circle_circle?(circle1, circle2)).to be_false
  end

end
