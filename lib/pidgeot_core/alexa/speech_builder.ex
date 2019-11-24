defmodule PidgeotCore.Alexa.SpeechBuilder do
  alias PidgeotCore.Alexa.PidgeotStore
  alias PidgeotCore.Alexa.Structs.ServerResponse

  def tell(conn), do: {conn, [:response, :outputSpeech, :ssml_arr]}
  def reprompt(conn), do: {conn, [:response, :reprompt, :outputSpeech, :ssml_arr]}
  def text(params, text) do
    add_ssml(params, text)
  end

  defp add_ssml({conn, path}, ssml) do
    struct = PidgeotStore.load_response(conn)
    ssml_arr = ServerResponse.get(struct, path)
    new_struct = case ssml_arr do
      nil -> ServerResponse.set(struct, path, [ssml])
      [] -> ServerResponse.set(struct, path, [ssml])
      arr when is_list(arr) -> ServerResponse.set(struct, path, ssml_arr ++ [ssml])
    end
    conn = PidgeotStore.save_response(conn, new_struct)
    {conn, path}
  end
end
