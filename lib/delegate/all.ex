defmodule Delegate.All do
  @moduledoc false

  defmacro defdelegatetype(type, to, opts \\ [])
           when type == :macros or type == :functions do
    {delegator_module, delegator_macro} =
      case type do
        :macros -> {Delegate.Macro, :defmacrodelegate}
        :functions -> {Kernel, :defdelegate}
      end

    only = Keyword.get(opts, :only)
    except = Keyword.get(opts, :except, [])

    definitions =
      if is_nil(only) do
        to
        |> Macro.expand(__CALLER__)
        |> Kernel.apply(:__info__, [type])
      else
        only
      end

    definitions =
      Enum.reduce(except, definitions, fn definition, new_definitions ->
        {name, arity} = definition
        Keyword.delete(new_definitions, name, arity)
      end)

    header =
      quote do
        require unquote(delegator_module)
      end

    infinity_enum = Stream.iterate(1, &(&1 + 1))

    defs =
      Enum.map(definitions, fn definition ->
        {name, arity} = definition

        args =
          infinity_enum
          |> Stream.take(arity)
          |> Stream.map(&String.to_atom("arg#{&1}"))
          |> Enum.map(fn arg -> {arg, [], nil} end)

        quote do
          unquote(delegator_module).unquote(delegator_macro)(
            unquote(name)(unquote_splicing(args)),
            to: unquote(to)
          )
        end
      end)

    [header | defs]
  end
end
