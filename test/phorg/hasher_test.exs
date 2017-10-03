defmodule Phorg.HasherTest do
  use ExUnit.Case

  @test_photo_path  Path.expand("../data/",__DIR__)

  test "hash file returns correct hash" do
    photo = "#{@test_photo_path}/1051.png"

    {file,hash} = Phorg.Hasher.md5hash(photo)

    assert file == photo
    assert hash == "286DD930837163ABB3E172F7FFBAC207"
    
  end


end
