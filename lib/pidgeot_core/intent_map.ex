defmodule PidgeotCore.IntentMap do
  defmacro map(name, to: action) do
    quote do
      def action_call(unquote(name), conn) do
        unquote(action).call(conn)
      end
    end
  end
end
