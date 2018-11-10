defmodule RtgWeb.Js.Macro do
  @moduledoc false

  def module_to_map({:__aliases__, line, module_name}, behaviour) do
    functions =
      for {fun_name, arg_names} <- behaviour,
          do: {fun_name, wrap_into_fn(line, module_name, fun_name, arg_names)}

    {:%{}, line, [{:module, module_name} | functions]}
  end

  defp wrap_into_fn(line, module_name, fun_name, arg_names) do
    args = Enum.map(arg_names, &{&1, line, __MODULE__})

    {:fn, line,
     [
       {:->, line,
        [args, {{:., line, [{:__aliases__, [alias: false], module_name}, fun_name]}, line, args}]}
     ]}
  end
end
