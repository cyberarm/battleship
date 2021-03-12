module Battleship
  module SFX
    CLICK = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/tick_002.ogg")
    ERROR = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/forceField_000.ogg")

    LOADING = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/computerNoise_003.ogg")
    CMD_RECEIVED = CLICK# = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/impactMetal_003.ogg")
    HIT = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/explosionCrunch_000.ogg")
    KILL = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/explosionCrunch_001.ogg")
  end
end