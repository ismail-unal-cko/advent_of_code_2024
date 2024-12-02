defmodule Day1 do
    def parse_input(input) do
      # Split each line into left and right numbers
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(fn [left, right] -> {left, right} end) # Convert lists to tuples
      |> Enum.unzip() # Separate into two lists
    end
  
    def calculate_total_distance({left, right}) do
      left_sorted = Enum.sort(left)
      right_sorted = Enum.sort(right)
  
      Enum.zip(left_sorted, right_sorted)
      |> Enum.reduce(0, fn {l, r}, acc -> acc + abs(l - r) end)
    end
  
    def run(input) do
      {left, right} = parse_input(input)
      total_distance = calculate_total_distance({left, right})
      IO.puts("Total Distance: #{total_distance}")
    end
  end
  