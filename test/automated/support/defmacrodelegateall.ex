defmodule BaseWithMacros do
  defmacro plain_hello do
    quote do
      "hello"
    end
  end

  defmacro friendly_hello(name) do
    quote do
      "hello #{unquote(name)}!"
    end
  end

  defmacro hello(name, last_name) do
    quote do
      "hello #{unquote(name)} #{unquote(last_name)}"
    end
  end
end

defmodule DelegateMacro do
  use Delegate.Macro

  defmacrodelegateall(BaseWithMacros)
end

defmodule DelegateMacroOnly do
  use Delegate.Macro

  defmacrodelegateall(BaseWithMacros, only: [plain_hello: 0])
end

defmodule DelegateMacroExcept do
  use Delegate.Macro

  defmacrodelegateall(BaseWithMacros,
    except: [plain_hello: 0, friendly_hello: 1]
  )
end
