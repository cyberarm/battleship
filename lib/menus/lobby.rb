module Battleship
  module Menus
    class Lobby < Menus::Menu
      def setup
        super

        @navigation.clear do
          button "Start", width: 1.0, margin_top: 10 do
            if valid_grid_setup?
              SFX::CLICK.play
              push_state(Menus::Loading, game_options: game_options)
            else
              SFX::ERROR.play
            end
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
              @network_game = check_box "Play Over Network?"

              @network_game.subscribe(:changed) do |sender, value|
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

        @setup_grid.cells.each do |cell|
          if cell.data.is_a?(Ship)
            ship = cell.data
            ship.draw_in_grid(@setup_grid)
          end
        end

        @ship&.position = CyberarmEngine::Vector.new(window.mouse_x - @ship.width / 2, window.mouse_y - @ship.height / 2)
        @ship&.draw_detached(@setup_grid.cell_size)
      end

      def game_options
        {
          command_proxy: CommandProxy.new(
            players: [
              Player.new(name: @player_name.value)
            ],
            connection_type: @network_game.value ? :socket : :virtual,
            hostname: @hostname.value,
            port: Integer(@port.value),
            hosting: @hosting.value
          ),
          player_board: @setup_grid
        }
      end

      def update
        super

        @setup_grid.cells.each { |c| c.state = :none }

        ship_grid_cells do |cells|
          # Check number of cells and for existing ships
          if cells.size != @ship.length || cells.find { |c| c.data != nil }
            cells.each { |c| c.state = :error }
          else
            cells.each { |c| c.state = :hover }
          end
        end
      end

      def select_ship(ship)
        @ship = case ship
        when :aircraft_carrier
          @aircraft_carrier ||= AircraftCarrier.new(color: 0xaa_00ff00)
        when :battleship
          @battleship ||= BattleShip.new(color: 0xaa_00ff00)
        when :cruiser
          @cruiser ||= Cruiser.new(color: 0xaa_00ff00)
        when :submarine
          @submarine ||= Submarine.new(color: 0xaa_00ff00)
        when :patrol_boat
          @patrol_boat ||= PatrolBoat.new(color: 0xaa_00ff00)
        else
          puts "Unknown ship: #{ship}"
        end
      end

      def place_ship
        return unless @ship
        return unless @setup_grid.mouse_over?(window.mouse_x, window.mouse_y)

        placed_ship_cells = @setup_grid.all { |c| c.data.instance_of?(@ship.class) }

        if placed_ship_cells.size.positive?
          # remove ship from grid
          placed_ship_cells.each { |c| c.data = nil }
        end

        ship_grid_cells do |cells|
          # Check number of cells and for existing ships
          if cells.size != @ship.length || cells.find { |c| c.data != nil }
            cells.each { |c| c.state = :error }
          else # place ship
            ship = @ship.dup
            cell = cells.first

            10.times do |y|
              10.times do |x|
                if cell == @setup_grid.get(x, y)
                  ship.grid_position = CyberarmEngine::Vector.new(x, y)

                  break
                end
              end

              break if ship.grid_position
            end

            cells.each do |c|
              c.data = ship
            end

            @ship = nil
          end
        end
      end

      def mouse_to_grid
        CyberarmEngine::Vector.new(
          ((window.mouse_x - (@setup_grid.x + @setup_grid.cell_size)) / @setup_grid.cell_size).floor,
          ((window.mouse_y - (@setup_grid.y + @setup_grid.cell_size)) / @setup_grid.cell_size).floor
        )
      end

      def ship_grid_cells(&block)
        v = mouse_to_grid

        if @ship && @setup_grid.get(v.x, v.y)
          mid = @ship.length * 0.5
          cells = []

          case @ship.angle
          when 0, 180 # Right, Left
            @ship.length.times do |i|
              c = @setup_grid.get((v.x - mid + i).ceil, v.y)
              cells << c if c
            end

          when 90, 270 # Down, Up
            @ship.length.times do |i|
              c = @setup_grid.get(v.x, (v.y - mid + i).ceil)
              cells << c if c
            end
          end

          block.call(cells)
        end
      end

      def valid_grid_setup?
        list = [Battleship::AircraftCarrier, Battleship::BattleShip, Battleship::Cruiser, Battleship::Submarine, Battleship::PatrolBoat]
        data = @setup_grid.cells.each.select(&:data).map { |c| c.data.class }

        (list & data) == list
      end

      def button_down(id)
        super

        case id
        when Gosu::MS_LEFT
          place_ship
        when Gosu::MS_RIGHT
          if @ship
            @ship = nil
          else
            # TODO: Delete ship
          end
        end
      end
    end
  end
end