require "#{File.dirname(__FILE__)}/position"
require "#{File.dirname(__FILE__)}/game_object"
require "#{File.dirname(__FILE__)}/window_player_input_adapter"
require "#{File.dirname(__FILE__)}/lib/collision.rb"
require "#{File.dirname(__FILE__)}/arm"

class Player < GameObject
  attr_reader :pos, :binds, :game_input, :facing, :jump_state
  attr_accessor :input_adapter

  def initialize
    super
    @pos = Position.new
    @arm = Arm.new
    @sprite = Sprite.new
    @facing = :left    
    
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

    anim_hash = {
      :name => :jump,
      :loop => true,
      :speed => 5,
      :index => 0,
      :paused => false,
      :images => [ Gosu::Image.new(GameWindow.instance, "images/blockfig_jump.png", false) ]
      }
    @sprite.add_anim anim_hash
    
    anim_hash = {
      :name => :stand,
      :loop => true,
      :speed => 5,
      :index => 0,
      :paused => false,
      :images => [ Gosu::Image.new(GameWindow.instance, "images/blockfig_stand.png", false) ]
      }
    @sprite.add_anim anim_hash

    anim_hash = {
      :name => :death,
      :loop => false,
      :speed => 5,
      :index => 0,
      :paused => false,
      :images => Gosu::Image.load_tiles(GameWindow.instance, "images/blockfig_die.png", 64, 96, false)
      }
    @sprite.add_anim anim_hash

    @type = :player 
    @state = { dead: false, jump: :ground }
    @counter = { atk1: 0, atk2: 0, atk3: 0, freeze: 0, rising: 0 } 
  end

  def update  
    @sprite.update
    @arm.set_arm(get_8dir, @pos.x+32, @pos.y+40)
    attack if @counter[:freeze] == 0

    update_counters
    @game_input.each_key{ |k| @game_input[k][:was] = @game_input[k][:is] }
  end

  def update_counters
    @counter.each_key { |k| @counter[k] -= 1 if @counter[k] > 0 }
  end
	
  def get_8dir
    if @game_input[:left][:is]
      return :upleft if @game_input[:up][:is]
      return :downleft if @game_input[:down][:is]
      return :left
    elsif @game_input[:right][:is]
      return :upright if @game_input[:up][:is]
      return :downright if @game_input[:down][:is]
      return :right
    elsif @game_input[:up][:is]
      return :up
    elsif @game_input[:down][:is]
      return :down
    else
      return @facing
    end
  end

  def attack
    if @game_input[:atk1][:is] == true   && 
       @game_input[:atk1][:was] == false &&
       @counter[:atk1] == 0
      GameWindow.instance.add_object(Bomb.new(@arm.x_end, @arm.y_end, get_8dir, 30), {visible: true}) 
      @counter[:atk1] = 45
    end

    if @game_input[:atk2][:is] == true   &&
       @game_input[:atk2][:was] == false &&
       @counter[:atk2] == 0     
      GameWindow.instance.add_object(Bomb.new(@arm.x_end, @arm.y_end, get_8dir, 45), {visible: true}) 
      @counter[:atk2] = 45
    end
  end

  def move
    if @game_input[:left][:is] 
      @pos.xvel = -5
      @facing = :left
    end

    if @game_input[:right][:is]
      @pos.xvel = 5
      @facing = :right
    end
  end

  def jump
    if @game_input[:jump][:is] == true  && 
       @game_input[:jump][:was] == true && 
       @state[:jump] == :rising
      
      @pos.yvel = -10
    end

    if @game_input[:jump][:is] == false && 
       @state[:jump] == :rising
      @state[:jump] = :air
    end

    if @game_input[:jump][:is] == true   && 
       @game_input[:jump][:was] == false && 
       @state[:jump] == :ground 

      @pos.yvel = -10
      @state[:jump] = :rising
      @counter[:rising] = 30
      @sprite.set_anim(:jump)
    end
		
    if @state[:jump] == :rising
      @state[:jump] = :air if @counter[:rising] == 0
    end		
  end

  def die
    GameWindow.instance.change_object_by_id(@id, {input: false, collision: false} )
    @sprite.set_anim :death
    @sprite.lock
    @state[:dead] = true
    @game_input.each_key { |k| @game_input[k] = { is: false, was: false } }
  end

  def collision_data
    solid_data
  end

  def solid_data
    if @facing == :left
      return { type: :none, x: @pos.x + 12, y: @pos.y, w: 32, h: 96 } if @state[:dead]
      return { type: :box, x: @pos.x + 12, y: @pos.y, w: 32, h: 96 } 
    else
      return { type: :none, x: @pos.x + 20, y: @pos.y, w: 32, h: 96 } if @state[:dead]
      return { type: :box, x: @pos.x + 20, y: @pos.y, w: 32, h: 96 }
    end
  end

  def pre_solid 
    if @counter[:freeze] == 0
      @pos.xvel = 0
      @pos.yvel += 0.5 if @pos.yvel <= 10
      @pos.yvel += 0.1 unless @pos.yvel >= 40
 
      move
      jump
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

  def solid other
    @pos.teleport(@step[:xnew], @step[:ynew])
		
    case other.solid_data[:type]
    when :box 
      if box_box?(solid_data, other.solid_data) 
        case other.type
        when :player, :solid
          @step[:passxy] = false 

          @pos.teleport(@step[:xorig], @step[:ynew])
          if box_box?(solid_data, other.solid_data)
            @step[:passy] = false 
            if solid_data[:y] < other.solid_data[:y]
              @step[:ynew] = other.solid_data[:y] - solid_data[:h] - (solid_data[:y] - @pos.y) 
            else
              @step[:ynew] = other.solid_data[:y] + other.solid_data[:h] + (solid_data[:y] - @pos.y)
            end
          end

          @pos.teleport(@step[:xnew], @step[:ynew]) 
          if box_box?(solid_data, other.solid_data)
            @step[:passx] = false 
            if solid_data[:x] < other.solid_data[:x]
              @step[:xnew] = other.solid_data[:x] - solid_data[:w] - (solid_data[:x] - @pos.x) - 1
            else
              @step[:xnew] = other.solid_data[:x] + other.solid_data[:w] - (solid_data[:x] - @pos.x) + 1
            end
          end
        end 
      end
    end
  end

  def post_solid 
    @pos.teleport(@step[:xnew], @step[:ynew]) 

    @state[:jump] = :ground if @pos.y == @step[:yorig] 
    if @state[:jump] == :ground && @step[:xorig] == @step[:xnew] 
      @sprite.set_anim(:stand)
    elsif @state[:jump] == :ground && @sprite.current_anim[:name] != :walk
      @sprite.set_anim(:walk)
    end

    @state[:jump] = :air if @pos.y > @step[:yorig]
  end

  def collision other
    case other.collision_data[:type]
    when :circle
      if box_circle?(collision_data, other.collision_data)
        case other.type
        when :kill
          die
        end
      end
    end
  end

  def draw
    @sprite.draw(@pos.x, @pos.y, 1, @facing==:left)
    @arm.draw unless @state[:dead]	
    #Draw dot for x,y pos
    #GameWindow.instance.draw_quad(
    #  @pos.x,   @pos.y,   Gosu::Color::GREEN,
    #  @pos.x+1, @pos.y,   Gosu::Color::GREEN,
    #  @pos.x+1, @pos.y+1, Gosu::Color::GREEN,
    #  @pos.x,   @pos.y+1, Gosu::Color::GREEN
    # ) 
   
    #Draw inputs
    #spacing = 0
    #@game_input.each do |k, v| 
    #  Gosu::Image.from_text(GameWindow.instance, "#{k}: #{@game_input[k][:is]}, #{@game_input[k][:was]}", Gosu::default_font_name, 20, 10, 1000, :left).draw(540+(@id*200),40+spacing,1)
    #  spacing += 20
    #end

    #Draw position
    Gosu::Image.from_text(GameWindow.instance, "(#{@pos.x}, #{@pos.y})", Gosu::default_font_name, 20, 10, 1000, :left).draw(540+(@id*200),40,1)

		
    ##Draw the hitbox
    #hitbox_color = Gosu::Color.argb(0x6600ff00)
    #GameWindow.instance.draw_quad(
    #  collision_data[:x], collision_data[:y], hitbox_color,
    #  collision_data[:x] + collision_data[:w], collision_data[:y], hitbox_color,
    #  collision_data[:x] + collision_data[:w], collision_data[:y] + collision_data[:h], hitbox_color,
    #  collision_data[:x], collision_data[:y] + collision_data[:h], hitbox_color,
    #  9999 #z
    #  )

  end

  def bind_input src, out
    @input_adapter.bind(src, out)
  end

  def input(key)
    @input_adapter.adapt(key) 
  end

end
