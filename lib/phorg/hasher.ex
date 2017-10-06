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

  def hashcounter(file, hash) do
    case :ets.lookup(:hash_counters, hash) do
      [{_, counter}] ->
        add_hash_duplicate(file, hash)
        counter
      _ ->
        0
    end
  end

  def find_duplicate_hashes do
    :ets.select(:hash_counters, [{{:"$1", :"$2"}, [{:>, :"$2", 1}], [{{:"$1", :"$2"}}]}])
  end

  def add_hash_count(file, hash) do
      :ets.insert(:hash_counters, {hash, hashcounter(file, hash) + 1})
  end

  # Only adds the 2nd and onwards files found.
  # The original or first file is not considered a duplicate.
  def add_hash_duplicate(file, hash) do
    # get current list from ets
    case :ets.lookup(:hash_duplicates, hash) do
      [{_, files}] ->
        :ets.insert(:hash_duplicates, {hash, files ++ [file]})
        # non empty list means we have values in ets already
      []  -># there is no record yet
        :ets.insert(:hash_duplicates, {hash, [file]})
    end
  end


end
