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
    @background = Gosu::Image.new(self, "images/bg.png", false)
  end

  def button_down(id) 
    @last_input[id] = @input[id]
    @input[id] = :down
  end

  def button_up(id)
    close if id == Gosu::KbEscape
    @last_input[id] = @input[id]
    @input[id] = :up
  end
  
  def update 
    x_facing = :none 
    x_facing = :right if @input[Gosu::Gp0Right] == :down
    x_facing = :left if @input[Gosu::Gp0Left] == :down
   
    y_facing = :none
    y_facing = :up if @input[Gosu::Gp0Up] == :down
    y_facing = :down if @input[Gosu::Gp0Down] == :down
     
    @players.each do |p|
      p.facing x_facing, y_facing
      p.accel :left if @input[Gosu::Gp0Left] == :down
      p.accel :right if @input[Gosu::Gp0Right] == :down
      p.accel :up if @input[Gosu::Gp0Button0] == :down
      p.accel :down #Gravity
   
      if @input[Gosu::Gp0Button1] == :down && @last_input[Gosu::Gp0Button1] == :up
        @bombs << Bomb.new(self, x_facing, y_facing, p.pos.x, p.pos.y, 30) 
      end

      if @input[Gosu::Gp0Button2] == :down && @last_input[Gosu::Gp0Button2] == :up
        @bombs << Bomb.new(self, x_facing, y_facing, p.pos.x, p.pos.y, 60) 
      end

      p.move 
    end

    @bombs.each do |b|
      b.move
      b.update
    end

    @input.keys.each { |k| @last_input[k] = @input[k] }
  end

  def draw
    @background.draw(0,0,0)
    @players.each { |p| p.draw }
    @bombs.each { |b| b.draw } 

  end

end
