class Position
  attr_reader :x, :y, :dx, :dy
  attr_accessor :xvel, :yvel, :xfrict, :yfrict

  def initialize(xpos=0, ypos=0)
    @x = @dx = xpos
    @y = @dy = ypos
    @xvel = @yvel = 0
    @xfrict = @yfrict = 999
  end

  def step
    @dx += @xvel
    @dy += @yvel
  end

  def back
    @dx = @x
    @dy = @y
  end

  def move
    @x = @dx;
    @y = @dy;
     
    @xvel < 0 ? sign = -1 : sign = 1 
    @xvel -= sign*@xfrict
    @xvel = 0 if (@xvel < 0 && sign == 1) || (@xvel > 0 && sign == -1)

    @yvel < 0 ? sign = -1 : sign = 1 
    @yvel -= sign*@yfrict
    @yvel = 0 if (@yvel < 0 && sign == 1) || (@yvel > 0 && sign == -1)
  end

  def teleport(x, y)
    @dx = @x = x
    @dy = @y = y
  end

  def stop
    @xvel = 0
    @yvel = 0
  end

end
