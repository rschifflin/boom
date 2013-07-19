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
    super 640, 480, false
    self.caption = "Gosu Tutorial"
    @players = []
    @bombs = []
  end

  def update
    input= {:x => :none,
            :y => :none,
            :btn1 => false,
            :btn2 => false,
            :btn3 => false
            }

    input[:x] = :left if button_down? Gosu::GpLeft
    input[:x] = :right if button_down? Gosu::GpRight
    input[:y] = :up if button_down? Gosu::GpUp
    input[:y] = :down if button_down? Gosu::GpDown
    input[:btn1] = true if button_down? Gosu::GpButton1
    input[:btn2] = true if button_down? Gosu::GpButton2
    input[:btn3] = true if button_down? Gosu::GpButton3

    @players.each do |p|
      p.accel input[:x]
      p.accel :up if input[:btn1]
      p.accel :down #Gravity
      
      @bombs << p.make_bomb(self, input[:x], input[:y], 30) if input[:btn2]
      @bombs << p.make_bomb(self, input[:x], input[:y], 60) if input[:btn3]
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

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
