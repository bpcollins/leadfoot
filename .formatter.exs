[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"],
  plugins: [Phoenix.LiveView.HTMLFormatter, Styler],
  subdirectories: ["priv/*/migrations"]
]
