defmodule Tower do
  def get_base(list), do: _get_base list, List.first(list)

  defp _get_base(list, {curr, _}) do
    case Enum.find list, fn {_, above} -> curr in above end do
      nil   -> curr
      below -> _get_base list, below
    end
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.map(fn
      # This is when there's nothing above
      [left] ->
        {String.split(left, " ") |> List.first, []}
      # Otherwise we should have this
      [left, right] ->
        {String.split(left, " ") |> List.first, String.split(right, ", ")}
    end)
  end
end

IO.read(:stdio, :all)
|> Tower.parse_input
|> Tower.get_base
|> IO.inspect
