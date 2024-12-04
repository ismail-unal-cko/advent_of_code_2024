defmodule Day3Part2 do
    def parse_and_sum(input) do
    if is_binary(input) do
      regex = ~r/(?:mul\((\d+),(\d+)\))|(do\(\)|don't\(\))/

      input
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.scan(regex, &1))
      |> List.flatten()
      |> IO.inspect(label: "After Regex")
      |> Enum.map(fn
        [match | _] ->  # Match the first element (a list) and ignore the rest
          case match do
            ["mul(" <> _, x, y] -> {"mul", String.to_integer(x), String.to_integer(y)}
            [instr] -> {instr, 0, 0}
          end
      end)
      |> Enum.reduce({true, 0}, fn
        {"mul", x, y}, {enabled, sum} ->
          new_sum = if enabled, do: sum + x * y, else: sum
          IO.puts("Multiplying #{x} * #{y}, enabled: #{enabled}, sum: #{new_sum}")
          {enabled, new_sum}

        {"do()", _, _}, {_, sum} ->
          IO.puts("Enabling mul")
          {true, sum}

        {"don't()", _, _}, {_, sum} ->
          IO.puts("Disabling mul")
          {false, sum}

        other, acc ->
          IO.inspect(other, label: "Unmatched Input")
          acc
      end)
      |> elem(1)
    else
      raise ArgumentError, "Input must be a binary string"
    end
  end

  def run(file_path) do
    case File.read(file_path) do
      {:ok, input} ->
        result = parse_and_sum(input)
        IO.puts("Result: #{result}")
        result

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
        :error
    end
  end
end

# Run the program
Day3Part2.run("input.txt")