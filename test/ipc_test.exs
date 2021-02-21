defmodule IPCTest do
  use ExUnit.Case
  doctest IPCServer

  test "runs successfully" do
    assert IPCServer.run
  end
end
