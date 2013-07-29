Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require "#{Dir.pwd}/#{file}" }

window = GameWindow.instance
window.startup
window.show
