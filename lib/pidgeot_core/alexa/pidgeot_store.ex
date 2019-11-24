defmodule PidgeotCore.Alexa.PidgeotStore do
  import Plug.Conn
  alias PidgeotCore.Alexa.Structs.ServerResponse
  alias PidgeotCore.Alexa.PidgeotStore

  defstruct server_response: %ServerResponse{}

  def init(conn) do
    put_private(conn, :__PIDGEOT__, %PidgeotStore{})
  end
  def load_response(conn) do
    store = conn.private[:__PIDGEOT__]
    Map.fetch!(store, :server_response)
  end
  def save_response(conn, value) do
    store = conn.private[:__PIDGEOT__]
    new_store = Map.put(store, :server_response, value)
    put_private(conn, :__PIDGEOT__, new_store)
  end
end
