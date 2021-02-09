module Battleship
  module Menus
    class MainMenu < Menus::Menu
      def setup
        super

        @navigation.clear do
          button "Play", width: 1.0, margin_top: 10 do
            SFX::CLICK.play
            push_state(Menus::Lobby)
          end

          button "Credits", width: 1.0, margin_top: 10 do
            SFX::CLICK.play
          end

          button "Exit", width: 1.0, margin_top: 10 do
            SFX::CLICK.play
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