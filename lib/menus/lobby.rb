module Battleship
  module Menus
    class Lobby < Menus::Menu
      def setup
        super

        @navigation.clear do
          button "Start", width: 1.0, margin_top: 10 do
            push_state(Menus::Loading, game_options: game_options)
          end

          button "Back", width: 1.0, margin_top: 10 do
            pop_state
          end
        end

        @content.clear do
          banner "Lobby"
          tagline "[TODO: Add game setup]"
        end
      end

      def game_options
        {}
      end
    end
  end
end