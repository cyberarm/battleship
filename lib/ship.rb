module Battleship
  class Ship
    include CyberarmEngine::Common

    attr_accessor :angle, :position

    def initialize(options = {})
      puts self.class

      @options = options

      @angle = options[:angle]
      @angle ||= 0

      @position = options[:position]
      @position ||= CyberarmEngine::Vector.new

      @color = options[:color]
      @color ||= Gosu::Color::GREEN

      @scale = 1.0
    end

    def width
      image.width * @scale
    end

    def height
      image.height * @scale
    end

    def draw(cell_size)
      Gosu.rotate(@angle, window.mouse_x, window.mouse_y) do
        @scale = cell_size / 16.0
        image.draw(@position.x, @position.y, 2, @scale, @scale, @color)
      end
    end
  end

  class AircraftCarrier < Ship
    def length
      5
    end

    def image
      get_image("#{GAME_ROOT_PATH}/assets/sprites/aircraft_carrier.png", retro: true)
    end
  end

  class BattleShip < Ship
    def length
      4
    end

    def image
      get_image("#{GAME_ROOT_PATH}/assets/sprites/battleship.png", retro: true)
    end
  end

  class Cruiser < Ship
    def length
      3
    end

    def image
      get_image("#{GAME_ROOT_PATH}/assets/sprites/cruiser.png", retro: true)
    end
  end

  class Submarine < Ship
    def length
      3
    end

    def image
      get_image("#{GAME_ROOT_PATH}/assets/sprites/submarine.png", retro: true)
    end
  end

  class PatrolBoat < Ship
    def length
      2
    end

    def image
      get_image("#{GAME_ROOT_PATH}/assets/sprites/patrol_boat.png", retro: true)
    end
  end
end
