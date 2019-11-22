defmodule PidgeotCore.Alexa.SpeechBuilder do
  alias PidgeotCore.Alexa.PidgeotStore

  def tell(conn), do: {conn, :ssml}
  def reprompt(conn), do: {conn, :reprompt_ssml}
  def text({conn, type}, text) do
    add_ssml(conn, type, text)
    {conn, type}
  end

  defp add_ssml(conn, key, ssml) do
    PidgeotStore.append(conn, key, ssml)
  end
end
