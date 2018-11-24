IO.read(:stdio, :line)
# Making the string just a list of chars
|> String.trim
|> String.to_charlist
# Making a zip with the original list and one shifted to the right
|> (&(Enum.zip(&1, List.delete_at(&1, 0) ++ [List.first(&1)]))).()
# Returning the integer value if the next is the same
|> Enum.map(fn {a, b} -> if a == b, do: a - ?0, else: 0 end)
# Summing it up
|> List.foldl(0, &(&1 + &2))
|> IO.puts
