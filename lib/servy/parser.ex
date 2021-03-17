defmodule Servy.Parser do

  alias Servy.Conv
  alias JSON

  def parse(request) do
    [top, params_string] = String.split(request,"\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _version] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{ method: method, path: path, params: params, headers: headers }
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params("application/json", params_string) do
    JSON.decode(params_string)
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head|tail]) do
    [key, value] = String.split(head, ": ")
    parse_headers(tail, Map.put(%{}, key, value))
  end

  def parse_headers([head|tail], headers) do
    [key, value] = String.split(head, ": ")
    parse_headers(tail, Map.put(headers, key, value))
  end

  def parse_headers([], headers), do: headers
end
