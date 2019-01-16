# Delegate

Provides utilities for delegating macros and entire functions and macros of another module

## Installation

The package can be installed
by adding `delegate` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:delegate, ">= 0.0.0"}
  ]
end
```

The docs can
be found at [https://hexdocs.pm/delegate](https://hexdocs.pm/delegate).

## Usage

`use Delegate` provides the following macros:

- `defmacrodelegate`, like `defdelegate` but for macros (happens at compile
  time). Supports same options as `defdelegate`
- `defdelegateall(MyModule, only: [myfun: 1])` creates delegates for all
  functions in `MyModule`. Supports `only` and `except` options
- `defmacrodelegateall` like `defdelegateall` but for macros
- `defmoduledelegate` utility that runs both `defdelegateall` and
  `defmacrodelegateall`, supports `only` and `except`
