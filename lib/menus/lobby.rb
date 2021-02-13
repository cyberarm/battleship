module Battleship
  module Menus
    class Lobby < Menus::Menu
      def setup
        super

        @navigation.clear do
          button "Start", width: 1.0, margin_top: 10 do
            SFX::CLICK.play
            push_state(Menus::Loading, game_options: game_options)
          end

          button "Back", width: 1.0, margin_top: 10 do
            SFX::CLICK.play
            pop_state
          end
        end

        @content.clear do
          banner "Lobby"

          stack(width: 1.0, height: 1.0) do
            stack(width: 1.0, height: 0.4) do
              flow do
                title "Name"
                @player_name = edit_line "Admiral"
              end

              para ""
              check_box "Play Over Network?" do
              end.subscribe(:changed) do |sender, value|
                if value
                  @network_options.show
                else
                  @network_options.hide
                end
              end

              @network_options = stack(width: 1.0, visible: false) do
                tagline "Direct Connect <c=990000>[Not Implemented]</c>"

                flow do
                  title "Hostname: "
                  @hostname = edit_line "192.168.1.255"

                  title " Port: "
                  @port = edit_line "56789"
                end

                flow do
                  @hosting = check_box "Host Game?"
                end
              end
            end

            flow(width: 1.0, height: 0.6) do
              @setup_grid_container = stack(width: 0.5, height: 0.8) do
                # background Gosu::Color::BLUE
              end

              stack(width: 0.5, height: 1.0) do
                button "Aircraft Carrier", width: 1.0, margin_top: 10 do
                  SFX::CLICK.play
                  select_ship(:aircraft_carrier)
                end

                button "Battleship", width: 1.0, margin_top: 10 do
                  SFX::CLICK.play
                  select_ship(:battleship)
                end

                button "Cruiser", width: 1.0, margin_top: 10 do
                  SFX::CLICK.play
                  select_ship(:cruiser)
                end

                button "Submarine", width: 1.0, margin_top: 10 do
                  SFX::CLICK.play
                  select_ship(:submarine)
                end

                button "Patrol Boat", width: 1.0, margin_top: 10 do
                  SFX::CLICK.play
                  select_ship(:patrol_boat)
                end

                button "Rotate", width: 1.0, margin_top: 40 do
                  SFX::CLICK.play

                  @ship&.angle += 90
                  @ship&.angle %= 360
                end
              end
            end
          end

          @setup_grid = Grid.new(parent: @setup_grid_container)
          @game_objects << @setup_grid
        end
      end

      def draw
        super

        Gosu.flush
        @ship&.position = CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y)
        @ship&.draw(@setup_grid.cell_size)
      end

      def game_options
        {
          command_proxy: CommandProxy.new(
            players: [
              Player.new(local: true, human: true),
              Player.new(local: true, human: false)
            ],
            connection_type: :virtual,
            hostname: @hostname.value,
            port: Integer(@port.value),
            hosting: @hosting.value
          )
        }
      end

      def select_ship(ship)
        @ship = case ship
        when :aircraft_carrier
          AircraftCarrier.new
        when :battleship
          BattleShip.new
        when :cruiser
          Cruiser.new
        when :submarine
          Submarine.new
        when :patrol_boat
          PatrolBoat.new
        else
          puts "Unknown ship: #{ship}"
        end
      end
    end
  end
end