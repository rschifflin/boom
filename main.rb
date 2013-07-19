require 'gosu'
require_relative 'player'
require_relative 'game_window'

window = GameWindow.new
player = Player.new window
window.add_player player

#Launch game loop
window.show

