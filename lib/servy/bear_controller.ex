defmodule Servy.BearController do

  alias Servy.Wildthings

  @templates_path Path.expand("../../templates", __DIR__)

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(fn(bear1, bear2) -> bear1.name <= bear2.name end)

      render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id})do
    bear = Wildthings.get_bear(id)
    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201,
             resp_body: "Created a #{type} bear named #{name}!"}
  end

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content }
  end
end
