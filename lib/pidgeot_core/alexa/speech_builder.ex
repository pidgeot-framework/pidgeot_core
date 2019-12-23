defmodule PidgeotCore.Alexa.SpeechBuilder do
  alias PidgeotCore.Alexa.PidgeotStore
  alias PidgeotCore.Alexa.Structs.ServerResponse

  def start, do: ""

  def tell(conn, [do: ssml]), do: tell(ssml, conn)
  def tell(ssml, conn) do
    params = {conn, [:response, :outputSpeech, :ssml_arr]}
    {conn, _} = add_ssml(params, ssml)
    conn
  end

  def reprompt(conn, [do: ssml]), do: reprompt(ssml, conn)
  def reprompt(ssml, conn) do
    params = {conn, [:response, :reprompt, :outputSpeech, :ssml_arr]}
    {conn, _} = add_ssml(params, ssml)
    conn
  end

  def ask(conn, [do: ssml]), do: ask(ssml, conn)
  def ask(ssml, conn) do
    conn = setSessionEnd(conn, false)
    params = {conn, [:response, :outputSpeech, :ssml_arr]}
    {conn, _} = add_ssml(params, ssml)
    conn
  end

  def ssml(text), do: ssml("", text)
  def ssml(ssml, [do: text]), do: ssml(ssml, text)
  def ssml(ssml, text) do
    "#{ssml}#{text}"
  end

  def lang(lang, text), do: lang("", lang, text)
  def lang(ssml, lang, [do: text]), do: lang(ssml, lang, text)
  def lang(ssml, lang, text) do
    "#{ssml}<lang xml:lang=\"#{lang}\">#{text}</lang>"
  end

  def phoneme(alphabet, pronounciation, human_readable), do: phoneme("", alphabet, pronounciation, human_readable)
  def phoneme(ssml, alphabet, pronounciation, human_readable) do
    "#{ssml}<phoneme alphabet=\"#{alphabet}\" ph=\"#{pronounciation}\">#{human_readable}</phoneme>"
  end

  def prosody(options, text), do: prosody("", options, text)
  def prosody(final_ssml, options, [do: text]), do: prosody(final_ssml, options, text)
  def prosody(final_ssml, options, text) do
    volume = options[:volume]
    rate = options[:rate]
    pitch = options[:pitch]

    ssml = "<prosody"
    ssml = if volume, do: "#{ssml} volume=\"#{volume}\"", else: ssml
    ssml = if rate, do: "#{ssml} rate=\"#{rate}\"", else: ssml
    ssml = if pitch, do: "#{ssml} pitch=\"#{pitch}\"", else: ssml
    ssml = "#{ssml}>#{text}</prosody>"
    "#{final_ssml}#{ssml}"
  end

  def say_as(options, text), do: say_as("", options, text)
  def say_as(final_ssml, options, [do: text]), do: say_as(final_ssml, options, text)
  def say_as(final_ssml, options, text) do
    as = options[:as]
    format = options[:format]

    ssml = "<say-as interpret-as=\"#{as}\">"
    ssml = if as == "date", do: "#{ssml} format=\"#{format}\"", else: ssml
    ssml = "#{ssml}>#{text}</say-as>"
    "#{final_ssml}#{ssml}"
  end

  def voice(voice, text), do: voice("", voice, text)
  def voice(ssml, voice, [do: text]), do: voice(ssml, voice, text)
  def voice(ssml, voice, text) do
    "#{ssml}<voice name=\"#{voice}\">#{text}</voice>"
  end

  def sub(as, text), do: sub("", as, text)
  def sub(ssml, as, [do: text]), do: sub(ssml, as, text)
  def sub(ssml, as, text) do
    "#{ssml}<sub alias=\"#{as}\">#{text}</sub>"
  end

  def p(text), do: p("", text)
  def p(ssml, [do: text]), do: p(ssml, text)
  def p(ssml, text) do
    "#{ssml}<p>#{text}</p>"
  end

  def s(text), do: s("", text)
  def s(ssml, [do: text]), do: s(ssml, text)
  def s(ssml, text) do
    "#{ssml}<s>#{text}</s>"
  end


  def emphasis(level, text), do: emphasis("", level, text)
  def emphasis(ssml, level, [do: text]), do: emphasis(ssml, level, text)
  def emphasis(ssml, level, text) do
     "#{ssml}<emphasis level=\"#{level}\">#{text}</emphasis>"
  end

  def break(time), do: break("", time)
  def break(ssml, time) do
    "#{ssml}<break time=\"#{time}\"/>"
  end

  def audio(url), do: audio("",url)
  def audio(ssml, url) do
    "#{ssml}<audio src=\"#{url}\" />"
  end

  defp setSessionEnd(conn, value) do
    path = [:response, :shouldEndSession]
    struct = PidgeotStore.load_response(conn)
    new_struct = ServerResponse.set(struct, path, value)
    PidgeotStore.save_response(conn, new_struct)
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
