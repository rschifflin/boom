Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require file }

window = GameWindow.instance
window.startup
window.show
