defmodule PidgeotCore.IntentMap do
  defmacro __using__(_) do
    quote do
      import PidgeotCore.IntentMap
      @before_compile PidgeotCore.IntentMap

      def validate_action(module) do
        if !Keyword.has_key?(module.__info__(:functions), :call) do
          raise("No action spcified in module #{to_string(module)}")
        end
      end
    end
  end

  defmacro __before_compile__(env) do
    unless Module.defines?(env.module, {:action_call, 2}, :def) do
      raise "Macro map unused in module #{to_string(env.module)}"
    end

    quote do
      def action_call(conn, _ = name) do
        raise "Intent #{name} has no mapping"
      end
    end
  end


  defmacro map(name, to: action_module, init_opts: init_opts) do
    action_call_def(name, action_module, init_opts)
  end

  defmacro map(name, to: action_module) do
    action_call_def(name, action_module, [])
  end

  defp action_call_def(name, action_module, init_opts) do
    quote do
      def action_call(conn, unquote(name)) do
        validate_action(unquote(action_module))
        opts = unquote(action_module).init(unquote(init_opts))
        unquote(action_module).call(conn, opts)
      end
    end
  end
end
