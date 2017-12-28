defmodule Moat do
  def strongest_bridge(input) do
    input
    |> _parse_input
    |> _strongest_combo
    |> _get_strength
  end

  defp _strongest_combo(list), do: Enum.reverse(_strongest_combo list, 0, [])

  defp _strongest_combo(list, from, built) do
    candidates = list
    |> Enum.filter(&_has_num(&1, from))

    if length(candidates) === 0 do
      built
    else
      candidates
      # Filtering the candidates out of the lists
      |> Enum.map(fn pair ->
        filtered = list
        |> Enum.reject(&(&1 === pair))

        other = pair
        |> _remove_num(from)

        _strongest_combo filtered, other, [pair | built]
      end)
      |> Enum.max_by(&_get_strength/1)
    end
  end

  defp _has_num(pair, num) do
    case pair do
      {^num, _} -> true
      {_, ^num} -> true
      _         -> false
    end
  end

  defp _remove_num(pair, num) do
    case pair do
      {^num, other} -> other
      {other, ^num} -> other
    end
  end

  defp _get_strength(bridge) do
    bridge
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten
    |> Enum.sum
  end

  defp _parse_input(input) do
    # Making the input into a list of tuples
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "/"))
    |> Enum.map(fn [left, right] ->
      {String.to_integer(left), String.to_integer(right)}
    end)
  end
end

IO.read(:stdio, :all)
|> Moat.strongest_bridge
|> IO.inspect
