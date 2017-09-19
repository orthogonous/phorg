defmodule Phorg.Hasher do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(state), do: {:ok, state}



  def handle_call(file, _from, state) do
    #{:reply, state, Map.put(state, file, md5hash(file))}
    hash = md5hash(file)
    IO.puts "#{file} hashed to #{hash}"
    {:reply, hash, state}
  end



  def hash(pid, file) do
    GenServer.call(pid, file)
  end

  defp md5hash(file) do
    {:ok, content} = File.read file
   :crypto.hash(:md5, content) |> Base.encode16
  end


end

