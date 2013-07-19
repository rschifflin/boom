require 'gosu'
require_relative 'bomb'

class GameWindow < Gosu::Window

  def add_player obj
    @players << obj
  end

  def add_bomb obj
    @bombs << obj
  end
  
  def initialize
    @input = Hash.new(:up)
    @last_input = Hash.new(:up)
    super 1024, 768, false
    self.caption = "Gosu Tutorial"
    @players = []
    @bombs = []
  end

  def button_down(id) 
    close if id == Gosu::KbEscape
    @last_input[id] = @input[id]
    @input[id] = :down
  end

  def button_up(id)
    @last_input[id] = @input[id]
    @input[id] = :up
  end
  
  def update
    @players.each do |p|
      p.accel :left if @input[Gosu::Gp0Left] == :down
      p.accel :right if @input[Gosu::Gp0Right] == :down
      p.accel :up if @input[Gosu::Gp0Button0] == :down
      p.accel :down #Gravity
        
      p.move 
    end

    @bombs.each do |b|
      b.move
      b.update
    end
  end

  def draw
    @players.each { |p| p.draw }
    @bombs.each { |b| b.draw } 
  end

end
