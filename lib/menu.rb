module Battleship
  module Menus
    class Menu < CyberarmEngine::GuiState
      def setup
        theme(THEME)
        background 0xff_203020

        flow(width: 1.0, height: 1.0) do
          stack(padding: 20, height: 1.0, width: 0.30) do
            background 0xff_102010
            banner NAME

            @navigation = stack(width: 1.0, height: 1.0) do
            end
          end

          stack(padding: 20, width: 0.29995, height: 1.0) do
            @content = stack(width: 1.0, height: 0.95) do
            end

            @footer = stack(width: 1.0, height: 0.05) do
            end
          end
        end
      end
    end
  end
end
