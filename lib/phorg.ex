defmodule Phorg do
  @moduledoc false

  #use Application
  use Task
  alias Phorg.FlatFiles
  alias Phorg.Hasher
  alias Phorg.ETS

  #@photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos"
  @photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos/prues xperia compact z3/DCIM/"

  def startup do
   ETS.create_tables() 

    stream = Task.async_stream(FlatFiles.list_all(@photo_path), Phorg.Hasher, :md5hash, [],
                               max_concurrency: System.schedulers_online * 2)
    stream |>
    Stream.map(fn(s) ->
      {:ok, {file, hash}} = s
      :ets.insert(:hash_values, {file, hash})
      Hasher.add_hash_count(file, hash)
    end) |>
    Stream.run

  end

  def cleanup do
    ETS.destroy_tables()
  end

end
