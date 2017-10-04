defmodule Phorg.FlatFilesTest do
  use ExUnit.Case

  alias Phorg.FlatFiles

  @test_photo_path  Path.expand("../data/",__DIR__)

  test "list_all returns files in a directory" do

    files = FlatFiles.list_all(@test_photo_path)

    assert is_list(files) == true
    assert length(files) >= 8 # not the best test but make sure we have at least 8 items in here.
    assert "#{@test_photo_path}/1051.png" in files == true
    assert "#{@test_photo_path}/1052.png" in files == true
    assert "#{@test_photo_path}/1053.png" in files == true
  end

  test "list_all returns files in a directory but skipping unwanted files" do

    files = FlatFiles.list_all(@test_photo_path)

    refute "#{@test_photo_path}/bad.mov" in files == true
    refute "#{@test_photo_path}/bad.mp4" in files == true
    refute "#{@test_photo_path}/bad.mp3" in files == true
    refute "#{@test_photo_path}/bad.mpeg" in files == true
  end

  test "wanted_file should return true for files we want" do
    assert FlatFiles.wanted_file("/some/dir/file.jpg") == true
    assert FlatFiles.wanted_file("/some/dir/file.JpG") == true
    assert FlatFiles.wanted_file("/some/dir/file.JPG") == true
    assert FlatFiles.wanted_file("/some/dir/file.jpeg") == true
  end

  test "wanted_file should return false for files we dont want" do
    assert FlatFiles.wanted_file("/some/dir/file.mp3") == false
    assert FlatFiles.wanted_file("/some/dir/file.mov") == false
    assert FlatFiles.wanted_file("/some/dir/file.mp4") == false
    assert FlatFiles.wanted_file("/some/dir/file.mpeg") == false
  end

end
