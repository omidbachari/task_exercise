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

  @doc """
  This is a function that performs
  a collection of tasks. Each task is
  performed asynchronously and we
  return a collection of results. It
  takes a list and a function.

  Example:
      iex(1)> TaskExercise.awaited_tasks([1, 2, 3], (fn a -> a + 1 end))
      [2, 3, 4]

  """
  @spec awaited_tasks(list, (... -> any)) :: list
  def awaited_tasks(list, fun) when is_list(list) do
    list
    |> Enum.map(fn(arg) -> Task.async(fn () -> fun.(arg) end) end)
    |> Enum.map(fn(job) -> Task.await(job) end)
  end
end
