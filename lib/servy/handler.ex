defmodule Servy.Handler do

  @moduledoc "Handles HTTP Requests"

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  alias Servy.Conv
  alias Servy.BearController

  @pages_path Path.expand("../../pages", __DIR__)
  @doc "Transforms a request into a response"
  def handle(request) do
    request
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> track
    |> format_response
  end
  def route(%Conv{method: "GET", path: "/pages/" <> file_name} = conv) do
      @pages_path
      |> Path.join("#{file_name}.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %Conv{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{} = conv) do
    %Conv{ conv | status: 404, resp_body: "No #{conv.path} here!" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp find_bear(id) do
    %{
      "1" => "Teddy",
      "2" => "Smokey",
      "3" => "Paddington"
    }[id] || "Bear #{id}"
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/99 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response
