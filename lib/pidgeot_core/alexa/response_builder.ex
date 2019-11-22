defmodule PidgeotCore.Alexa.ResponseBuilder do
    alias PidgeotCore.Alexa.PidgeotStore

    import Plug.Conn

    def initialize_store(conn) do
      PidgeotStore.init(conn)
    end

    def encode_response(conn) do
      json = conn
              |> PidgeotStore.fetch(:server_response)
              |> Poison.encode!()

      resp(conn, 200, json)
    end

    def set_headers(conn) do
      put_resp_content_type(conn, "application/json")
    end

    def send_response(conn), do: send_resp(conn)
end
