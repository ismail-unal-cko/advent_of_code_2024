defmodule Day2 do
  # Parse the input into a list of lists of integers
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # Check if a report is safe
  def is_safe?(levels) do
    differences = calculate_differences(levels)

    # Validate both conditions: consistent and valid differences
    valid_differences?(differences) and consistent_values?(differences)
  end

  # Calculate the differences between adjacent levels
  def calculate_differences(levels) do
    Enum.chunk_every(levels, 2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  # Check if all differences are within the range [1, 3]
  def valid_differences?(differences) do
    Enum.all?(differences, fn diff -> abs(diff) in 1..3 end)
  end

  # Check if the sequence is consistently increasing or decreasing
  def consistent_values?(differences) do
    Enum.all?(differences, &(&1 > 0)) or Enum.all?(differences, &(&1 < 0))
  end

  # Count the number of safe reports
  def count_safe_reports(reports) do
    Enum.count(reports, &is_safe?/1)
  end

  # Run the solution
  def run(input) do
    reports = parse_input(input)
    safe_count = count_safe_reports(reports)
    IO.puts("Number of safe reports: #{safe_count}")
  end
end
