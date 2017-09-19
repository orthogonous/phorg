defmodule Phorg do
  @moduledoc """
  Documentation for Phorg.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Phorg.hello
      :world

  """

  use Application

  @photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos"
  #@photo_path "/data/seagate-1.8/FamilyBackup/Lachlan/Photos/prues xperia compact z3/DCIM/"

  def hello do
    :world
  end
  def start(_type, _args) do

    # Traverse directory at @photo_path and produce a list of files
    files = FlatFiles.list_all(@photo_path)

    # iterate over each element and find the date_modifed 
#    {:ok,
#     %{:exif => %{:aperture_value => 5.0, :color_space => "sRGB",
#	 :component_configuration => "Y,Cb,Cr,-", :custom_rendered => "Normal",
#	 :datetime_digitized => "2012:10:13 15:43:12",
#	 :datetime_original => "2012:10:13 15:43:12", :exif_image_height => 3168,
#	 :exif_image_width => 4752, :exif_version => "2.21",
#	 :exposure_bias_value => 0, :exposure_mode => "Auto",
#	 :exposure_program => "Unknown", :exposure_time => "1/250",
#	 :f_number => 5.6, :flash => "Off, Did not fire",
#	 :flash_pix_version => "1.00", :focal_length => 50,
#	 :focal_plane_resolution_unit => "inches",
#	 :focal_plane_x_resolution => 5315.436,
#	 :focal_plane_y_resolution => 5306.533, :iso_speed_ratings => 100,
#	 :maker_note => nil, :metering_mode => "Multi-segment",
#	 :scene_capture_type => "Standard", :shutter_speed_value => 8.0,
#	 :subsec_time => "08", :subsec_time_digitized => "08",
#	 :subsec_time_orginal => "08", :user_comment => nil,
#	 :white_balance => "Auto", "exif tag(0xA005)" => "8602"},
#       :gps => %Exexif.Data.Gps{gps_altitude: nil, gps_altitude_ref: nil,
#	gps_area_information: nil, gps_date_stamp: nil, gps_dest_bearing: nil,
#	gps_dest_bearing_ref: nil, gps_dest_distance: nil,
#	gps_dest_distance_ref: nil, gps_dest_latitude: nil,
#	gps_dest_latitude_ref: nil, gps_dest_longitude: nil,
#	gps_dest_longitude_ref: nil, gps_differential: nil, gps_dop: nil,
#	gps_h_positioning_errorl: nil, gps_img_direction: nil,
#	gps_img_direction_ref: nil, gps_latitude: nil, gps_latitude_ref: nil,
#	gps_longitude: nil, gps_longitude_ref: nil, gps_map_datum: nil,
#	gps_measure_mode: nil, gps_processing_method: nil, gps_satellites: nil,
#	gps_speed: nil, gps_speed_ref: nil, gps_status: nil, gps_time_stamp: nil,
#	gps_track: nil, gps_track_ref: nil, gps_version_id: nil}, :make => "Canon",
#       :model => "Canon EOS 50D", :modify_date => "\"2012:10:13 15:43:12\"",
#       :orientation => "Rotate 90 CW", :resolution_units => "Pixels/in",
#       :x_resolution => 72, :y_resolution => 72, "tiff tag(0x13B)" => "\"\"",
#       "tiff tag(0x213)" => "2", "tiff tag(0x8298)" => "\"\""}}
	
        Hasher.start_link(%{})
	Enum.each files, fn file -> 
         Hasher.hash(file) 
	end

        :timer.sleep(3_000)

    # Dodgy hack to make app run like a script with 'mix run'
    Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end

end

defmodule Hasher do
  use GenServer

  def init(state), do: {:ok, state}


  defp md5hash(file) do
    {:ok, content} = File.read file
   :crypto.hash(:md5, content) |> Base.encode16 
  end

  def handle_call({:hash, file}, _from, state) do
    {:reply, state, Map.put(state, file, md5hash(file))}
  end


  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  #def hash(file), do: GenServer.cast(__MODULE__, {:hash, file})
  def hash(file), do: GenServer.call(__MODULE__, {:hash, file})


end

defmodule FlatFiles do
  def list_all(path) do
    _list_all(path)
  end

  defp _list_all(path) do
    cond do
      String.contains?(path, ".mp4") -> []
      true -> expand(File.ls(path), path)
    end
  end

  defp expand({:ok, files}, path) do 
    files
    |> Enum.flat_map(&_list_all("#{path}/#{&1}"))
  end

  defp expand({:error, _}, path) do
    [path]
  end
end
