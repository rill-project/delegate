defmodule Delegate.Function do
  @moduledoc """
  Provides  `defdelegateall` which allows delegating to all the functions on
  the target module

  `use Delegate.Function` provides all macros (require + import)
  """

  @type defdelegateall_opts ::
          {:only, [{atom(), arity()}]} | {:except, [{atom(), arity()}]}

  @doc ~S"""
  Creates macro delegates for each function on the `:to` module

  ## Arguments
  - `to` module to delegate to and to find the list of functions to delegate
  - `opts` is a keyword:
    - `:only` (optional) functions that will be delegated, excluding everything
      else
    - `:except` (optional) all functions will be delegated except those listed
      in this argument

  ## Examples

  ```elixir
  defmodule Base do
    def hello(name) do
      "hello #{unquote(name)}"
    end

    def bye() do
      "bye"
    end
  end

  defmodule DelegateFun do
    use Delegate.Function

    defdelegateall(Base)

    # Function `hello/1` and `bye/0` are defined in this module
  end

  DelegateFun.hello("Jon")
  DelegateFun.bye()
  ```
  """
  @spec defdelegateall(
          to :: module(),
          opts :: [defdelegateall_opts()]
        ) :: term()
  defmacro defdelegateall(to, opts \\ []) do
    quote do
      require Delegate.All
      Delegate.All.defdelegatetype(:functions, unquote(to), unquote(opts))
    end
  end

  defmacro __using__(_opts \\ []) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end
end
