defmodule PidgeotCore.Action do
  defmacro __using__(_opts) do
    quote location: :keep do
      import PidgeotCore.Action
      import PidgeotCore.Alexa.SpeechBuilder
      alias PidgeotCore.Alexa.Structs.ServerResponse
      alias PidgeotCore.Alexa.PidgeotStore

      def init(opts), do: opts

      def call(conn, opts) do
        perform(conn)
      end
    end
  end

  def execute_action(conn, module) do
    if !Keyword.has_key?(module.__info__(:functions), :call) do
      raise("No action spcified in module #{to_string(module)}")
    end

    if !Keyword.has_key?(module.__info__(:functions), :call) do
      raise("No action spcified in module #{to_string(module)}")
    end

    opts = module.init([])
    module.call(conn, opts)
  end
end
