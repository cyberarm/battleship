module Battleship
  module SFX
    LOADING = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/computerNoise_003.ogg")
    CMD_RECEIVED = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/impactMetal_003.ogg")
    HIT = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/explosionCrunch_000.ogg")
    KILL = Gosu::Sample.new("#{GAME_ROOT_PATH}/assets/sfx/explosionCrunch_001.ogg")
  end
end