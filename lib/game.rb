module Battleship
  class Game < CyberarmEngine::GuiState
    def setup
      theme(THEME)
      background 0xff_203020

      flow(width: 1.0, height: 1.0) do
        # Players board
        player_board = stack(width: 0.5, height: 1.0) do
          background 0xff_102010
        end

        @player_board = @options[:player_board]
        @player_board.parent = player_board
        @game_objects << @player_board

        # Players attack board and command prompt
        stack(width: 0.5, height: 1.0) do
          attack_board = stack(width: 1.0, height: 0.5) do
          end

          @attack_board = Grid.new(parent: attack_board)
          @game_objects << @attack_board

          stack(margin: 20, width: 1.0, height: 0.5) do
            @command_history = stack(width: 1.0, height: 0.82, padding: 10, scroll: true, border_thickness: 2, border_color: Gosu::Color::GREEN) do
              background Gosu::Color::BLACK
            end

            @command_prompt = edit_line "", width: 1.0
          end
        end
      end
    end

    def draw
      super

      Gosu.flush

      @player_board.cells.each do |cell|
        if cell.data.is_a?(Ship)
          ship = cell.data
          ship.draw_in_grid(@player_board)
        end
      end
    end

    def update
      super

      unless focused == @command_prompt
        self.focus = @command_prompt
        @command_prompt.instance_variable_set(:"@focus", true)
        window.text_input = @command_prompt.instance_variable_get(:"@text_input")
      end
    end

    def button_down(id)
      super

      case id
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        if @command_prompt && !@command_prompt.value.empty? && @command_prompt.enabled?
          handle_command
        end
      when Gosu::KB_ESCAPE
        push_state(Menus::Pause)
      end
    end

    def handle_command
      return unless @game_proxy.current_turn
      command = @command_prompt.value.strip.upcase

      if command.length.between?(2, 3)
        letter = command[0]
        number = command[1]
        number = command[1..2] if command.length == 3
        number = number.to_i - 1 # subtract one to get the array index

        if Array("A".."J").include?(letter) && number.between?(0, 9)
          x = number
          y = Array("A".."J").index(letter)

          @command_history.apend do
            tagline "<b>You:</b> #{@command_prompt.value}", color: Gosu::Color::GREEN
            @command_prompt.value = ""
            cell = @attack_board.get(x, y)
            cell.state = rand < 0.5 ? :hit : :miss
            SFX::CMD_RECEIVED.play(1, 1, false)
          end
        else
          SFX::ERROR.play
        end
      else
        SFX::ERROR.play
      end
    end
  end
end
