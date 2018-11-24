defmodule Turing do
  defmodule State do
    defstruct [
      :zero_write,
      :zero_dir,
      :zero_next,
      :one_write,
      :one_dir,
      :one_next
    ] 
  end

  def get_checksum(input) do
    input
    |> _parse_input
    |> _run
  end

  defp _parse_input(input) do
    [start_str, steps_str, states_str] = String.split input, "\n", parts: 3

    %{
      start: _parse_start(start_str),
      steps: _parse_steps(steps_str),
      states: _parse_states(states_str)
    }
  end

  defp _parse_start(input) do
    input
    |> String.split(" ")
    |> List.last
    |> String.replace(".", "")
  end

  defp _parse_steps(input) do
    input
    |> String.split(" ")
    |> Enum.at(5)
    |> String.to_integer
  end

  defp _parse_states(input) do
    input
    # Splitting on the "In state" strings
    |> String.split("\nIn state ", trim: true)
    # Spitting each of those by line
    |> Enum.map(&String.split(&1, "\n", trim: true))
    # Getting the last entry on each state line (without a period or
    # colon)
    |> Enum.map(fn list ->
      Enum.map(list, fn str ->
        str
        |> String.split(" ")
        |> List.last
        |> String.replace(".", "")
        |> String.replace(":", "")
      end)
    end)
    # Using the last entries to construct the states in a map
    |> List.foldl(Map.new, fn list, acc -> 
      [name, _, zero_write_str, zero_dir_str, zero_next, _, one_write_str,
          one_dir_str, one_next] = list

      parse_dir = fn dir -> if dir === "right", do: 1, else: -1 end

      acc
      |> Map.put_new(name, %State{
        zero_write: String.to_integer(zero_write_str),
        zero_dir:   parse_dir.(zero_dir_str),
        zero_next:  zero_next,
        one_write:  String.to_integer(one_write_str),
        one_dir:    parse_dir.(one_dir_str),
        one_next:   one_next
      })
    end)
  end

  defp _run(map), do: _run map.states, map.start, 0, [], map.steps, 0

  defp _run(states, curr_state, cursor, active, limit, steps) do
    cond do
      # If we're done, just count how many slots are 1
      steps === limit ->
        length active

      # This is when our cursor is on a 1
      cursor in active ->
        _run(
          states,
          # Going to the next state for 1
          states[curr_state].one_next,
          # Going left or right
          cursor + states[curr_state].one_dir,
          # If we're writing a 0, then remove it from active
          active -- (
            if states[curr_state].one_write === 0, do: [cursor], else: []
          ),
          limit,
          # Increment our step
          steps + 1
        )

      # When the cursor is on a 0
      true ->
        _run(
          states,
          # Going to the next state for 0
          states[curr_state].zero_next,
          # Going left or right
          cursor + states[curr_state].zero_dir,
          # If we're writing a 1, then add the cursor to active
          active ++ (
            if states[curr_state].zero_write === 1, do: [cursor], else: []
          ),
          limit,
          # Increment our step
          steps + 1
        )
    end
  end
end

IO.read(:stdio, :all)
|> Turing.get_checksum
|> IO.inspect
