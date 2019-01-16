defmodule Delegate do
  @moduledoc """
  Provides utilities for delegating macros and entire functions and macros of another module.

  All macros can be included with `use Delegate`.

  The following functionalities are provided:

  - `defmacrodelegate` behaves like `defdelegate` but for macros
    (at compile time)
  - `defdelegateall` creates delegates for all functions of the delegated
    module
  - `defmacrodelegateall` creates delegates for all macros of the delegated
    module
  - `defmoduledelegate` which creates delegates for all macros and all
    functions of the delegated module
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Delegate.Macro
    end
  end
end
