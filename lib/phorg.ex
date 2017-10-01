defmodule Phorg do
  @moduledoc false


  use Application

  @photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos"
  #@photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos/prues xperia compact z3/DCIM/"
  defp pool_name() do
    :phorg_pool
  end

  defp poolboy_config do
    [
      {:name, {:local, pool_name()}},
     {:worker_module, Phorg.Hasher},
     {:size, 2},
     {:max_overflow, 2}
   ]
  end

  #https://theerlangelist.blogspot.com.au/2013/04/parallelizing-independent-tasks.html

  def start(_type, _args) do
    # Start poolboy
    children = [
      :poolboy.child_spec(pool_name(), poolboy_config(), [])
    ]
    opts = [strategy: :one_for_one, name: Phorg.Supervisor]

    Supervisor.start_link(children, opts)


    # Setup ETS
    
    hash_table = :ets.new(:hash_table, [])


    # Traverse directory at @photo_path and produce a list of files
    files = Phorg.FlatFiles.list_all(@photo_path)
	
    # this sucks really bad. learn more about this
    Enum.each(files, fn file -> 
      spawn(fn() -> 
        hash = pooled_hash(pool_name(), file)
        :ets.insert(hash_table, [{:file, file}, {:hash, hash}])

      
      end)
    end)


  :timer.sleep(10_000)

  # Dodgy hack to make app run like a script with 'mix run'
  Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end

  def pooled_hash(pool, file) do
      :poolboy.transaction(pool, fn(pid) -> Phorg.Hasher.hash(pid, file) end)
  end

end
#      :poolboy.transaction(
#        pool_name(),
#        fn(pid) -> Phorg.Hasher.hash(pid, file) end)
