require 'gosu'
class GameWindow < Gosu::Window

  def add_player player
    @players << player
  end
  
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial"
    @players = []
  end

  def update
    @players.each do |p|
      p.accel :left  if button_down? Gosu::GpLeft 
      p.accel :right if button_down? Gosu::GpRight
      p.accel :up if button_down? Gosu::GpButton1
      p.accel :down #Gravity
      p.move
    end
  end

  def draw
    @players.each { |p| p.draw }
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
