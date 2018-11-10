defmodule RtgWeb.MatchingChannelTest do
  use RtgWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      RtgWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(RtgWeb.MatchingChannel, "matching:lobby")

    {:ok, socket: socket}
  end
end
