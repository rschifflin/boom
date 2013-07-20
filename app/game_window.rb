require 'gosu'
require 'singleton'
class GameWindow < Gosu::Window
  include Singleton
  attr_reader :all_objects, :game_input, :object_list 
  def initialize
    super 1024, 768, false
    @add_queue = Array.new
    @remove_queue = Array.new
    @change_queue = Array.new

    @all_objects = Hash.new
    @object_list = Hash.new
    @object_list[:collision] = Hash.new(false)
    @object_list[:input] = Hash.new(false)
    @object_list[:visible] = Hash.new(false)
    @object_list[:physics] = Hash.new(false)
    @game_input = {
      p1left: {is: false, was: false},
      p1right: {is: false, was: false},
      p1up: {is: false, was: false},
      p1down: {is: false, was: false},
      p1a: {is: false, was: false},
      p1b: {is: false, was: false},
      p1c: {is: false, was: false},
      p1d: {is: false, was: false},
      
      p2left: {is: false, was: false},
      p2right: {is: false, was: false},
      p2up: {is: false, was: false},
      p2down: {is: false, was: false},
      p2a: {is: false, was: false},
      p2b: {is: false, was: false},
      p2c: {is: false, was: false},
      p2d: {is: false, was: false}

      }
  end

  def add_object obj, params 
    @add_queue << [obj, params]
  end
 
  def remove_object_by_id id 
    @remove_queue << id
  end

  def change_object_by_id(id, new_params)
    unless @all_objects[id].nil?
      obj = @all_objects[id][:object]
      old_params = @all_objects[id][:params]
      
      old_params.keep_if { |k,v| v == true && new_params[k] == false }.each_key do |k|
        @change_queue << {key: k, id: id, object: obj, action: :delete}
      end

      new_params.keep_if { |k,v| v == true && (old_params[k].nil? || old_params[k] == false) }.each_key do |k|
        @change_queue << {key: k, id: id, object: obj, action: :add}
      end
    end
  end


  def update
    @all_objects.each_value { |val| val[:object].update } 
    collision
    unload_queues
  end

  def button_down id
    button_press(id, true)
  end

  def button_up id
    button_press(id, false)
  end

  def button_press(hw_id, is_down)
    case hw_id
    when Gosu::Gp0Button0 then game_id = :p1a
    when Gosu::Gp0Button1 then game_id = :p1b
    when Gosu::Gp0Button2 then game_id = :p1c
    when Gosu::Gp0Button3 then game_id = :p1d
    when Gosu::Gp0Left then game_id = :p1left
    when Gosu::Gp0Right then game_id = :p1right
    when Gosu::Gp0Up then game_id = :p1up
    when Gosu::Gp0Down then game_id = :p1down

    when Gosu::KbLeft then game_id = :p2left
    when Gosu::KbRight then game_id = :p2right
    end
   
    unless game_id.nil?
      @game_input[game_id][:was] = @game_input[game_id][:is]
      @game_input[game_id][:is] = is_down
      @object_list[:input].each_value { |obj| obj.input game_id }
    end
  end 

  def collision
    @object_list[:collision].each do |id1, obj1|
      @object_list[:collision].each do |id2, obj2|
        obj1.collision obj2 unless id1 == id2
      end
    end
  end

  def draw
    #Gosu::Image.from_text(self, "Player1: #{@all_objects[0][:object]}", Gosu::default_font_name, 20, 10, 1000, :left).draw(40,40,1)
    #Gosu::Image.from_text(self, "P1 A: #{@game_input[:p1a][:is]}", Gosu::default_font_name, 20, 10, 1000, :left).draw(40,40,1)
    @object_list[:visible].each_value { |obj| obj.draw }
  end

  private
  def unload_queues 
    change_objects_from_queue
    add_objects_from_queue
    remove_objects_from_queue
  end

  def add_objects_from_queue
    @add_queue.each do |q|
      obj = q[0]
      params = q[1]
      unless obj.nil? || obj.id.nil?
        @all_objects[obj.id] = { object: obj, params: params } 
        params = Hash.new if params.nil?
        params.keep_if { |k,v| v == true }.each_key { |k| @object_list[k][obj.id] = obj }
      end
    end
    @add_queue.clear
  end

  def remove_objects_from_queue
    @remove_queue.each do |id|
      unless @all_objects[id].nil? 
        @all_objects[id][:params].keep_if { |k,v| v == true }.each_key { |k| @object_list[k].delete(id) }  
        @all_objects.delete(id) 
      end
    end
    @remove_queue.clear
  end

  def change_objects_from_queue
    @change_queue.each do |q|
      @object_list[q[:key]][q[:id]] = q[:object] if q[:action] == :add
      @object_list[q[:key]].delete(q[:id]) if q[:action] == :delete
    end
    @change_queue.clear
  end
end

#w = GameWindow.new
#w.show
