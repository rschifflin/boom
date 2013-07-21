class Solid < GameObject

  def initialize(x=0,y=0,w=0,h=0)
    super
    @type = :solid 
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def define_box(x, y, w, h)
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def collision_data
    { type: :box, x: @x, y: @y, w: @w, h: @h } 
  end

  def draw 
    GameWindow.instance.draw_quad(
      @x, @y, Gosu::Color::BLUE,
      @x + @w, @y, Gosu::Color::BLUE,
      @x + @w, @y + @h, Gosu::Color::BLUE,
      @x, @y + @h, Gosu::Color::BLUE,
      0 #z
      )
  end

end
