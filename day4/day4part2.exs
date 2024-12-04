defmodule Day4Part2 do
  def run(file_path) do
    case File.read(file_path) do
      {:ok, input} ->
        grid = String.split(input, "\n", trim: true)
        result = count_xmas_patterns(grid)
        IO.puts("Result: #{result}")
        result

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

  def count_xmas_patterns(grid) do
    Enum.reduce(1..(length(grid) - 2), 0, fn i, acc ->
      Enum.reduce(1..(String.length(Enum.at(grid, 0)) - 2), acc, fn j, acc_inner ->
        if has_xmas_pattern?(grid, i, j) do
          acc_inner + 1
        else
          acc_inner
        end
      end)
    end)
  end

  defp has_xmas_pattern?(grid, i, j) do
    # Get grid size
    n = length(grid)
    m = String.length(Enum.at(grid, 0))

    # Ensure we're not on the border
    if i < 1 or i >= n - 1 or j < 1 or j >= m - 1 do
      false
    else
      # Check both diagonals
      diag1 = [
        char_at(grid, i - 1, j - 1),
        char_at(grid, i, j),
        char_at(grid, i + 1, j + 1)
      ]

      diag2 = [
        char_at(grid, i - 1, j + 1),
        char_at(grid, i, j),
        char_at(grid, i + 1, j - 1)
      ]

      diag1_matches?(diag1) and diag2_matches?(diag2)
    end
  end

  defp diag1_matches?([tl, center, br]) do
    center == "A" and
      (tl == "M" and br == "S" or tl == "S" and br == "M")
  end

  defp diag2_matches?([tr, center, bl]) do
    center == "A" and
      (tr == "M" and bl == "S" or tr == "S" and bl == "M")
  end

  defp char_at(grid, i, j) do
    String.at(Enum.at(grid, i), j)
  end
end

# Run the program
Day4Part2.run("input.txt")
