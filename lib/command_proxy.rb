module Battleship
  class CommandProxy
    def initialize(players:, connection_type:, hostname:, port:, hosting:)
      @players = players
      @connection_type = connection_type
      @hostname = hostname
      @port = port
      @hosting = hosting

      @connected = false

      connect_to_peer!
    end

    def connect_to_peer!
      @connected = true
    end

    def connected?
      @connected
    end

    def attach_game(game_instance)
      @game = game_instance
    end

    def send(player_id, command)
    end

    def receive(player_id, command)
    end
  end
end