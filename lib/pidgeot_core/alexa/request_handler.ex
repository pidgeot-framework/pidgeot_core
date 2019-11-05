defmodule PidgeotCore.Alexa.RequestHandler do
  import Plug.Conn
  import PidgeotCore.Alexa.RequestParser

  def init(options), do: options

  def call(conn, module) do
    preform_action(conn, module)
  end

  defp preform_action(conn, module) do
    IO.inspect(conn.body_params)
    case request_type(conn.body_params) do
      "LaunchRequest" -> handle_launch(conn,module)
      "IntentRequest" -> handle_intent(conn, module)
      _ -> handle_unsupported(conn)
    end
  end

  defp handle_launch(conn, module) do
    module.action_call("Launch", conn)
  end

  defp handle_intent(conn, module) do
    intent_name(conn.body_params) |> module.action_call(conn)
  end

  defp handle_unsupported(conn) do
    send_resp(conn, 404, "unsupported request type")
  end
end
