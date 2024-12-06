defmodule Day5 do
  def run(file_path) do
    case File.read(file_path) do
      {:ok, input} ->
        {rules, updates} = parse_input(input)
        result = updates
                 |> Enum.filter(&valid_update?(&1, rules))
                 |> Enum.map(&middle_page/1)
                 |> Enum.sum()
        IO.puts("Result: #{result}")
        result

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
        :error
    end
  end

  defp parse_input(input) do
    [rules_section, updates_section] = String.split(input, "\n\n", trim: true)

    rules =
      rules_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        [x, y] = String.split(rule, "|")
        {String.to_integer(x), String.to_integer(y)}
      end)

    updates =
      updates_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn update ->
        update
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  defp valid_update?(update, rules) do
    Enum.all?(rules, fn {x, y} ->
      x_index = Enum.find_index(update, &(&1 == x))
      y_index = Enum.find_index(update, &(&1 == y))

      # If both x and y are in the update, x must appear before y
      if x_index && y_index, do: x_index < y_index, else: true
    end)
  end

  defp middle_page(update) do
    len = length(update)
    middle_index = div(len, 2)
    Enum.at(update, middle_index)
  end
end

# Run the program
Day5.run("input.txt")
