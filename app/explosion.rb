class Explosion < GameObject
  
  def initialize(x,y)
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
    super
  end

  def collision_box
    return { x: @x, y: @y, width: 20, height: 20 } if @duration == 10
   
    { x: -999, y: -999, width: 0, height: 0 }
  end
  
  def update
    GameWindow.instance.remove_object_by_id(@id) if @duration <= 0
    @duration -= 1 if @duration > 0
  end

  def draw
    @sprite.draw(@x, @y, 1)
  end
  
end