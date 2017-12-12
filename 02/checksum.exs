IO.read(:stdio, :all)
|> String.trim
|> String.split("\n")
|> Enum.map(fn s -> Enum.map(String.split(s), &Integer.parse/1) end)
|> Enum.map(fn s -> Enum.map(s, fn {int, _} -> int end) end)
|> Enum.map(&(Enum.max(&1) - Enum.min(&1)))
|> List.foldl(0, &(&1 + &2))
|> IO.inspect
