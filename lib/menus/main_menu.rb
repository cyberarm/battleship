module Battleship
  module Menus
    class MainMenu < Menus::Menu
      def setup
        super

        @navigation.clear do
          button "Play", width: 1.0, margin_top: 10 do
            push_state(Menus::Lobby)
          end

          button "Credits", width: 1.0, margin_top: 10

          button "Exit", width: 1.0, margin_top: 10 do
            window.close
          end
        end

        @content.clear do
          title "How to play"
          tagline "[TODO: Insert diagram]"
        end

        @footer.clear do
          tagline "#{NAME} v#{VERSION}"
        end
      end
    end
  end
end