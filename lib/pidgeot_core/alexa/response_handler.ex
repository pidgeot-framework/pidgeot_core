defmodule PidgeotCore.Alexa.ResponseHandler do
    alias PidgeotCore.Alexa.PidgeotStore

    import PidgeotCore.Alexa.ResponseBuilder
    import Plug.Conn

    def handle(conn) do
      conn
      |> build_response()
      |> encode_response()
      |> set_headers()
      |> send_response()
    end

    defp encode_response(conn) do
      json = conn
              |> PidgeotStore.load_response()
              |> Poison.encode!()

      resp(conn, 200, json)
    end

    defp set_headers(conn) do
      put_resp_content_type(conn, "application/json")
    end

    defp send_response(conn), do: send_resp(conn)
end
