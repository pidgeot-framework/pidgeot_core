defmodule PidgeotCore.Action do
  defmacro __using__(_opts) do
    quote location: :keep do
      import PidgeotCore.Action
      import PidgeotCore.Alexa.SpeechBuilder

      def init(opts), do: opts

      def call(conn, opts) do
        conn
      end
    end
  end

  def redirect_to(conn, module) do
  end
end
