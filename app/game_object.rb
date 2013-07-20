class GameObject
  #CLASS MEMBERS AND METHODS 
  @@id_count = 0 

  #INSTANCE MEMBERS AND METHODS
  attr_reader :id
  
  def initialize(*args)
    @id = @@id_count
    @@id_count += 1
  end

  def update

  end

  def draw

  end

  def input(*args)

  end

  def collision(*args)

  end
end
