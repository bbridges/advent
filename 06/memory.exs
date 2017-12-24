defmodule Memory do
  @count 16

  def get_cycles(list), do: _get_cycles Enum.zip(list, 0..@count - 1), [], 0

  defp _get_cycles(list, prev, acc) do
    if list in prev do
      acc
    else
      {max, loc} = Enum.max_by list, fn {a, _} -> a end

      # How much everyone gets, and the extra left
      all = Integer.floor_div max, @count
      extra = Integer.mod max, @count

      # Taking all away from the max, adding `all` to each, then
      # `extra` in a cycle.
      updated = List.replace_at(list, loc, {0, loc})
      |> Enum.map(fn {a, i} -> {a + all, i} end)
      |> Enum.map(fn {a, i} -> 
        if Integer.mod(i - loc - 1, @count) < extra,
          do: {a + 1, i}, else: {a, i}
      end)

      _get_cycles(updated, [list | prev], acc + 1)
    end
  end
end

IO.read(:stdio, :line)
|> String.split
|> Enum.map(&String.to_integer/1)
|> Memory.get_cycles
|> IO.puts
