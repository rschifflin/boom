class Mover
  attr_accessor :x, :y, :xvel, :yvel

  def initialize(x=0, y=0)
    @x = x
    @y = y
    @xvel = 0
    @yvel = 0
  end
  
  def move
    @x += @xvel
    @y += @yvel
  end

end
