defmodule Delegate.Function.DefdelegateallTest do
  use AsyncCase

  defmodule Base do
    def plain_hello, do: "hello"
    def friendly_hello(name), do: "hello #{name}!"
    def hello(name, last_name), do: "hello #{name} #{last_name}"
  end

  defmodule DelegateFun do
    use Delegate.Function

    defdelegateall(Base)
  end

  defmodule DelegateFunOnly do
    use Delegate.Function

    defdelegateall(Base, only: [plain_hello: 0])
  end

  defmodule DelegateFunExcept do
    use Delegate.Function

    defdelegateall(Base,
      except: [plain_hello: 0, friendly_hello: 1]
    )
  end

  describe "when no option specified" do
    test "delegates all functions" do
      plain_hello = DelegateFun.plain_hello()
      friendly_hello = DelegateFun.friendly_hello("Jon")
      hello = DelegateFun.hello("Jon", "Snow")

      assert plain_hello == "hello"
      assert friendly_hello == "hello Jon!"
      assert hello == "hello Jon Snow"
    end
  end

  describe "when :only specified" do
    test "delegates only specified functions" do
      plain_hello = DelegateFunOnly.plain_hello()
      [plain_hello: 0] = DelegateFunOnly.__info__(:functions)

      assert plain_hello == "hello"
    end
  end

  describe "when :except specified" do
    test "delegates everything except specified functions" do
      hello = DelegateFunExcept.hello("Jon", "Snow")
      [hello: 2] = DelegateFunExcept.__info__(:functions)

      assert hello == "hello Jon Snow"
    end
  end
end
