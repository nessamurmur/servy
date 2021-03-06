defmodule Servy.Parser do

  alias Servy.Conv
  alias JSON

  def parse(request) do
    IO.puts request
    [top, params_string] = String.split(request,"\r\n\r\n")

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _version] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{ method: method, path: path, params: params, headers: headers }
  end


  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Examples
    iex> params_string = "name=Baloo&type=Brown"
    iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
    %{"name" => "Baloo", "type" => "Brown"}
    iex> Servy.Parser.parse_params("multipart/form-data", params_string)
    %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params("application/json", params_string) do
    {:ok, json} = JSON.decode(params_string)
    json
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
