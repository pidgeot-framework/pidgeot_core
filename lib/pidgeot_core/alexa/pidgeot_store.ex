defmodule PidgeotCore.Alexa.PidgeotStore do
  import Plug.Conn
  alias PidgeotCore.Alexa.Structs.ServerResponse
  alias PidgeotCore.Alexa.PidgeotStore

  defstruct server_response: %ServerResponse{},
            ssml: [],
            reprompt_ssml: []

  def init(conn) do
    put_private(conn, :__PIDGEOT__, %PidgeotStore{})
  end

  def fetch(%PidgeotStore{} = store, key), do: Map.fetch!(store, key)
  def fetch(conn, key) do
    store = conn.private[:__PIDGEOT__]
    fetch(store, key)
  end

  def append(conn, key, value) when key != :server_response do
    store = conn.private[:__PIDGEOT__]
    old = fetch(store, key)
    new  = old ++ [value]
    replace(conn, store, key, new)
  end

  def replace(conn, %PidgeotStore{} = store, key, value) do
    new_store = Map.put(store, key, value)
    put_private(conn, :__PIDGEOT__, new_store)
  end
  def replace(conn, key, value) do
    store = conn.private[:__PIDGEOT__]
    replace(conn, store, key, value)
  end
end
