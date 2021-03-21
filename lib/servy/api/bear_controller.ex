defmodule Servy.Api.BearController do
  def index(conv) do
    {:ok, json} =
      Servy.Wildthings.list_bears()
      |> Enum.map(fn bear -> Map.from_struct(bear) end)
      |> JSON.encode
      %{conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
