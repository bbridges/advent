defmodule PasswordTwo do
  def is_valid(pass) do
    sorted = String.split(pass, " ")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.sort/1)
    |> Enum.sort
    
    list_1 = Enum.drop sorted, 1
    list_2 = Enum.drop sorted, -1

    Enum.zip(list_1, list_2)
    |> Enum.all?(fn {a, b} -> a != b end)
  end
end

IO.read(:stdio, :all)
|> String.trim
|> String.split("\n")
|> Enum.count(&PasswordTwo.is_valid/1)
|> IO.puts
