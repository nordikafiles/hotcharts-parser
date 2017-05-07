defmodule HotchartsParser do
  @moduledoc """
  Documentation for HotchartsParser.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HotchartsParser.hello
      :world

  """
  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "No arguments given"
  end

  def process(options) do
    IO.puts parse_page options[:url]
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [url: :string]
    )
    options
  end

  def hello do
    parse_page "http://hotcharts.ru/mp3/?page=top"
  end

  def parse_page(url) do
    response = HTTPotion.get url

    songs = Floki.find response.body, ".song_box"
    pretty = for song <- songs do 
      a = Floki.find song, ".buttons .play a"
      {status, url} = Floki.attribute(a, "data-url-encoded") |> Enum.at(0) |> Base.decode64
      %{title: Floki.attribute(a, "data-song-name") |> Enum.at(0),
        artist: Floki.attribute(a, "data-artist-name") |> Enum.at(0),
        url: url,
        hotcharts_song_id: Floki.attribute(a, "data-song-id") |> Enum.at(0)
      }
    end
    {res, encoded_json} = Poison.encode pretty
    encoded_json
    # mp3_files = Enum.map songs, fn (song) ->

    # end
  end
end
