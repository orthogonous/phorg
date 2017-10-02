defmodule Phorg.Hasher do

  def md5hash(file) do
    {:ok, content} = File.read file
   hash = :crypto.hash(:md5, content) |> Base.encode16
   {file, hash}

  end


end

