defmodule TaskExerciseTest do
  use ExUnit.Case

  describe "simple_task" do
    test "returns :ok and pid" do
      exp = fn () -> 1 + 2 end
      assert {:ok, _pid} = TaskExercise.simple_task(exp)
    end
  end
end
