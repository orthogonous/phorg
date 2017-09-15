defmodule PhorgTest do
  use ExUnit.Case
  doctest Phorg

  test "greets the world" do
    assert Phorg.hello() == :world
  end
end
