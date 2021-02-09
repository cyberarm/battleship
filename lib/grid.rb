module Battleship
  class Grid < CyberarmEngine::GameObject
    FONT = Gosu::Font.new(20, name: Battleship::FONT)
    class Cell
      def initialize(state: :none)
        @state = state

        @color = 0xff_206020
        @border_color = 0xff_104010
        @border_size = 2
        @base_color = @color
      end

      def draw(x, y, size)
        Gosu.draw_rect(x * size, y * size, size, size, @border_color, 10_000)
        Gosu.draw_rect((x * size - @border_size * 2) + @border_size, (y * size - @border_size * 2) + @border_size, size - @border_size, size - @border_size, @color, 10_000)
      end

      def state=(sym)
        case sym
        when :none
          @color = @base_color
        when :hover
          @color = Gosu::Color::BLACK
        else
          raise
        end
      end
    end

    def setup
      @parent = @options[:parent]

      @grid = Array.new(10) { Array.new(10) { Cell.new }}
    end

    def get(x, y)
      @grid.dig(y, x)
    end

    def mouse_over?(x, y)
      return false unless @updated

      x = (x - @parent.x) / @cell_size - 1
      y = (y - @parent.y) / @cell_size - 1

      return if x.negative?
      x = 10 if x > 10
      return if y.negative?
      y = 10 if y > 10

      get(x, y)
    end

    def draw
      return unless @updated
      size = 11 * @cell_size
      x = @parent.x
      y = @parent.y

      x = @parent.width / 2 + @parent.x - size / 2 if @parent.width > size
      y = @parent.height / 2 + @parent.y - size / 2 if @parent.height > size

      Gosu.translate(x, y) do
        Array("A".."J").each_with_index do |letter, i|
          FONT.draw_text(letter, @cell_size / 2 - FONT.text_width(letter) / 2, (@cell_size * i) + @cell_size + (@cell_size / 2 - FONT.height / 2), 10_000)
        end

        Array(1..10).each_with_index do |number, i|
          FONT.draw_text("#{number}", (@cell_size * i) + @cell_size + (@cell_size / 2 - FONT.text_width("#{number}") / 2), @cell_size / 2 - FONT.height / 2, 10_000)
        end
      end

      Gosu.translate(x + @cell_size, y + @cell_size) do
        10.times do |y|
          10.times do |x|
            get(x, y).draw(x, y, @cell_size)
          end
        end
      end
    end

    def update
      @max_size = [@parent.width, @parent.height].min
      @cell_size = @max_size / 11.0

      @updated = true

      @grid.flatten.each do |cell|
        cell.state = :none
      end
    end
  end
end