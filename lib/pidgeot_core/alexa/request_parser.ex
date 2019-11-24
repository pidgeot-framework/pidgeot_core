defmodule PidgeotCore.Alexa.RequestParser do
  def request(%{"request" => request}), do: request
  def request(_), do: %{}

  def request_type(json) do
    json
    |> request()
    |> type_from_request()
  end

  def intent_name(json) do
    json
    |> request()
    |> intent_from_request()
    |> name_from_intent()
  end

  defp intent_from_request(%{"intent" => intent}), do: intent
  defp intent_from_request(_), do: %{}

  defp name_from_intent(%{"name" => name}), do: name
  defp name_from_intent(_), do: ""

  defp type_from_request(%{"type" => type}), do: type
  defp type_from_request(_), do: ""
end
