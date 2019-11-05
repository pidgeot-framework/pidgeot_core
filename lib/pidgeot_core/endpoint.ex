defmodule PidgeotCore.Endpoint do
  defmacro __using__(opts) do
    quote location: :keep do
      use Plug.Router

      if Mix.env() == :dev do
        use Plug.Debugger, otp_app: :pidgeot
      end

      plug(Plug.Logger)
      plug(:match)
      plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
      plug(:dispatch)
    end
  end
end
