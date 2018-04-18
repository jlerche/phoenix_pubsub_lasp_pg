# PhoenixPubsubLaspPg

[Lasp PG](https://lasp-lang.readme.io/docs/what-is-lasp-pg) is a process group library written using [Lasp](https://lasp-lang.readme.io/docs/what-is-lasp), which
is a relatively new project to help write distributed applications. It bypasses
distributed Erlang and relies on CRDTs for its programming model. To this end,
it also encourages the programmer to use special operations for data manipulation that guarantee commutativity and convergence. Lasp PG itself is pretty close to a drop in replacement for `pg2`, but with a stronger consistency model.

Lasp is still pretty experimental, so use with caution!

## Usage

To use as your PubSub adapter, add it to your dependencies and Endpoint config

```elixir
# mix.exs
def deps do
  [
    {:phoenix_pubsub_lasp_pg, git: "https://github.com/jlerche/phoenix_pubsub_lasp_pg.git"}
  ]
end

# config/config.exs
config :my_app, MyApp.Endpoint,
  pubsub: [name: MyApp.PubSub, adapter: Phoenix.PubSub.LaspPG]
```
The options are the same as `Phoenix.PubSub.PG2`, see its documentation for more.
