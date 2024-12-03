defmodule Day3 do
  def parse_and_sum(input) do
    # Check if input is a binary string
    if is_binary(input) do
      # Define the regex to capture mul(X,Y)
      regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/

      # Extract matches, calculate products, and sum them
      Regex.scan(regex, input)
      |> Enum.map(fn [_, x, y] -> String.to_integer(x) * String.to_integer(y) end)
      |> Enum.sum()
    else
      # Raise error if input is not binary
      raise ArgumentError, "Input must be a binary string"
    end
  end

  def run(input) do
    parse_and_sum(input)
  end
end

# Read the input from the file and pass it to the function
case File.read("input.txt") do
  {:ok, input} ->
    result = Day3.run(input)
    IO.puts("Result: #{result}")

  {:error, reason} ->
    IO.puts("Failed to read file: #{reason}")
end
