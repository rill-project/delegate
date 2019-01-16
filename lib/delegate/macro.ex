defmodule Delegate.Macro do
  @moduledoc """
  Provides a `defmacrodelegate` which allows delegating a macro to another
  macro at compile time.

  `use Delegate.Macro` provides `defmacrodelegate` (import + require)
  """

  @type defmacrodelegate_opts :: {:as, atom()} | {:to, module()}

  @doc """
  Delegates a macro to another macro at compile time.

  ## Arguments
  - `head` is the macro definition
  - `opts` is a list:
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

  defmacro __using__(_opts \\ []) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end
end
