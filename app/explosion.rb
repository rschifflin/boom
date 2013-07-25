class Explosion < GameObject
  
  def initialize(x,y)
    super
    @duration = 10
    @sprite = Sprite.new
    anim_hash = {
      :name => :explosion,
      :loop => true,
      :speed => 10,
      :index => 0,
      :paused => false,
      :images => [ #:some, :random, :images ]
        Gosu::Image.new(GameWindow.instance, "images/boom.png", false),
        ] 
      }
    @sprite.add_anim anim_hash
    @sprite.set_anim :explosion
    @x = x - @sprite.current_image.width/2
    @y = y - @sprite.current_image.height/2
    @type = :kill
  end

  def collision_data
    r = @sprite.current_image.width / 2 
    return { type: :circle, x: @x + r, y: @y + r, r: r } if @duration > 5 
    return { type: :none } 
  end
  
  def update
    GameWindow.instance.remove_object_by_id(@id) if @duration <= 0
    @duration -= 1 if @duration > 0
  end

  def draw
    color = Gosu::Color.new(0xaa00ff00)
    @sprite.draw(@x, @y, 1)
  
    #Draw hitbox
    #d = collision_data
    #if d[:type] == :circle
    #  r = d[:r]
    #  x = d[:x]
    #  y = d[:y]
    #  GameWindow.instance.draw_quad(
    #    x - r, y - r, color,
    #    x + r, y - r, color,
    #    x + r, y + r, color,
    #    x - r, y + r, color)
    #end
  end
  
end
