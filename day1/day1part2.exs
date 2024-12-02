defmodule Day1Part2 do
  # Parse the input into two separate lists
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [left, right] -> {left, right} end) # Convert inner lists to tuples
    |> Enum.unzip() # Separate into left and right lists
  end

  # Calculate the similarity score for Part Two
  def calculate_similarity_score({left, right}) do
    # Create a frequency map for the right list
    frequency_map =
      Enum.reduce(right, %{}, fn num, acc ->
        Map.update(acc, num, 1, &(&1 + 1))
      end)

    # Calculate the similarity score
    Enum.reduce(left, 0, fn num, acc ->
      acc + num * Map.get(frequency_map, num, 0)
    end)
  end

  # Run Part Two
  def run(input) do
    {left, right} = parse_input(input)
    similarity_score = calculate_similarity_score({left, right})
    IO.puts("Similarity Score (Part 2): #{similarity_score}")
  end
end