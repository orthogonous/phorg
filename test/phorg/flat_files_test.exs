defmodule Phorg.FlatFilesTest do
  use ExUnit.Case

  @test_photo_path  Path.expand("../data/",__DIR__)

  test "list_all returns files in a directory" do

    files = Phorg.FlatFiles.list_all(@test_photo_path)

    file = "#{@test_photo_path}/1051.png"

    assert is_list(files) == true
    assert length(files) >= 8 # not the best test but make sure we have at least 8 items in here.
    assert file in files == true
    
  end


end
