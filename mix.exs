defmodule Phorg.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phorg,
      version: "0.1.0",
      elixir: "~> 1.5",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  #def application do
  #  [
  #    mod: {Phorg, []},
  #    extra_applications: [:logger, :poolboy]
  #  ]
  #end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:exexif, git: "https://github.com/orthogonous/exexif.git"},
      {:poolboy, "~> 1.5.1"},
      {:apex, "~>1.0.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end
end
