defmodule Delegate.Module do
  @moduledoc """
  Provides  `defmoduledelegate` which generates delegates for all functions
  and macros present on the `:to` module.
  Supports `:only` and `:except`.

  `use Delegate.Module` provides all macros (require + import)
  """

  @type defmoduledelegate_opts ::
          {:only, [{atom(), arity()}]} | {:except, [{atom(), arity()}]}

  @doc ~S"""
  Creates delegates for each function on the `:to` module

  ## Arguments
  - `to` module to delegate to and to find the list of functions and macros
    to delegate
  - `opts` is a keyword:
    - `:only` (optional) functions/macros that will be delegated, excluding everything
      else
    - `:except` (optional) all functions/macros will be delegated except those
      listed in this argument

  ## Examples

  ```elixir
  defmodule Base do
    def hello(name) do
      "hello #{unquote(name)}"
    end

    defmacro bye() do
      quote do
        "bye"
      end
    end
  end

  defmodule DelegateFun do
    use Delegate.Module

    defmoduledelegate(Base)

    # Function `hello/1` and macro `bye/0` are defined in this module
  end

  require DelegateFun

  DelegateFun.hello("Jon")
  DelegateFun.bye()
  ```
  """
  @spec defmoduledelegate(
          to :: module(),
          opts :: [defmoduledelegate_opts()]
        ) :: term()
  defmacro defmoduledelegate(to, opts \\ []) do
    quote do
      require Delegate.Macro
      require Delegate.Function

      Delegate.Macro.defmacrodelegateall(unquote(to), unquote(opts))
      Delegate.Function.defdelegateall(unquote(to), unquote(opts))
    end
  end

  defmacro __using__(_opts \\ []) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end
end
