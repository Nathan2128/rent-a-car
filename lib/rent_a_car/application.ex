defmodule RentACar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    children = [
      RentACarWeb.Telemetry,
      RentACar.Repo,
      {DNSCluster, query: Application.get_env(:rent_a_car, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RentACar.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RentACar.Finch},
      # Start a worker by calling: RentACar.Worker.start_link(arg)
      # {RentACar.Worker, arg},
      # Start to serve requests, typically the last entry
      RentACarWeb.Endpoint,
      # supervisor(Absinthe.Subscription, [RentACarWeb.Endpoint])
      {Absinthe.Subscription, RentACarWeb.Endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RentACar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RentACarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
