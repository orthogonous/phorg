defmodule Phorg.FlatFiles do
  @moduledoc """
  functions I found somewhere online. Possibly stackoverflow
  on how to recursively traverse a directory tree and find files

  """

  def list_all(path) do
    _list_all(path)
  end

  @skip_exts MapSet.new([".mp4", ".mp3", ".mov", ".mpeg"])

  def wanted_file?(path) do
    Path.extname(path) not in @skip_exts
  end
  

  defp _list_all(path) do
    cond do
      wanted_file?(path) -> expand(File.ls(path), path)
      true -> []
    end
  end

  defp expand({:ok, files}, path) do
    files
    |> Enum.flat_map(&_list_all("#{path}/#{&1}"))
  end

  defp expand({:error, _}, path) do
    [path]
  end
end
