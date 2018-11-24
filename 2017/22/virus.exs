defmodule Virus do
  def count_infections(input) do
    input
    |> _parse_input
    |> _count_infections
  end

  defp _count_infections(infected),
    do: _count_infections infected, 10000, {0, 0}, 0, 0, 0

  defp _count_infections(_, limit, _, _, bursts, count)
  when limit === bursts, do: count

  defp _count_infections(infected, limit, pos, direction, bursts, count) do
    is_infected = pos in infected

    # Turn to the right when the current node is infected, otherwise,
    # turn left
    direction = Integer.mod(direction + (if is_infected, do: 1, else: -1), 4)

    # If the node is infected, clean it, otherwise, do the opposite
    {infected, count} = if is_infected do
      {infected -- [pos], count}
    else
      {infected ++ [pos], count + 1}
    end

    # Updating the position
    {x, y} = pos

    pos = case direction do
      0 -> {x, y + 1}
      1 -> {x + 1, y}
      2 -> {x, y - 1}
      3 -> {x - 1, y}
    end

    _count_infections infected, limit, pos, direction, bursts + 1, count
  end

  defp _parse_input(input) do
    split = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    
    height = length split
    width = length Enum.at(split, 0)

    # Splitting this into a list of {x, y} coordinates with the
    # center being {0, 0}
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
  end
end

IO.read(:stdio, :all)
|> Virus.count_infections
|> IO.inspect
