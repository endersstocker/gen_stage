alias Experimental.Flow

defmodule Flow.Window.Global do
  @moduledoc false

  defstruct [:trigger, periodically: []]

  def materialize(_window, reducer_acc, reducer_fun, reducer_trigger) do
    acc = reducer_acc

    fun =
      if is_function(reducer_fun, 4) do
        reducer_fun
      else
        fn ref, events, acc, index ->
          reducer_fun.(ref, events, acc, index, {:global, :global, :placeholder})
        end
      end

    trigger =
      fn acc, index, op, name ->
        reducer_trigger.(acc, index, op, {:global, :global, name})
      end

    {acc, fun, trigger}
  end
end
