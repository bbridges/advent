defmodule Password do
  def is_valid(pass) do
    sorted = Enum.sort String.split(pass, " ")
    list_1 = Enum.drop sorted, 1
    list_2 = Enum.drop sorted, -1

    Enum.zip(list_1, list_2)
    |> Enum.all?(fn {a, b} -> a != b end)
  end
end

IO.read(:stdio, :all)
|> String.trim
|> String.split("\n")
|> Enum.count(&Password.is_valid/1)
|> IO.puts
