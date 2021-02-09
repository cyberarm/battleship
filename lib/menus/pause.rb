module Battleship
  module Menus
    class Pause < Menus::Menu
      def setup
        super

        @navigation.clear do
          button "Resume", width: 1.0, margin_top: 10 do
            SFX::CLICK.play
            pop_state
          end

          button "Abort", width: 1.0, margin_top: 10 do
            SFX::CLICK.play

            # TODO: inform CommandProxy of abort

            pop_state
            pop_state
            pop_state
          end
        end

        @content.clear do
          banner "Paused"
        end
      end
    end
  end
end