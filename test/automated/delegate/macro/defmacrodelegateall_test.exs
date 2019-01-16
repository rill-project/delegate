defmodule Delegate.Macro.DefmacrodelegateallTest do
  use AsyncCase

  require DelegateMacro
  require DelegateMacroOnly
  require DelegateMacroExcept

  describe "when no option specified" do
    test "delegates all macros" do
      plain_hello = DelegateMacro.plain_hello()
      friendly_hello = DelegateMacro.friendly_hello("Jon")
      hello = DelegateMacro.hello("Jon", "Snow")

      assert plain_hello == "hello"
      assert friendly_hello == "hello Jon!"
      assert hello == "hello Jon Snow"
    end
  end

  describe "when :only specified" do
    test "delegates only specified macros" do
      plain_hello = DelegateMacroOnly.plain_hello()
      [plain_hello: 0] = DelegateMacroOnly.__info__(:macros)

      assert plain_hello == "hello"
    end
  end

  describe "when :except specified" do
    test "delegates everything except specified macros" do
      hello = DelegateMacroExcept.hello("Jon", "Snow")
      [hello: 2] = DelegateMacroExcept.__info__(:macros)

      assert hello == "hello Jon Snow"
    end
  end
end
