defmodule Day4 do
  def count_xmas(grid) do
    # Convert the grid into a list of lists for easier indexing
    grid = Enum.map(grid, &String.graphemes/1)

    # Get grid dimensions
    rows = length(grid)
    cols = length(List.first(grid))

    # Define all directions as row and column offsets
    directions = [
      {0, 1},   # Right
      {0, -1},  # Left
      {1, 0},   # Down
      {-1, 0},  # Up
      {1, 1},   # Down-right
      {-1, -1}, # Up-left
      {1, -1},  # Down-left
      {-1, 1}   # Up-right
    ]

    # Traverse the grid and count occurrences in all directions
    Enum.reduce(0..(rows - 1), 0, fn row, acc ->
      Enum.reduce(0..(cols - 1), acc, fn col, acc_inner ->
        count = count_xmas_at(grid, rows, cols, row, col, directions)
        IO.inspect({row, col, count}, label: "Count at position")
        acc_inner + count
      end)
    end)
  end

  defp count_xmas_at(grid, rows, cols, row, col, directions) do
    Enum.reduce(directions, 0, fn {dx, dy}, acc ->
      acc + if matches_xmas?(grid, rows, cols, row, col, dx, dy), do: 1, else: 0
    end)
  end

  defp matches_xmas?(grid, rows, cols, row, col, dx, dy) do
    # Check if "XMAS" fits in the given direction
    Enum.reduce_while(0..3, true, fn i, _ ->
      x = row + i * dx
      y = col + i * dy

      cond do
        x < 0 or x >= rows -> {:halt, false}
        y < 0 or y >= cols -> {:halt, false}
        Enum.at(grid, x) |> Enum.at(y) != String.at("XMAS", i) -> {:halt, false}
        true -> {:cont, true}
      end
    end)
  end

  def run(input) do
    # Split the input into lines to form the grid
    grid = String.split(input, "\n", trim: true)
    IO.inspect(grid, label: "Parsed Grid")
    count_xmas(grid)
  end
end

# Read the input from the file and pass it to the function
case File.read("input.txt") do
  {:ok, input} ->
    IO.puts("Input successfully read!")
    result = Day4.run(input)
    IO.puts("Result: #{result}")

  {:error, reason} ->
    IO.puts("Failed to read file: #{reason}")
end
