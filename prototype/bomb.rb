require 'gosu'

class Bomb
  attr_reader :fuse
  def initialize(window, xdir, ydir, xpos, ypos, fuse)
    @sprite = Gosu::Image.new(window, "images/bomb.png", false)
    @fuse = fuse
    @pos = Mover.new(xpos, ypos)
  
    case xdir
    when :left then @pos.xvel = -5
    when :right then @pos.xvel = 5
    when :none then @pos.xvel = 0
    end


    case ydir
    when :up then @pos.yvel = -5
    when :down then @pos.yvel = 5
    when :none then @pos.yvel = 0
    end
  end

  def move
    @pos.move if @fuse > 0
  end

  def update
    @fuse -= 1 if @fuse > 0
  end

  def draw
    if @fuse > 0
      @sprite.draw(@pos.x, @pos.y, 1) 
    end
  end
end
