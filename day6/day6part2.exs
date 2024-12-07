defmodule Day6Part2 do
  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    Enum.with_index(lines)
    |> Enum.flat_map(fn {line, y} ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Enum.into(%{})
  end

  def move_guard({x, y}, direction) do
    case direction do
      :up -> {x, y - 1}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

  def turn_right(direction) do
    case direction do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  def patrol(map, position, direction, visited_states \\ MapSet.new()) do
    state = {position, direction}

    if MapSet.member?(visited_states, state) do
      :loop
    else
      visited_states = MapSet.put(visited_states, state)

      # Check if out of bounds
      if not Map.has_key?(map, position) do
        :exit
      else
        next_position = move_guard(position, direction)

        case Map.get(map, next_position) do
          "#" ->
            # Turn right
            new_direction = turn_right(direction)
            patrol(map, position, new_direction, visited_states)

          _ ->
            patrol(map, next_position, direction, visited_states)
        end
      end
    end
  end

  def find_valid_obstruction_positions(map, start_position, start_direction) do
    # Simulate patrol on original map
    original_result = patrol(map, start_position, start_direction)

    # Only proceed if the guard exits the map originally
    if original_result == :exit do
      empty_positions =
        Map.keys(map)
        |> Enum.filter(fn pos -> Map.get(map, pos) == "." and pos != start_position end)

      valid_positions =
        empty_positions
        |> Enum.filter(fn obstruction ->
          modified_map = Map.put(map, obstruction, "#")
          result = patrol(modified_map, start_position, start_direction)
          result == :loop
        end)

      length(valid_positions)
    else
      # Guard already loops; no obstruction will help
      0
    end
  end

  def run(file_path) do
    input = File.read!(file_path)
    map = parse_input(input)

    {start_position, start_direction} =
      Enum.find_value(map, fn {pos, char} ->
        case char do
          "^" -> {pos, :up}
          "v" -> {pos, :down}
          "<" -> {pos, :left}
          ">" -> {pos, :right}
          _ -> nil
        end
      end)

    find_valid_obstruction_positions(map, start_position, start_direction)
    |> IO.puts()
  end
end

# Run the program
Day6Part2.run("input.txt")
