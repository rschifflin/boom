require_relative 'mover'
require_relative 'bomb'
class Player
  def initialize(window)
    @sprite = Gosu::Image.new(window, "images/stickfig.png", false)
    @pos = Mover.new 
  end

  def accel dir
    case dir
    when :left
      @pos.xvel -= 1 unless @pos.xvel <= -5
    when :right
      @pos.xvel += 1 unless @pos.xvel >= 5
    when :up
      @pos.yvel = -10 if @pos.y == 320
    when :down
      @pos.yvel += 1 unless @pos.yvel >= 5
    end
  end

  def make_bomb(window, xdir, ydir, fuse)
    Bomb.new(window, xdir, ydir, @pos.x, @pos.y, fuse)
  end

  def move
    @pos.move
    
    @pos.xvel *= 0.95
    @pos.yvel *= 0.95
    @pos.y = 320 if @pos.y > 320 #Floor is y=320
  end

  def draw
    @sprite.draw(@pos.x, @pos.y, 1)
  end
end
