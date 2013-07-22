require_relative 'game_object.rb'
require_relative 'game_window.rb'
class Arm < GameObject

  def initialize(dir=:left,x=0,y=0)
    set_arm(dir,x,y)
    super
    @image = Gosu::Image.new(GameWindow.instance, "images/blockfig_arm.png", false)
    @angle = 180
  end

  def set_arm(dir, x, y)
    @dir = dir
    @xpin = x
    @ypin = y
    @x = x - 6
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

  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.2, 0.5)
  end

end
