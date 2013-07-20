require_relative 'position'
require_relative 'game_object'
require_relative 'window_player_input_adapter'

class Player < GameObject
  attr_reader :pos, :binds, :game_input
  attr_accessor :input_adapter

  def initialize
    @pos = Position.new
    @sprite = Sprite.new
    
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
      :name => :walk,
      :loop => true,
      :speed => 5,
      :index => 0,
      :paused => false,
      :images => Gosu::Image.load_tiles(GameWindow.instance, "images/blockfig_walk.png", 64, 96, false)
      }
    @sprite.add_anim anim_hash
    @sprite.set_anim :walk
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

    if @game_input[:atk1][:is] == true && @game_input[:atk1][:was] == false
      GameWindow.instance.add_object(Bomb.new(@pos.x, @pos.y, :left, 30), {visible: true})
    end

    if @game_input[:atk2][:is] == true && @game_input[:atk2][:was] == false 
      GameWindow.instance.add_object(Bomb.new(@pos.x, @pos.y, :left, 60), {visible: true})
    end
    
    @game_input.each_key{ |k| @game_input[k][:was] = @game_input[k][:is] }
  end
 
  def collision_box
    { x: pos.x, y: pos.y } 
  end

  def collision other
    dx = collision_box[:x] - other.collision_box[:x] 
    puts "Colliding!" if dx > -50 && dx < 50
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
