defmodule PicTest do
  use ExUnit.Case
  doctest Pic

  test "greets the world" do
    assert Pic.hello() == :world
  end
end
