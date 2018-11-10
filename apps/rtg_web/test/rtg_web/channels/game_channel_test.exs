defmodule RtgWeb.GameChannelTest do
  use RtgWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      RtgWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(RtgWeb.GameChannel, "game:lobby")

    {:ok, socket: socket}
  end
end
