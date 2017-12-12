defmodule Grid do
  def get_count(str) do
    # Trying three different coordinate systems and seeing which one
    # gives the shortest distance
    Enum.min([
      _get_count(str, fn
        "n"  -> { 1,  0}
        "ne" -> { 0,  1}
        "se" -> {-1,  1}
        "s"  -> {-1,  0}
        "sw" -> { 0, -1}
        "nw" -> { 1, -1}
      end),
      _get_count(str, fn
        "n"  -> { 0,  1}
        "ne" -> {-1,  1}
        "se" -> {-1,  0}
        "s"  -> { 0, -1}
        "sw" -> { 1, -1}
        "nw" -> { 1,  0}
      end),
      _get_count(str, fn
        "n"  -> { 1, -1}
        "ne" -> { 1,  0}
        "se" -> { 0,  1}
        "s"  -> {-1,  1}
        "sw" -> {-1,  0}
        "nw" -> { 0, -1}
      end)
    ])
  end

  defp _get_count(str, map) do
    # Splitting this by the commas
    String.split(str, ",")
    # Mapping the values in a 2D grid
    |> Enum.map(map)
    # Cancelling out the movements
    |> List.foldl({0, 0}, fn {a, b}, {c, d} -> {a + c, b + d} end)
    # Getting the manhattan distance
    |> (fn {a, b} -> abs(a) + abs(b) end).()
  end
end

IO.read(:stdio, :line)
|> String.trim
|> Grid.get_count
|> IO.puts
