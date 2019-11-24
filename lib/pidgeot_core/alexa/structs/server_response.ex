defmodule PidgeotCore.Alexa.Structs.ServerResponse do
  alias PidgeotCore.Alexa.Structs.Reprompt
  alias PidgeotCore.Alexa.Structs.OutputSpeech

  defstruct version: "1.0",
            sessionAttributes: %{},
            response: %{}

  def get(struct, []), do: struct
  def get(struct, [key | rest]) do
    case Map.fetch(struct, key) do
      :error -> nil
      {:ok, descendant_struct} -> get(descendant_struct, rest)
    end
  end


  def set(struct, [key | []], value), do: Map.put(struct, key, value)
  def set(struct, [key | rest], value) do
    descendant_struct = struct
                        |> Map.fetch(key)
                        |> validate_struct(key)

    value = set(descendant_struct, rest, value)
    Map.put(struct, key, value)
  end

  defp validate_struct(thing, key) do
    case thing do
      {:ok, %_{} = struct} -> struct
      {:ok, %{} = map} when map != %{} -> map
      _ -> case key do
            :outputSpeech -> %OutputSpeech{}
            :reprompt -> %Reprompt{}
            _ -> %{}
            end
    end
  end
end
