defmodule Peer do

  def init server do
    IO.puts "#{inspect self()} spawned."
    receive do
      {:BIND, peers} ->
        peers |> Enum.map(&(send &1, {:PING, self()}))
        loop { server, peers |> MapSet.delete(self())}
    end
  end

  def loop { server, peers } do
    receive do
      {msg, peer} ->
        if peer == self() do
          loop { server, peers }
        else
          case msg do
            :PING ->
              IO.puts "PING #{inspect peer} -> #{inspect self()}"
              send peer, {:PONG, self()}
              loop { server, peers }
            :PONG ->
              IO.puts "PONG #{inspect peer} -> #{inspect self()}"
              peers = peers |> MapSet.delete(peer)
              if peers |> MapSet.size > 0 do
                loop { server, peers }
              else
                send server, {:FIN, self()}
              end
          end
        end
    end
  end
end
