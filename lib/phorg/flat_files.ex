defmodule Phorg.FlatFiles do
  @moduledoc """
  functions I found somewhere online. Possibly stackoverflow
  on how to recursively traverse a directory tree and find files

  """

  def list_all(path) do
    _list_all(path)
  end
  
  def wanted_file(path) do
    # this should be a configurable parameter at some point
    # FIXME
    
    skip_files_extensions = [".mp4", ".mp3", ".mov", ".mpeg"]

    Enum.map(skip_files_extensions, &(Regex.compile!("#{&1}$"))) |> 
    Enum.filter(&Regex.match?(&1, String.downcase(path))) |>
    _wanted_action()

  end

  defp _wanted_action([]), do: true
  defp _wanted_action(_), do: false

  

  defp _list_all(path) do
    cond do
      wanted_file(path) -> expand(File.ls(path), path)
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
