defmodule PidgeotCore.Alexa.RequestHandler do
  import PidgeotCore.Alexa.RequestParser
  import PidgeotCore.Alexa.ResponseBuilder

  def init(options) do
    options
  end

  def call(conn, [module: map_module]) do
    validate_existing_map_module(map_module)
    preform_action(conn, map_module)
  end

  defp preform_action(conn, map_module) do
    IO.inspect(conn.body_params)
    case type = request_type(conn.body_params) do
      "LaunchRequest" -> handle_launch(conn, map_module)
      "IntentRequest" -> handle_intent(conn, map_module)
      _ -> handle_unsupported(conn, type)
    end
  end

  defp handle_launch(conn, map_module) do
    call_mapped_action(conn, "Launch", map_module)
  end

  defp handle_intent(conn, map_module) do
    action_name = intent_name(conn.body_params)
    call_mapped_action(conn, action_name, map_module)
  end

  defp handle_unsupported(_, type) do
    raise "Intent type #{type} isn't supported yet"
  end

  defp call_mapped_action(conn, action_name, map_module) do
    conn
    |> initialize_store()
    |> map_module.action_call(action_name)
    |> encode_response()
    |> set_headers()
    |> send_response()
  end

  defp validate_existing_map_module(module) do
    unless Keyword.has_key?(module.__info__(:functions), :action_call) do
      raise("No intent map defined in module #{to_string(module)}")
    end
  end
end
