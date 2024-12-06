defmodule Day6 do
  def run(file_path) do
    map = parse_map(file_path)
    {guard_pos, direction} = find_guard(map)
    max_x = length(Enum.at(map, 0))
    max_y = length(map)

    patrol(map, guard_pos, direction, max_x, max_y, MapSet.new())
    |> MapSet.size()
  end

  defp parse_map(file_path) do
    File.read!(file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp find_guard(map) do
    Enum.with_index(map)
    |> Enum.reduce_while(nil, fn {row, y}, _ ->
      case Enum.find_index(row, &(&1 in ["^", ">", "v", "<"])) do
        nil -> {:cont, nil}
        x -> {:halt, {{x, y}, direction_from_char(Enum.at(row, x))}}
      end
    end)
  end

  defp direction_from_char("^"), do: {0, -1}
  defp direction_from_char(">"), do: {1, 0}
  defp direction_from_char("v"), do: {0, 1}
  defp direction_from_char("<"), do: {-1, 0}

  defp patrol(map, {x, y}, direction, max_x, max_y, visited) do
    if x < 0 or y < 0 or x >= max_x or y >= max_y do
      visited
    else
      next_pos = {x + elem(direction, 0), y + elem(direction, 1)}

      case get_cell(map, next_pos) do
        "#" ->
          new_direction = turn_right(direction)
          patrol(map, {x, y}, new_direction, max_x, max_y, visited)

        _ ->
          patrol(map, next_pos, direction, max_x, max_y, MapSet.put(visited, {x, y}))
      end
    end
  end

  defp get_cell(map, {x, y}) do
    if y < 0 or y >= length(map) or x < 0 or x >= length(Enum.at(map, 0)) do
      nil
    else
      Enum.at(Enum.at(map, y), x)
    end
  end

  defp turn_right({0, -1}), do: {1, 0}  # Up to Right
  defp turn_right({1, 0}), do: {0, 1}   # Right to Down
  defp turn_right({0, 1}), do: {-1, 0}  # Down to Left
  defp turn_right({-1, 0}), do: {0, -1} # Left to Up
end

# Example usage:
# Save the input as "input.txt" and run:
IO.inspect(Day6.run("input.txt"))
