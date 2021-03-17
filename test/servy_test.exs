defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "greets the world" do
    assert Servy.hello("Nessa Jane") == "Hello, Nessa Jane!"
  end
end
