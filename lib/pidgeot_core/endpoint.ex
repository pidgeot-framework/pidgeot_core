defmodule PidgeotCore.Endpoint do
  defmacro __using__(_opts) do
    quote location: :keep do
      use Plug.Router
      import PidgeotCore.Endpoint

      if Mix.env() == :dev do
        use Plug.Debugger, otp_app: :pidgeot
      end

      plug(:inspect_state)
      plug(Plug.Logger)
      plug(:match)
      plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
      plug(:dispatch)

      def inspect_state(conn, _opts) do
        IO.inspect conn
        conn
      end
    end
  end

  defmacro alexa(on: path) do
    quote do
      post unquote(path),
        to: PidgeotCore.Alexa.RequestHandler,
        init_opts: [module: Pidgeot.IntentMap]
    end
  end

  defmacro alexa(on: path, map: map) do
    quote do
      post unquote(path),
        to: PidgeotCore.Alexa.RequestHandler,
        init_opts: [module: unquote(map)]
    end
  end
end
