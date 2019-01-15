defmodule Delegate.MixProject do
  use Mix.Project

  @external_resource path = Path.join(__DIR__, "VERSION")
  @version path |> File.read!() |> String.trim()

  def project do
    [
      app: :delegate,
      version: @version,
      elixir: "~> 1.7",
      package: package(),
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test/automated"],
      consolidate_protocols: consolidate_protocols(Mix.env()),
      preferred_cli_env: [
        itest: :dev
      ],
      dialyzer: [
        plt_add_apps: [:mnesia],
        flags: [
          :unmatched_returns,
          :error_handling,
          :race_conditions
        ],
        paths: ["_build/#{Mix.env()}/lib/delegate/consolidated"]
      ],
      # Docs
      name: "Delegate",
      source_url: "https://github.com/rill-project/delegate",
      homepage_url: "https://github.com/rill-project/delegate",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      maintainers: ["Francesco Belladonna"],
      description:
        "Delegate macros or all functions and macros to another module",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rill-project/delegate"},
      files: [
        ".formatter.exs",
        "mix.exs",
        "README.md",
        "VERSION",
        "test",
        "lib",
        "config/config.exs",
        "config/environment/dev.exs",
        "config/environment/prod.exs",
        "config/environment/test.exs"
      ]
    ]
  end

  def docs do
    [
      main: "README.md",
      extras: ["README.md": [filename: "README.md", title: "Delegate"]]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, ">= 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.19.2", only: [:dev]}
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/automated/support"]
  def elixirc_paths(_), do: ["lib"]

  def consolidate_protocols(:test), do: false
  def consolidate_protocols(:dev), do: false
  def consolidate_protocols(_), do: true

  def aliases do
    [
      itest: ["run"]
    ]
  end
end
