require_relative 'game_object'
require_relative 'position'
require_relative 'sprite'
require_relative 'game_window'
require_relative 'explosion'

class Bomb < GameObject
  attr_reader :pos, :fuse
  def initialize(x, y, dir, fuse)
    @pos = Position.new
    @pos.teleport(x,y)
    @pos.xfrict = 0
    @pos.yfrict = 0
    @dir = dir
    @fuse = fuse
    case @dir
    when :upleft, :left, :downleft
      @pos.xvel = -10
    when :upright, :right, :downright
      @pos.xvel = 10
    when :upleft, :up, :upright
      @pos.yvel = -10
    when :downleft, :down, :downright
      @pos.yvel = 10
    end

    @sprite = Sprite.new
    anim_hash = {
      :name => :bomb,
      :loop => true,
      :speed => 10,
      :index => 0,
      :paused => false,
      :images => [ #:some, :random, :images ]
        Gosu::Image.new(GameWindow.instance, "images/bomb.png", false),
        ] 
      }
    @sprite.add_anim anim_hash
    @sprite.set_anim :bomb
    super #Gives us our obj id
  end

  def update
    if @fuse <= 0
      GameWindow.instance.remove_object_by_id(@id)
      explosion = Explosion.new(
        @pos.x + @sprite.current_image.width/2, 
        @pos.y + @sprite.current_image.height/2
        )
      GameWindow.instance.add_object(explosion, {visible: true, collision: true})
    end
    @fuse -= 1 if @fuse > 0
    @pos.step
    @pos.move
    @sprite.update
  end

  def draw
    @sprite.draw(@pos.x, @pos.y, 2) 
  end
end
