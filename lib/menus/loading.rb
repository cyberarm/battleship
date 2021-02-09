module Battleship
  module Menus
    class Loading < Menus::Menu
      def setup
        super

        @sfx = SFX::LOADING.play(1, 1, true)

        @timer = CyberarmEngine::Timer.new(100, false) do
        # @timer = CyberarmEngine::Timer.new(1_500, false) do
            @sfx&.stop
          push_state(Game, @options[:game_options])
        end

        @navigation.clear do
          button "Cancel", width: 1.0, margin_top: 10 do
            @sfx&.stop
            SFX::CLICK.play
            pop_state
          end
        end

        @content.clear do
          banner "Loading"
        end
      end

      def update
        super

        @timer.update
      end
    end
  end
end