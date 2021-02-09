begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

require_relative "lib/version"
require_relative "lib/window"
require_relative "lib/menu"
require_relative "lib/menus/main_menu"
require_relative "lib/menus/lobby"
require_relative "lib/menus/loading"
require_relative "lib/menus/pause"
require_relative "lib/game"
require_relative "lib/grid"
require_relative "lib/sound_effects"
require_relative "lib/ship"
require_relative "lib/command_proxy"
require_relative "lib/player"

Battleship::Window.new(width: 1280, height: 720).show