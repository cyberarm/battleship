module Battleship
  class Ship < CyberarmEngine::GameObject
    def draw(cell_size)
      Gosu.rotate(@angle, window.mouse_x, window.mouse_y) do
        Gosu.draw_rect(cell_size, cell_size, cell_size * 3, cell_size, Gosu::Color::WHITE)
      end
    end
  end
end