defmodule LodeTimeTest do
  use ExUnit.Case
  
  describe "lodetime_root/1" do
    test "finds .lodetime directory" do
      # This test assumes we're running from project root
      root = LodeTime.lodetime_root()
      assert root != nil
      assert String.ends_with?(root, ".lodetime")
    end
  end
  
  describe "version/0" do
    test "returns version string" do
      version = LodeTime.version()
      assert is_binary(version)
    end
  end
end
