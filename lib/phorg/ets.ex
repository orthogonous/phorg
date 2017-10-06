defmodule Phorg.ETS do
  def table_list do
    # List of ets tables required for this application to work
    [:hash_values, :hash_counters, :hash_duplicates]
  end

  def create_tables do
    :ets.new(:hash_values, [:set, :protected, :named_table])
    :ets.new(:hash_counters, [:set, :protected, :named_table])
    :ets.new(:hash_duplicates, [:set, :protected, :named_table])
    :ok
  end

  def destroy_tables do
    :ets.delete(:hash_values)
    :ets.delete(:hash_counters)
    :ets.delete(:hash_duplicates)
    :ok
  end


end
