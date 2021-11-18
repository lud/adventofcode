defmodule Aoe.API do
  require Aoe.Utils

  def fetch_input(year, day) when Aoe.Utils.is_valid_day(year, day) do
    filename = cache_filename([:input, year, day])
    cpath = cache_path(filename)

    case get_cached(cpath) do
      {:ok, content} ->
        IO.puts("Retrieved input #{year}--#{day} from cache")
        {:ok, content}

      {:error, :enoent} ->
        case get_http(input_url(year, day)) do
          {:ok, content} ->
            write_cache(cpath, content)
            {:ok, content}

          {:error, _} = err ->
            err
        end
    end
  end

  defp input_url(year, day) do
    "https://adventofcode.com/#{year}/day/#{day}/input"
  end

  defp cache_filename(args) do
    args
    |> Enum.map(&to_string/1)
    |> Enum.join("-")
  end

  defp cache_path(filename) do
    Path.join(Aoe.Utils.conf_dir!(:cache_dir), filename)
  end

  defp get_cached(path) do
    File.read(path)
  end

  defp write_cache(path, content) do
    File.write!(path, content)
  end

  defp get_http(url) do
    IO.puts("Fetching #{url}")

    headers = [
      {"user-agent", "a gentle elixir client that will only download inputs once"}
    ]

    opts = [
      hackney: [cookie: ["session=#{Application.fetch_env!(:aoe, :session_cookie)}"]]
    ]

    case HTTPoison.get(url, headers, opts) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, {:http_status, status, body}}

      {:error, _} = err ->
        err
    end
  end
end
