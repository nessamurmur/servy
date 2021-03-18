defmodule Servy.Wildthings do
  alias Servy.Bear

  @spec list_bears :: [%Bear{}, ...]
  def list_bears do
    [%Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
    %Bear{id: 2, name: "Smokey", type: "Blake"},
    %Bear{id: 3, name: "Paddington", type: "Brown"}]
  end

  @spec get_bear(binary | integer) :: %Bear{}
  def get_bear(id) when is_integer(id) do
    list_bears()
    |> Enum.find(fn(b) -> b.id == id end) || %Bear{}
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
