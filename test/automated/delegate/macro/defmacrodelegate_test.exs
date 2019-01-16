defmodule Delegate.Macro.DefmacrodelegateTest do
  use AsyncCase

  defmodule BaseMacro do
    defmacro hello(name, do: block) do
      quote do
        "hello #{unquote(name)}: " <> to_string(unquote(block))
      end
    end
  end

  defmodule DelegateMacro do
    use Delegate.Macro

    defmacrodelegate(hello(name, do: block), to: BaseMacro)
    defmacrodelegate(hello(name, do: block), as: :world, to: BaseMacro)
  end

  defmodule RunMacro do
    require DelegateMacro

    def macro_to do
      DelegateMacro.hello "world" do
        "this is a delegate macro"
      end
    end

    def macro_as_to do
      DelegateMacro.world "world" do
        "this is a delegate macro"
      end
    end
  end

  describe "when only :to option used" do
    test "creates a macro delegate with same name" do
      text = RunMacro.macro_to()

      assert text == "hello world: this is a delegate macro"
    end
  end

  describe "when :as option used" do
    test "creates a macro delegate renamed" do
      text = RunMacro.macro_as_to()

      assert text == "hello world: this is a delegate macro"
    end
  end
end
