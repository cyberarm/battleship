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

        @player_board = Grid.new(parent: player_board)
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

    def update
      super

      cell = @player_board.mouse_over?(window.mouse_x, window.mouse_y)
      cell.state = :hover if cell
    end

    def button_down(id)
      super

      case id
      when Gosu::KB_ENTER, Gosu::KB_RETURN
        if @command_prompt && !@command_prompt.value.empty? && @command_prompt.enabled?
          @command_history.apend do
            tagline "<b>You:</b> #{@command_prompt.value}", color: Gosu::Color::GREEN
            @command_prompt.value = ""
            SFX::CMD_RECEIVED.play(1, 1, false)
          end
        end
      end
    end
  end
end
