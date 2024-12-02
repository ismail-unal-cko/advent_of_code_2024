defmodule Day2Part2 do
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

  # Check if a report becomes safe after removing one level
  def becomes_safe_with_removal?(levels) do
    Enum.any?(0..(length(levels) - 1), fn index ->
      modified_levels = List.delete_at(levels, index)
      is_safe?(modified_levels)
    end)
  end

  # Analyze all reports and count the safe ones
  def count_safe_reports_with_dampener(reports) do
    Enum.count(reports, fn report ->
      is_safe?(report) or becomes_safe_with_removal?(report)
    end)
  end

  # Run the solution
  def run(input) do
    reports = parse_input(input)
    safe_count = count_safe_reports_with_dampener(reports)
    IO.puts("Number of safe reports with dampener: #{safe_count}")
  end
end
