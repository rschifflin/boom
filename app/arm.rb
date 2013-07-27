require './game_object.rb'
require './game_window.rb'

class Arm < GameObject

  def initialize(dir=:left,x=0,y=0)
    set_arm(dir,x,y)
    super

    @image = Gosu::Image.new(GameWindow.instance, "images/blockfig_arm.png", false)
    @angle = 180
  end

  def set_arm(dir, x, y)
    @dir = dir
    @x = x
    @y = y

    case dir
    when :left      then @angle = 180
    when :right     then @angle = 0
    when :up        then @angle = -90
    when :down      then @angle = -270
    when :upleft    then @angle = -135
    when :upright   then @angle = -45
    when :downleft  then @angle = -225 
    when :downright then @angle = -315
    end
  end
  
  def x_end  
    case @dir
    when :left      then return @x - 26
    when :right     then return @x + 26 
    when :up, :down then return @x + 0 
    when :upleft, :downleft    then return @x - 22.6274
    when :upright, :downright  then return @x + 22.6274
    end
  end

  def y_end
    case @dir
    when :left,:right then return @y
    when :up          then return @y - 26
    when :down        then return @y + 26 
    when :upleft, :upright      then return @y - 22.6274
    when :downleft, :downright  then return @y + 22.6274
    end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.1875, 0.5)
  end

end
