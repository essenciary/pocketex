defmodule Pocketex.Mixfile do
  use Mix.Project

  def project do
    [app: :pocketex,
     version: "0.1.0",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.6"},
      {:poison, "~> 1.3.1"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev}
    ]
  end

  defp description do
    """
    Pocketex is an Elixir client for the Pocket read later service (getpocket.com)
    """
  end

  defp package do
    [# These are the default files included in the package
     files: ["config", "doc", "lib", "test", "mix.exs", "README*"],
     contributors: ["Adrian Salceanu"],
     licenses: ["GPLv3"],
     links: %{"GitHub" => "https://github.com/essenciary/pocketex",
              "Docs" => "http://essenciary.github.io/pocketex/doc/"}]
  end
end
