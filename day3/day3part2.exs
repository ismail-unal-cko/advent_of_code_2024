defmodule Day3Part2 do
    def parse_and_sum(input) do
    Regex.scan(~r/mul\(\d+,\d+\)|do[n't]*\(\)/, input)
|> Enum.reduce({true, 0}, fn [instruction], {do_flag, acc} ->
  case {do_flag, instruction} do
    {_, "do()"} -> {true, acc}
    {_, "don't()"} -> {false, acc}
    {true, mul} ->
      product =
        Regex.scan(~r/\d+/, mul)
        |> Enum.map(fn [str] ->
          String.to_integer(str)
        end)
        |> Enum.product()

      {true, acc + product}
    _ ->
      {do_flag, acc}
  end
end)
|> elem(1)

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