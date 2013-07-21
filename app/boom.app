Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require file }

window = GameWindow.instance

p1 = Player.new
p1.pos.teleport(756, 600)
p1.input_adapter = WindowPlayerInputAdapter.new(window, p1)
p1.bind_input(:p1left, :left)
p1.bind_input(:p1right, :right)
p1.bind_input(:p1a, :atk1)
p1.bind_input(:p1d, :atk2)
p1.bind_input(:p1b, :jump)

p2 = Player.new
p2.input_adapter = WindowPlayerInputAdapter.new(window, p2)
p2.pos.teleport(268, 600)
p2.bind_input(:p2left, :left)
p2.bind_input(:p2right, :right)

window.add_object(p1, {input: true, visible: true, collision: true})
window.add_object(p2, {input: true, visible: true, collision: true})
window.add_object(Solid.new(0,720,1000,100), {collision: true, visible: true} )
window.show
