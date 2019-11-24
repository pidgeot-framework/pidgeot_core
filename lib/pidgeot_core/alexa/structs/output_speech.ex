defmodule PidgeotCore.Alexa.Structs.OutputSpeech do
  alias PidgeotCore.Alexa.Structs.OutputSpeech

  @derive {Poison.Encoder, except: [:ssml_arr]}
  defstruct type: "SSML",
            ssml: "<speak></speak>",
            ssml_arr: []

  def compile_ssml(%OutputSpeech{ssml_arr: ssml_arr} = struct) do
    ssml_sum = Enum.join(ssml_arr, "")
    ssml_sum = "<speak>#{ssml_sum}</speak>"
    Map.put(struct, :ssml, ssml_sum)
  end
end
