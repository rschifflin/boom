class GameObject
  #CLASS MEMBERS AND METHODS 
  @@id_count = 0 
  
  #INSTANCE MEMBERS AND METHODS
  attr_reader :id, :type
  
  def initialize(*args)
    @id = @@id_count
    @@id_count += 1
    @type = :object #Used to respond to 'who-are-you'-style messages without reflection
  end

  def update

  end

  def draw

  end

  def input(*args)

  end


#COLLISION INTERFACE

  def pre_collision
  end
  def collision(*args)
  end
  def post_collision
  end
end
