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
    
    skip_files_extensions = [".mp4", ".mp3", ".mov"]

    skip_files_extensions |>
    Enum.map(&(Regex.compile!("#{&1}$"))) |>
    #Enum.map(fn e -> %{reg: Regex.compile!("#{e}$"), ext: e} end) |> 
    Enum.filter(&(String.match?(path, &1))) |>
    Enum.reduce(&(&1)) |>
    case length(&1) do
      >0 -> false
      _ -> true
    end
      
    #Enum.filter(fn %{reg: r, ext: e} -> String.match?(path, r) end) |>
    # if path matches true to any regex filter based on true with Enum.filter
    # |> Enum.reduce down to a number and if that number is greater than 0 then return false 


  end

  

  defp _list_all(path) do
    cond do
      String.contains?(path, ".mp4") -> []
      true -> expand(File.ls(path), path)
      false -> []
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
