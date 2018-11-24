defmodule VirusTwo do
  def count_infections(input) do
    input
    |> _parse_input
    |> _count_infections
  end

  defp _count_infections(states),
    do: _count_infections states, 10000000, {0, 0}, 0, 0, 0

  defp _count_infections(_, limit, _, _, bursts, count)
  when limit === bursts, do: count

  defp _count_infections(states, limit, pos, direction, bursts, count) do
    state = Map.get states, pos, :clean

    # Go left, forward, right, back when clean, weakened, infected,
    # flagged, respectively
    add_dir = case state do
      :clean    -> -1
      :weakened ->  0
      :infected ->  1
      :flagged  ->  2
    end

    direction = Integer.mod(direction + add_dir, 4)

    # Cycle the node order: clean -> weakened -> infected -> flagged
    # -> clean -> ...
    {states, count} = case state do
      :clean    -> {Map.put_new(states, pos, :weakened), count}
      :weakened -> {Map.replace!(states, pos, :infected), count + 1}
      :infected -> {Map.replace!(states, pos, :flagged), count}
      :flagged  -> {Map.delete(states, pos), count}
    end

    # Updating the position
    {x, y} = pos

    pos = case direction do
      0 -> {x, y + 1}
      1 -> {x + 1, y}
      2 -> {x, y - 1}
      3 -> {x - 1, y}
    end

    _count_infections states, limit, pos, direction, bursts + 1, count
  end

  defp _parse_input(input) do
    split = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    
    height = length split
    width = length Enum.at(split, 0)

    # Splitting this into a map of keys {x, y} coordinates with the
    # center being {0, 0} with them being set to infected
    split
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index
    |> Enum.map(fn {list, row} ->
      list
      |> Enum.filter(fn {state, _} -> state === ?# end)
      |> Enum.map(fn {_, col} -> 
        {col - Integer.floor_div(width, 2), Integer.floor_div(height, 2) - row}
      end)
    end)
    |> List.flatten
    |> Enum.reduce(Map.new, fn coords, map -> 
      Map.put_new map, coords, :infected
    end)
  end
end

IO.read(:stdio, :all)
|> VirusTwo.count_infections
|> IO.inspect
