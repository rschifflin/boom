require 'gosu'
require 'singleton'
class GameWindow < Gosu::Window
  include Singleton
  attr_reader :all_objects, :game_input, :object_list, :width, :height
  def initialize 
    @width = 1024
    @height = 768
    super @width, @height, false
		
		init_queues
		init_lists
		init_input
  end
	
  def init_queues
    @add_queue = Array.new
    @remove_queue = Array.new
    @change_queue = Array.new
  end
	
  def init_lists
    @all_objects = Hash.new
    @object_list = Hash.new
    @object_list[:collision] = Hash.new(false)
    @object_list[:input] = Hash.new(false)
    @object_list[:visible] = Hash.new(false)
    @object_list[:physics] = Hash.new(false)
  end
	
  def init_input
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
      p2d: {is: false, was: false},
			
      p3left: {is: false, was: false},
      p3right: {is: false, was: false},
      p3up: {is: false, was: false},
      p3down: {is: false, was: false},
      p3a: {is: false, was: false},
      p3b: {is: false, was: false},
      p3c: {is: false, was: false},
      p3d: {is: false, was: false},

      p4left: {is: false, was: false},
      p4right: {is: false, was: false},
      p4up: {is: false, was: false},
      p4down: {is: false, was: false},
      p4a: {is: false, was: false},
      p4b: {is: false, was: false},
      p4c: {is: false, was: false},
      p4d: {is: false, was: false},			
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
    collision
    @all_objects.each_value { |val| val[:object].update } 
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
    when Gosu::Gp0Button4 then game_id = :p1e
    when Gosu::Gp0Button5 then game_id = :p1f
    when Gosu::Gp0Left then game_id = :p1left
    when Gosu::Gp0Right then game_id = :p1right
    when Gosu::Gp0Up then game_id = :p1up
    when Gosu::Gp0Down then game_id = :p1down
 
    when Gosu::Gp1Button12 then game_id = :p2a
    when Gosu::Gp1Button13 then game_id = :p2b
    when Gosu::Gp1Button14 then game_id = :p2c # X button
    when Gosu::Gp1Button15 then game_id = :p2d
    when Gosu::Gp1Button10 then game_id = :p2b
    when Gosu::Gp1Button11 then game_id = :p2f
    when Gosu::Gp1Left then game_id = :p2left
    when Gosu::Gp1Right then game_id = :p2right
    when Gosu::Gp1Up then game_id = :p2up
    when Gosu::Gp1Down then game_id = :p2down
    when Gosu::KbR then reset 
    when Gosu::KbEscape then close
    when Gosu::Gp0Button8 then reset
    end

    unless game_id.nil?
      @game_input[game_id][:was] = @game_input[game_id][:is]
      @game_input[game_id][:is] = is_down

      @object_list[:input].each_value { |obj| obj.input game_id }
    end
  end 

  def startup
    p1 = Player.new
    p1.pos.teleport(@width/4, @height/2)
    p1.input_adapter = WindowPlayerInputAdapter.new(self, p1)
    p1.bind_input(:p1left, :left)
    p1.bind_input(:p1right, :right)
    p1.bind_input(:p1up, :up)
    p1.bind_input(:p1down, :down)
    p1.bind_input(:p1a, :atk1)
    p1.bind_input(:p1d, :atk2)
    p1.bind_input(:p1b, :jump)

    p2 = Player.new
		p2.pos.teleport(@width*(3.0/4), @height/2)
    p2.input_adapter = WindowPlayerInputAdapter.new(self, p2)
    p2.bind_input(:p2left, :left)
    p2.bind_input(:p2right, :right)
    p2.bind_input(:p2up, :up)
    p2.bind_input(:p2down, :down)
    p2.bind_input(:p2d, :atk1)
    p2.bind_input(:p2a, :atk2)
    p2.bind_input(:p2c, :jump)

		#Adding p1, p2, floor, left wall, right wall, and invisible ceiling
    add_object(p1, {input: true, visible: true, collision: true})  
    add_object(p2, {input: true, visible: true, collision: true})
    add_object(Solid.new(0,@height-40,@width,100), {collision: true, visible: true} )
    add_object(Solid.new(-100,0,110,@height), {collision: true, visible: true} )
    add_object(Solid.new(@width-10,0,110,@height), {collision: true, visible: true} )
    add_object(Solid.new(0,-100,@width,110), {collision: true} )
  end

  def reset
    unload_queues
    @all_objects.clear
    @object_list.each_value { |v| v.clear }
    startup
  end

  def collision
    @object_list[:collision].each do |id1, obj1|
      obj1.pre_collision
      @object_list[:collision].each do |id2, obj2| 
        obj1.collision obj2 unless id1 == id2
      end
      obj1.post_collision
    end
  end

  def draw
		@object_list[:visible].each_value { |obj| obj.draw }
		
		#Draw inputs
    #spacing = 0
    #@game_input.each do |k, v| 
    #  Gosu::Image.from_text(self, "#{k}: #{@game_input[k][:is]}", Gosu::default_font_name, 20, 10, 1000, :left).draw(40,40+spacing,1)
    #  spacing += 20
    #end
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
        params ||= Hash.new
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
