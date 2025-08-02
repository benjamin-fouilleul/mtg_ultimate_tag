defmodule MtgUltimateTag.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MtgUltimateTagWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:mtg_ultimate_tag, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MtgUltimateTag.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MtgUltimateTag.Finch},
      # Start a worker by calling: MtgUltimateTag.Worker.start_link(arg)
      # {MtgUltimateTag.Worker, arg},
      # Start to serve requests, typically the last entry
      MtgUltimateTagWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MtgUltimateTag.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MtgUltimateTagWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
