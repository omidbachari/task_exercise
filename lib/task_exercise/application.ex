defmodule TaskExercise.Application do
  @moduledoc """
  The supervisor for this application
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: TaskExercise.SuperviseJob, restart: :transient]])
    ]

    opts = [strategy: :one_for_one, name: TaskExercise.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
