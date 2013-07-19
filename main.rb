require 'gosu'
require_relative 'player'
require_relative 'game_window'

window = GameWindow.new
player1 = Player.new window
player2 = Player.new window 
window.add_player player1

#Launch game loop
window.show

