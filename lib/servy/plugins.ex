defmodule Servy.Plugins do

  alias Servy.Conv

  @moduledoc "Supportive plugins for an HTTP Server"
  def log(%Conv{} = conv), do: IO.inspect conv

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end
  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{method: "GET", path: "/wildlife"} = conv) do
    %Conv{ conv | path: "/wildthings" }
  end
  def rewrite_path(%Conv{} = conv), do: conv
end
