class Position
  attr_accessor :x, :y, :xvel, :yvel

  def initialize(xpos=0, ypos=0)
    @x = xpos
    @y = ypos
    @xvel = @yvel = 0
  end

  def move
    movex
    movey
  end

  def movex
    @x += @xvel
  end

  def movey
    @y += @yvel
  end

  def teleport(x, y)
    @x = x
    @y = y
  end

  def stop
    @xvel = 0
    @yvel = 0
  end

end
