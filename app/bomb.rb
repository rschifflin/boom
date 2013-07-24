require_relative 'game_object'
require_relative 'position'
require_relative 'sprite'
require_relative 'game_window'
require_relative 'explosion'

class Bomb < GameObject
  attr_reader :pos, :fuse

  def initialize(x, y, dir, fuse)
    super
    @pos = Position.new
    @pos.teleport(x,y)
    @dir = dir
    @fuse = fuse
    
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
    @type = :bomb
  end

  def apply_velocity
    case @dir
    when :upleft
      @pos.xvel = -7.07
      @pos.yvel = -7.07
    when :left 
      @pos.xvel = -10
    when :downleft
      @pos.xvel = -7.07
      @pos.yvel = 7.07
    when :upright 
      @pos.xvel = 7.07
      @pos.yvel = -7.07 
    when :right
      @pos.xvel = 10
    when :downright
      @pos.xvel = 7.07 
      @pos.yvel = 7.07
    when :up
      @pos.yvel = -10
    when :down
      @pos.yvel = 10
    end
  end 

  def update
    apply_velocity
    if @fuse <= 0
      GameWindow.instance.remove_object_by_id(@id)
      explosion = Explosion.new(
        @pos.x + @sprite.current_image.width/2, 
        @pos.y + @sprite.current_image.height/2
        )
      GameWindow.instance.add_object(explosion, {visible: true, collision: true})
    end
    @fuse -= 1 if @fuse > 0
    @pos.move
    @sprite.update
  end

  def draw
    @sprite.draw(@pos.x-10, @pos.y-10, 2) 
  end
end
