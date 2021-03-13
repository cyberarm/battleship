module Battleship
  class Player
    attr_reader :name, :data

    def initialize(name:)
      @name = name
      @data = {}
    end
  end
end