require 'gosu'

class Bomb
  def initialize(window, xdir, ydir, xpos, ypos, fuse)
    @sprite = Gosu::Image.new(window, "images/bomb.png", false)
    @fuse = fuse
    @pos = Mover.new(xpos, ypos)
   
    xdir == :left ? @pos.xvel = -5 : @pos.xvel = 5
    ydir == :up ? @pos.yvel = -5 : @pos.yvel = 5 
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
