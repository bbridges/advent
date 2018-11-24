defmodule FractalTwo do
  @start [
    [false, true,  false],
    [false, false, true ],
    [true,  true,  true ]
  ]

  def count_on_pixels(input, iter) do
    input
    |> _parse_input
    |> _count_on_pixels(iter)
  end

  defp _count_on_pixels(rules, iter),
    do: _count_on_pixels rules, iter, 0, @start

  defp _count_on_pixels(_rules, iter, step, pixels) when iter === step do 
    pixels
    |> List.flatten
    |> Enum.count(&(&1 === true))
  end

  defp _count_on_pixels(rules, iter, step, pixels) do
    pixels = pixels
    |> _expand_pixels
    |> Enum.map(&Enum.map(&1, fn square -> Map.fetch! rules, square end))
    |> _compact_pixels

    _count_on_pixels rules, iter, step + 1, pixels
  end

  defp _expand_pixels(pixels) do
    dim = length pixels

    {split_size, split_count} = cond do
      rem(dim, 2) === 0 -> {2, div(dim, 2)}
      rem(dim, 3) === 0 -> {3, div(dim, 3)}
    end

    pixels
    |> Enum.chunk_every(split_size)
    |> Enum.map(fn split_rows ->
      0..split_count - 1
      |> Enum.map(fn i -> 
        Enum.map(split_rows, fn row ->
          Enum.slice(row, i * split_size, split_size)
        end)
      end)
    end)
  end

  defp _compact_pixels(expanded) do
    expanded
    |> Enum.flat_map(fn chunk ->
      chunk
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.flatten/1)
    end)
  end

  defp _parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " => "))
    |> Enum.reduce(Map.new, fn [rule, output], map ->
      convert = fn str -> 
        str
        |> String.split("/")
        |> Enum.map(&String.to_charlist/1)
        |> Enum.map(&Enum.map(&1, fn char -> char === ?# end))
      end

      rule_1 = convert.(rule)
      rule_2 = _rotate(rule_1)
      rule_3 = _rotate(rule_2)
      rule_4 = _rotate(rule_3)

      rule_5 = _flip(rule_1)
      rule_6 = _rotate(rule_5)
      rule_7 = _rotate(rule_6)
      rule_8 = _rotate(rule_7)

      output = convert.(output)

      map
      |> Map.put_new(rule_1, output)
      |> Map.put_new(rule_2, output)
      |> Map.put_new(rule_3, output)
      |> Map.put_new(rule_4, output)
      |> Map.put_new(rule_5, output)
      |> Map.put_new(rule_6, output)
      |> Map.put_new(rule_7, output)
      |> Map.put_new(rule_8, output)
    end)
  end

  defp _rotate([[a, b], [c, d]]),
    do: [[c, a], [d, b]]
  defp _rotate([[a, b, c], [d, e, f], [g, h, i]]),
    do: [[g, d, a], [h, e, b], [i, f, c]]

  defp _flip(pixels), do: pixels |> Enum.map(&Enum.reverse/1)
end

IO.read(:stdio, :all)
|> FractalTwo.count_on_pixels(18)
|> IO.inspect
