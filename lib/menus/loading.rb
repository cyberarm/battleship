module Battleship
  module Menus
    class Loading < Menus::Menu
      def setup
        super

        @sfx = SFX::LOADING.play(1, 1, true)
        @angle = 0

        @timer = CyberarmEngine::Timer.new(10000, false) do
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

      def draw
        super

        Gosu.flush

        @origin = CyberarmEngine::Vector.new(@content.x + @content.width / 2, @content.y + @content.height / 2)

        Gosu.rotate(@angle, @origin.x, @origin.y) do
          Gosu.draw_circle(@origin.x - 250, @origin.y - 20, 40, 40, 0xaa_ffffff)
          Gosu.draw_circle(@origin.x + 250, @origin.y - 20, 40, 40, 0xaa_00ff00)

          ratio_core  = Math.sin(Gosu.milliseconds * 0.0005)
          ratio_mid   = Math.sin(Gosu.milliseconds * 0.001)
          ratio_outer = Math.sin(Gosu.milliseconds * 0.002)

          Gosu.draw_arc(@origin.x, @origin.y, 80,  ratio_core,  512, 10, 0xaa_ff8800)
          Gosu.draw_arc(@origin.x, @origin.y, 130, ratio_mid,   512, 10, 0xaa_ffff00)
          Gosu.draw_arc(@origin.x, @origin.y, 180, ratio_outer, 512, 10, 0xaa_ffffff)
        end
      end

      def update
        super

        @timer.update

        @angle += Window.dt * 64
        @angle %= 360
      end
    end
  end
end