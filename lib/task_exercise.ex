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

  @doc """
  This is a supervised and awaited task.
  It takes a function, which contains the work
  to be performed. It returns the result.

  Example:

      iex(1)> TaskExercise.supervised_task(fn () -> 1 + 2 end)
      3

  To verify that the supervisor starts
  properly and to verify that the task
  looks the way you might expect, try the
  following:

      iex(1)> :observer.start
      :ok
      iex(2)> exp = fn -> :timer.sleep(5_000) end
      #Function<20.52032458/0 in :erl_eval.expr/5>
      iex(3)> TaskExercise.supervised_task(exp)

  The return value of the above isn't
  important, but watching the `Applications`
  tab in Observer will illustrate the
  network of processes you've created.

  """
  @spec supervised_task((... -> any)) :: any
  def supervised_task(fun), do: Task.Supervisor.async(TaskExercise.DoJob, fun) |> Task.await
end
