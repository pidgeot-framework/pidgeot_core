defmodule PidgeotCore.Alexa.Structs do
  defmodule OutputSpeech do
    defstruct type: "SSML",
              ssml: "<speak></speak>",
              playBehaviour: "ENQUEUE"
  end

  defmodule Reprompt do
    defstruct outputSpeech: %OutputSpeech{}
  end

  defmodule Response do
    defstruct outputSpeech: %OutputSpeech{},
              reprompt: %Reprompt{},
              shouldEndSession: false
  end

  defmodule ServerResponse do
    defstruct version: "1.0",
              sessionAttributes: %{},
              response: %{}
  end
end
