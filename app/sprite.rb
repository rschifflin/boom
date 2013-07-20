require 'gosu'
require_relative 'game_window'

class Sprite 
    
  def initialize 
    @anims = Hash.new
    @current_key = nil
    @current_anim = nil
  end

  def draw(x, y, z)
    anim = current_anim
    index = current_anim[:index]
    image = current_anim[:images][index]
    image.draw(x, y, z) 
  end

  def add_anim anim_hash
    if (valid = validate_anim anim_hash)
      @anims[anim_hash[:name]] = anim_hash 
      @anims[anim_hash[:name]][:counter] = 0
    end
    valid
  end

  def set_anim anim_name
    @current_key = anim_name
    unless @anims[@current_key].nil?
      @anims[@current_key][:counter] = 0
      @anims[@current_key][:index] = 0
    end
  end

  def current_anim
    @anims[@current_key]
  end

  def update
    unless @anims[@current_key].nil? || @anims[@current_key][:paused]
      update_counter
    end
  end

  def pause
    @anims[@current_key][:paused] = true
  end
  
  def unpause
    @anims[@current_key][:paused] = false
  end
  private
  def update_counter
    anim = current_anim
    anim[:counter] += 1 
    if anim[:counter] >= anim[:speed] 
      anim[:counter] = 0
      update_index
    end
  end

  def update_index
    anim = current_anim
    anim[:index] += 1
    if anim[:index] >= anim[:images].count
      anim[:index] = 0 if anim[:loop]
      anim[:index] = anim[:images].count - 1 if !anim[:loop]
    end
  end

  def validate_anim anim_hash
    #presence
    return false if anim_hash[:name].nil?
    return false if anim_hash[:images].nil?
    return false if anim_hash[:loop].nil?
    return false if anim_hash[:speed].nil?
    return false if anim_hash[:index].nil?
    return false if anim_hash[:paused].nil?

    #Semantics
    return false if anim_hash[:images].count < 1
    count = anim_hash[:images].count
    return false if anim_hash[:loop] != true && anim_hash[:loop] != false
    return false if anim_hash[:speed] < 1
    return false if anim_hash[:index] > count || anim_hash[:index] < 0
    return false if anim_hash[:paused] != true && anim_hash[:paused] != false
    
    return true
  end

end
