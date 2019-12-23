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

  def redirect_to(conn, module) do
  end
end
