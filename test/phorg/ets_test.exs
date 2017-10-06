defmodule Phorg.ETSTest do
  use ExUnit.Case
  alias Phorg.ETS

  test "create_tables creates expected ets tables" do
    # we expect to get :ok atom back
    # need this to pass for following refute statements to pass
    assert ETS.create_tables == :ok
    
    Enum.each(ETS.table_list, fn(t) -> 
      refute :ets.info(t) == :undefined
    end)
  end

  test "delete_tables creates expected ets tables" do
    # we expect to get :ok atom back
    # need this to pass for following asserts to pass
    assert ETS.create_tables == :ok
    assert ETS.destroy_tables == :ok
    
    Enum.each(ETS.table_list, fn(t) -> 
      assert :ets.info(t) == :undefined
    end)
  end
end
