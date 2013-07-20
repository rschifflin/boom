class WindowPlayerInputAdapter
  def initialize window, player
    @window = window
    @player = player

    @input_map = Hash.new
    @output_map = Hash.new
  end

  def bind(input, output)
    @input_map[input] = output
    @output_map[output] = input
  end

  def adapt(input)
    window_key = input
    player_key = @input_map[input]
    @player.game_input[player_key] = @window.game_input[window_key]
  end

end
