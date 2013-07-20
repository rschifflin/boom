require_relative 'mover'
require_relative 'bomb'
class Player
  attr_reader :pos
  def initialize(window)
    @window = window
    @sprite = Gosu::Image.new(window, "images/stickfig.png", false)
    @arm = Gosu::Image.new(window, "images/arm.png", false)
    @pos = Mover.new 
  end

  def facing xdir, ydir
    @x_face = xdir
    @y_face = ydir
  end

  def accel dir
    case dir
    when :left
      @pos.xvel -= 1 unless @pos.xvel <= -5
    when :right
      @pos.xvel += 1 unless @pos.xvel >= 5
    when :up
      @pos.yvel = -40 if @pos.y == 602 
    when :down
      @pos.yvel += 1 unless @pos.yvel >= 5
    end
  end

  def make_bomb(xdir, ydir, fuse)
    Bomb.new(@window, xdir, ydir, @pos.x, @pos.y, fuse)
  end

  def move
    @pos.move
    @pos.xvel *= 0.95
    @pos.yvel *= 0.95
    @pos.x = 0 if @pos.x < 0
    @pos.x = 1024 - 64 if @pos.x > 1024-64
    
    @pos.y = 602 if @pos.y > 602 #Floor is y=602
  end

  def draw
    @sprite.draw(@pos.x, @pos.y, 1)

    dx = 0 
    dx = -1 if @x_face == :left
    dx = 1 if @x_face == :right

    dy = 0
    dy = 1 if @y_face == :down
    dy = -1 if @y_face == :up

    angle = Math.atan2(dy,dx) * (180.0/3.14159)
    @arm.draw_rot(@pos.x + 32, @pos.y + 32, 1, angle, 0)
  end
end
