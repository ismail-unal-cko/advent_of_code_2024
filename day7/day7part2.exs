defmodule Day7Part2 do
  def parse_line(line) do
    [target | numbers] = String.split(line, ~r/[: ]+/, trim: true)
    {String.to_integer(target), Enum.map(numbers, &String.to_integer/1)}
  end

  def evaluate([], current_value), do: [current_value]

  def evaluate([next | rest], current_value) do
    with_add = evaluate(rest, current_value + next)
    with_mult = evaluate(rest, current_value * next)
    with_concat = evaluate(rest, String.to_integer("#{current_value}#{next}"))
    with_add ++ with_mult ++ with_concat
  end

  def valid?(target, numbers) do
    Enum.any?(evaluate(Enum.drop(numbers, 1), hd(numbers)), &(&1 == target))
  end

  def solve(input) do
    input
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {target, numbers} -> valid?(target, numbers) end)
    |> Enum.map(fn {target, _numbers} -> target end)
    |> Enum.sum()
  end
end

IO.puts(Day7Part2.solve("input.txt"))
