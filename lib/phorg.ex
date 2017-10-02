defmodule Phorg do
  @moduledoc false


  #use Application
  use Task

  #@photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos"
  @photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos/prues xperia compact z3/DCIM/"

  def startup() do
    :ets.new(:hash_values, [:set, :protected, :named_table])
    :ets.new(:hash_counters, [:set, :protected, :named_table])
    :ets.new(:hash_duplicates, [:set, :protected, :named_table])


    stream = Task.async_stream(findfiles(), Phorg.Hasher, :md5hash, [], max_concurrency: System.schedulers_online * 2)
    Stream.each(stream, fn(s) ->
      {:ok, {file, hash}} = s
      :ets.insert(:hash_values, {file, hash})
      add_hash_count(file,hash)
    end) |>
    Stream.run

  end

  def cleanup() do
    :ets.delete(:hash_values)
    :ets.delete(:hash_counters)
    :ets.delete(:hash_duplicates)
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

  def findfiles() do
    Phorg.FlatFiles.list_all(@photo_path)
  end

  def find_duplicate_hashes() do
    :ets.select(:hash_counters, [{{:"$1", :"$2"}, [{:>, :"$2", 1}], [{{:"$1", :"$2"}}]}])    
  end

  def add_hash_count(file, hash) do
      :ets.insert(:hash_counters, {hash, hashcounter(file, hash) + 1})
  end

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
