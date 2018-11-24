defmodule Trampolines do
  def get_steps(map), do: _get_steps(map, Map.keys(map) |> length, 0, 0)

  defp _get_steps(_map, len, i, acc) when i < 0 or i >= len,
    do: acc

  defp _get_steps(map, len, i, acc) do
    {jump, updated} = Map.get_and_update!(map, i, &({&1, _inc(&1)}))

    _get_steps(updated, len, i + jump, acc + 1)
  end

  defp _inc(value) when value > 2, do: value - 1
  defp _inc(value),                do: value + 1

  def parse_input(input) do
    input
    |> String.trim
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.into(Map.new, fn {jump, i} -> {i, jump} end)
  end
end

IO.read(:stdio, :all)
|> Trampolines.parse_input
|> Trampolines.get_steps
|> IO.puts
