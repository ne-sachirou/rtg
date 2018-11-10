// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js

import "@babel/polyfill";
import "../priv/elixir_script/build/ElixirScript.Core.js";
import RtgWeb from "../priv/elixir_script/build/Elixir.RtgWeb.Js.js";

Phoenix.Socket.create = function(path, params) {
  return new Phoenix.Socket(path, params);
};

RtgWeb.main();
