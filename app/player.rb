require_relative 'position'
require_relative 'game_object'
require_relative 'window_player_input_adapter'
require_relative 'lib/collision.rb'

class Player < GameObject
  attr_reader :pos, :binds, :game_input, :facing
  attr_accessor :input_adapter

  def initialize
    super
    @pos = Position.new
    @sprite = Sprite.new
    @facing = :left    
    @step = nil
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
    @type = :player
  end

  def update 
    
    @sprite.update
    if @game_input[:atk1][:is] == true && @game_input[:atk1][:was] == false
      GameWindow.instance.add_object(Bomb.new(@pos.x, @pos.y, :left, 30), {visible: true})
    end

    if @game_input[:atk2][:is] == true && @game_input[:atk2][:was] == false 
      GameWindow.instance.add_object(Bomb.new(@pos.x, @pos.y, :left, 60), {visible: true})
    end
    
    @game_input.each_key{ |k| @game_input[k][:was] = @game_input[k][:is] }
  end
 
  def collision_data
    return { type: :box, x: @pos.x + 12, y: @pos.y, w: 32, h: 96 } if @facing == :left
    return { type: :box, x: @pos.x + 20, y: @pos.y, w: 32, h: 96 }
  end

  def pre_collision
    @pos.xvel = 0

    @pos.yvel += 0.5 if @pos.yvel <= 10
    @pos.yvel += 0.1 unless @pos.yvel >= 40

    if @game_input[:left][:is] 
      @pos.xvel = -5
      @facing = :left
    end

    if @game_input[:right][:is]
      @pos.xvel = 5
      @facing = :right
    end

    if @game_input[:jump][:is] == true && @game_input[:jump][:was] == false
      @pos.yvel += -30
    end

    @step = { 
      xorig: @pos.x,
      xnew:  @pos.x + @pos.xvel,
      yorig: @pos.y,
      ynew:  @pos.y + @pos.yvel,
      passx: true,
      passy: true,
      passxy: true
      }
  end

  def collision other
    @pos.teleport(@step[:xnew], @step[:ynew])
    case other.collision_data[:type]
    when :box 
      if box_box?(collision_data, other.collision_data) 
        case other.type
        when :player, :solid
          @step[:passxy] = false 
          @pos.teleport(@step[:xnew], @step[:yorig]) 
          @step[:passx] = false if box_box?(collision_data, other.collision_data)
          @pos.teleport(@step[:xorig], @step[:ynew])
          @step[:passy] = false if box_box?(collision_data, other.collision_data)
        end 
      end
    when :circle 
      
    end
  end

  def post_collision
    @pos.teleport(@step[:xorig], @step[:yorig])

    if @step[:passxy] 
      @pos.move
    elsif @step[:passx]
      @pos.movex
    elsif @step[:passy]
      @pos.movey
    end
  end

  def draw
    @sprite.draw(@pos.x, @pos.y, 1, @facing==:left)
    GameWindow.instance.draw_quad(
      @pos.x,   @pos.y,   Gosu::Color::GREEN,
      @pos.x+1, @pos.y,   Gosu::Color::GREEN,
      @pos.x+1, @pos.y+1, Gosu::Color::GREEN,
      @pos.x,   @pos.y+1, Gosu::Color::GREEN
     ) 

    #Draw the hitbox
    hitbox_color = Gosu::Color.argb(0x6600ff00)
    GameWindow.instance.draw_quad(
      collision_data[:x], collision_data[:y], hitbox_color,
      collision_data[:x] + collision_data[:w], collision_data[:y], hitbox_color,
      collision_data[:x] + collision_data[:w], collision_data[:y] + collision_data[:h], hitbox_color,
      collision_data[:x], collision_data[:y] + collision_data[:h], hitbox_color,
      9999 #z
      )

  end

  def bind_input src, out
    @input_adapter.bind(src, out)
  end

  def input(key)
    @input_adapter.adapt(key) 
  end

end
