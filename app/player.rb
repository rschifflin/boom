require_relative 'position'
require_relative 'game_object'
require_relative 'window_player_input_adapter'
class Player < GameObject
  attr_reader :pos, :binds, :game_input
  attr_accessor :input_adapter

  def initialize
    @pos = Position.new
    @sprite = Sprite.new()
    
    @game_input = {
      :left   => { is: false, was: false },
      :down   => { is: false, was: false },
      :up     => { is: false, was: false },
      :right  => { is: false, was: false },
      :atk1   => { is: false, was: false },
      :atk2   => { is: false, was: false },
      :atk3   => { is: false, was: false },
      :jump   => { is: false, was: false }
      }

    anim_hash = {
      :name => :stand,
      :loop => true,
      :speed => 10,
      :index => 0,
      :paused => false,
      :images => [ #:some, :random, :images ]
        Gosu::Image.new(GameWindow.instance, "images/stickfig.png", false),
        Gosu::Image.new(GameWindow.instance, "images/bomb.png", false),
        Gosu::Image.new(GameWindow.instance, "images/arm.png", false)
        ] 
      }    
    @sprite.add_anim anim_hash
    @sprite.set_anim :stand
    @pos.teleport(50,50)
    super
  end

  def update
    @sprite.update

    if @game_input[:left][:is] 
      @pos.xvel = -5
      @pos.step
      @pos.move
    end

    if @game_input[:right][:is]
      @pos.xvel = 5
      @pos.step
      @pos.move
    end
  end

  def draw
    @sprite.draw(@pos.x, @pos.y, 1)
  end

  def bind_input src, out
    @input_adapter.bind(src, out)
  end

  def input(key)
    @input_adapter.adapt(key) 
  end

end
