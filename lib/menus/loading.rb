module Battleship
  module Menus
    class Loading < Menus::Menu
      def setup
        super

        @sfx = SFX::LOADING.play(1, 1, true)
        @angle = 0
        @timers = []

        @transition_time = 3_000

        @timers << CyberarmEngine::Timer.new(1_500, false) do
          @sfx&.stop
          @ready_sfx = SFX::READY.play(0.5)
          @transition_started = Gosu.milliseconds

          @timers << CyberarmEngine::Timer.new(@transition_time, false) do
            push_state(Game, @options[:game_options])
          end
        end

        @navigation.clear do
          button "Cancel", width: 1.0, margin_top: 10 do
            @sfx&.stop
            SFX::CLICK.play
            pop_state
          end
        end

        @content.clear do
          @status_label = banner "Loading"
        end
      end

      def draw
        super

        Gosu.flush

        @origin = CyberarmEngine::Vector.new(@content.x + @content.width / 2, @content.y + @content.height / 2)

        if @transition_started
          ratio = (Gosu.milliseconds - @transition_started).to_f / (@transition_time * 0.5)
          core_diff = (1.0 - @ratio_core) * ratio
          mid_diff = (1.0 - @ratio_mid) * ratio
          outer_diff = (1.0 - @ratio_outer) * ratio

          @ratio_core += core_diff
          @ratio_mid += mid_diff
          @ratio_outer += outer_diff

          @ratio_core = @ratio_core.clamp(0.0, 1.0)
          @ratio_mid = @ratio_mid.clamp(0.0, 1.0)
          @ratio_outer = @ratio_outer.clamp(0.0, 1.0)
        else
          @ratio_core  = Math.sin(Gosu.milliseconds * 0.0005)
          @ratio_mid   = Math.sin(Gosu.milliseconds * 0.001)
          @ratio_outer = Math.sin(Gosu.milliseconds * 0.002)
        end

        Gosu.rotate(@angle, @origin.x, @origin.y) do
          Gosu.draw_circle(@origin.x - 250, @origin.y - 20, 40, 40, @transition_started ? 0xaa_00ff00 : 0xaa_ffffff)
          Gosu.draw_circle(@origin.x + 250, @origin.y - 20, 40, 40, 0xaa_00ff00)

          Gosu.draw_arc(@origin.x, @origin.y, 80,  @ratio_core,  512, 10, @ratio_core == 1.0 ? 0xaa_00ff00 : 0xaa_ff8800)

          Gosu.draw_arc(@origin.x, @origin.y, 180, @ratio_outer, 512, 10, @ratio_outer == 1.0 ? 0xaa_00ff00 : 0xaa_ffffff)
        end

        Gosu.rotate(-@angle, @origin.x, @origin.y) do
          Gosu.draw_arc(@origin.x, @origin.y, 130, @ratio_mid,   512, 10, @ratio_mid == 1.0 ? 0xaa_00ff00 : 0xaa_ffff00)
        end
      end

      def update
        super

        @timers.each(&:update)

        @angle += Window.dt * 64
        @angle %= 360
      end
    end
  end
end