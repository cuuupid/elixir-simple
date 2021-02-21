defmodule IPCServer do
  def run n \\ 2 do
    peers = 1..n |> Enum.map(fn _ -> spawn Peer, :init, [ self() ] end)
    peers = MapSet.new(peers)
    peers |> Enum.map(&(send &1, {:BIND, peers}))
    loop peers
  end

  def loop peers do
    receive do
      {:FIN, peer} ->
        IO.puts("#{inspect peer} terminated.")
        peers = peers |> MapSet.delete(peer)
        if peers |> MapSet.size > 0 do
          loop peers
        else
          IO.puts "All processes finished."
          True
        end
    end
  end
end
