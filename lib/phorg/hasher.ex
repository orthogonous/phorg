defmodule Phorg.Hasher do
  @moduledoc """
  Provides hash functions to Phorg.

  ## Examples

      iex> Phorg.m5dhash("filename.here")
      3

  """

  def md5hash(file) do
    {:ok, content} = File.read file
    hash = :crypto.hash(:md5, content)
    {file, Base.encode16(hash)}
  end

end
