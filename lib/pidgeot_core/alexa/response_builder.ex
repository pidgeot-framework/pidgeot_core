defmodule PidgeotCore.Alexa.ResponseBuilder do
  alias PidgeotCore.Alexa.Structs.ServerResponse
  alias PidgeotCore.Alexa.Structs.OutputSpeech
  alias PidgeotCore.Alexa.PidgeotStore

  def build_response(conn) do
    conn
      |> load_server_response()
      |> compile_reprompt()
      |> compile_speech()
      |> log_response()
      |> save_server_response(conn)
  end

  defp compile_reprompt(%ServerResponse{} = struct) do
    path = [:response, :reprompt, :outputSpeech]
    compile_ssml(struct, path)
  end

  defp log_response(struct) do
    IO.inspect(struct)
    struct
  end

  defp compile_speech(%ServerResponse{} = struct) do
    path = [:response, :outputSpeech]
    compile_ssml(struct, path)
  end

  defp load_server_response(conn), do: PidgeotStore.load_response(conn)

  defp save_server_response(response, conn), do: PidgeotStore.save_response(conn, response)


  defp compile_ssml(%ServerResponse{} = struct, path) do
    speech = ServerResponse.get(struct, path)
    case speech do
      nil -> struct
      _ -> compiled_speech = OutputSpeech.compile_ssml(speech)
           ServerResponse.set(struct, path, compiled_speech)
    end
  end
end
