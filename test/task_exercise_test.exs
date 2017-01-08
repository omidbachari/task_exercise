defmodule TaskExerciseTest do
  use ExUnit.Case

  describe "simple_task" do
    test "returns :ok and pid" do
      exp = fn () -> 1 + 2 end
      assert {:ok, _pid} = TaskExercise.simple_task(exp)
    end
  end

  describe "awaited_task" do
    test "returns awaited result" do
      exp = fn () -> 1 + 2 end
      assert 3 = TaskExercise.awaited_task(exp)
    end
  end

  describe "awaited_tasks" do
    test "returns awaited result list" do
      exp = fn a -> a + 1 end
      assert [2, 3, 4] = TaskExercise.awaited_tasks([1, 2, 3], exp)
    end
  end

  describe "supervised_task" do
    test "returns awaited result" do
      exp = fn () -> 1 + 2 end
      assert 3 = TaskExercise.supervised_task(exp)
    end
  end
end
