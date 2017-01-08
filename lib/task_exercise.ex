defmodule TaskExercise do
  @moduledoc """
  Main module for the TaskExercise app,
  which is a thought experiment for
  demonstrating the value of tasks and
  how they are used.
  """

  @doc """
  This is a simple task, which is
  performed asynchronously, without
  concern about the return. It takes
  a function, which contains the work
  to be performed.

  Example:

      iex(1)> TaskExercise.simple_task(fn () -> 1 + 2 end)
      {:ok, #PID<0.119.0>}

  """
  @spec simple_task((... -> any)) :: {:ok, pid}
  def simple_task(fun), do: Task.start fun

  @doc """
  This is an awaited task, which is
  performed asynchronously and we do
  care about the return. It takes
  a function, which contains the work
  to be performed.

  Example:

      iex(1)> TaskExercise.awaited_task(fn () -> 1 + 2 end)
      3

  """
  @spec awaited_task((... -> any)) :: any
  def awaited_task(fun), do: Task.async(fun) |> Task.await
end
