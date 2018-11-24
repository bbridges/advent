defmodule MoatTwo do
  def longest_bridge_strength(input) do
    input
    |> _parse_input
    |> _longest_combo
    |> _get_strength
  end

  defp _longest_combo(list), do: Enum.reverse(_longest_combo list, 0, [])

  defp _longest_combo(list, from, built) do
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

        _longest_combo filtered, other, [pair | built]
      end)
      |> Enum.reduce(fn a, b ->
        len_a = length a
        len_b = length b

        cond do
          len_a - len_b > 0                   -> a
          len_a - len_b < 0                   -> b
          _get_strength(a) > _get_strength(b) -> a
          true                                -> b
        end
      end)
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
|> MoatTwo.longest_bridge_strength
|> IO.inspect
