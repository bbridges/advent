defmodule MemoryTwo do
  @count 16

  def get_loop(list), do: _get_loop Enum.zip(list, 0..@count - 1), [], 0

  defp _get_loop(list, prev, acc) do
    case Enum.find_index prev, &(&1 === list) do
      i when is_integer(i) -> i + 1
      nil ->
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

        _get_loop(updated, [list | prev], acc + 1)
    end
  end
end

IO.read(:stdio, :line)
|> String.split
|> Enum.map(&String.to_integer/1)
|> MemoryTwo.get_loop
|> IO.puts
