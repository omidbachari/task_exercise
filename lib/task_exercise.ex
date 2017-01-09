defmodule TaskExercise do
  @moduledoc """
  Main module for the TaskExercise app,
  which is a thought experiment for
  demonstrating the value of tasks and
  how they are used.
  """

  @doc """
  Wraps a simple task, which is
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
  Wraps an awaited task, which is
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
  def awaited_tasks(jobs, fun) when is_list(jobs) do
    jobs
    |> Task.async_stream(fun)
    |> Enum.to_list
    |> Enum.map(fn({_k, v}) -> v end)
  end

  @doc """
  This function wraps a supervised and awaited task.
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
  def supervised_task(fun), do: TaskExercise.SuperviseJob |> Task.Supervisor.async(fun) |> Task.await

  @doc """
  This function performs a supervised and awaited collection
  of tasks. It takes a list and a function.
  It returns the result.

  Example:

      iex(1)>  exp = fn a -> a + 2 end
      #Function<6.52032458/1 in :erl_eval.expr/5>
      iex(2)> TaskExercise.supervised_tasks([1, 2, 3, 4, 5], exp)
      [3, 4, 5, 6, 7]

  """
  @spec supervised_tasks(list, (... -> any)) :: list
  def supervised_tasks(jobs, fun) when is_list(jobs) do
    TaskExercise.SuperviseJob
    |> Task.Supervisor.async_stream(jobs, fun)
    |> Enum.to_list
    |> Enum.map(fn({_k, v}) -> v end)
  end
end
