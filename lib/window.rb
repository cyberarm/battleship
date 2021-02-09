module Battleship
  if ARGV.join.include?("--retro")
    FONT = "#{GAME_ROOT_PATH}/assets/fonts/kenney_rocket_square.ttf"
  else
    FONT = "#{GAME_ROOT_PATH}/assets/fonts/kenney_future.ttf"
  end

  THEME = {
    TextBlock: {
      font: FONT
    },
    Button: {
      border_thickness: 2,
      border_color: Gosu::Color::BLACK,
      background: Gosu::Color::GRAY..Gosu::Color::BLACK,
      hover: {
        background: 4_284_966_759..4_279_834_905,
        color: Gosu::Color::GREEN
      },
      active: {
        background: Gosu::Color::BLACK..Gosu::Color::GRAY,
        color: Gosu::Color::WHITE
      }
    },
    EditLine: {
      color: Gosu::Color::GREEN,
      border_thickness: 2,
      border_color: Gosu::Color::GREEN,
      caret_color: Gosu::Color::GREEN,
      background: Gosu::Color::BLACK,
      caret_width: 16,
      hover: {
        color: Gosu::Color::GREEN,
        background: Gosu::Color::BLACK,
      },
      active: {
        color: Gosu::Color::GREEN,
        background: Gosu::Color::BLACK,
      }
    }
  }

  class Window < CyberarmEngine::Window
    def setup
      self.caption = Battleship::NAME

      push_state(Menus::MainMenu)
    end

    def needs_cursor?
      true
    end
  end
end