defmodule PidgeotCoreTest do
  use ExUnit.Case
  doctest PidgeotCore

  test "greets the world" do
    assert PidgeotCore.hello() == :world
  end
end
