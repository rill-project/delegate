defmodule Delegate.Macro do
  @moduledoc """
  Provides a `defmacrodelegate` which allows delegating a macro to another
  macro at compile time.
  In addition, `defmacrodelegateall` is provided which allows delegating to
  all the macros on the target module

  `use Delegate.Macro` provides all macros (require + import)
  """

  @type defmacrodelegate_opts :: {:as, atom()} | {:to, module()}

  @doc ~S"""
  Delegates a macro to another macro at compile time.

  ## Arguments
  - `head` is the macro definition
  - `opts` is a keyword:
    - `:to` (required) which refers to the module the macro must be delegated
      to
    - `:as` (optional) a different name for the macro delegating to the module.
      When not specified, it defaults to the macro name defined in `:to` module

  ## Examples

  ```elixir
  defmodule BaseMacro do
    defmacro hello(name) do
      quote do
        "hello #{unquote(name)}"
      end
    end
  end

  defmodule DelegateMacro do
    use Delegate.Macro

    defmacrodelegate hello(name), to: BaseMacro, as: :world
  end

  defmodule UseTheMacro do
    require DelegateMacro

    def hello_func do
      DelegateMacro.hello("Francesco") # => "hello Francesco"
    end
  end
  ```
  """
  @spec defmacrodelegate(head :: term(), opts :: [defmacrodelegate_opts()]) ::
          term()
  defmacro defmacrodelegate(head, opts) do
    {name, _ctx, args} = head
    as = Keyword.get(opts, :as, name)
    to = Keyword.fetch!(opts, :to)

    quote do
      defmacro unquote(as)(unquote_splicing(args)) do
        to = unquote(to)
        name = unquote(name)
        args = unquote(args)

        quote do
          require unquote(to)
          unquote(to).unquote(name)(unquote_splicing(args))
        end
      end
    end
  end

  @type defmacrodelegateall_opts ::
          {:only, [{atom(), arity()}]} | {:except, [{atom(), arity()}]}

  @doc ~S"""
  Creates macro delegates for each macro on the `:to` module

  ## Arguments
  - `to` module to delegate to and to find the list of macros to delegate
  - `opts` is a keyword:
    - `:only` (optional) macros that will be delegated, excluding everything
      else
    - `:except` (optional) all macros will be delegated except those listed in
      this argument

  ## Examples

  ```elixir
  defmodule BaseMacro do
    defmacro hello(name) do
      quote do
        "hello #{unquote(name)}"
      end
    end

    defmacro bye() do
      quote do
        "bye"
      end
    end
  end

  defmodule DelegateMacro do
    use Delegate.Macro

    defmacrodelegateall(BaseMacro)

    # Macro `hello/1` and `bye/0` are defined in this module
  end

  require DelegateMacro

  DelegateMacro.hello("Jon")
  DelegateMacro.bye()
  ```
  """
  @spec defmacrodelegateall(
          to :: module(),
          opts :: [defmacrodelegateall_opts()]
        ) :: term()
  defmacro defmacrodelegateall(to, opts \\ []) do
    quote do
      require Delegate.All
      Delegate.All.defdelegatetype(:macros, unquote(to), unquote(opts))
    end
  end

  defmacro __using__(_opts \\ []) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end
end
