defmodule Day5Part2 do
  def parse_input(input) do
    [rules_section, updates_section] = String.split(input, "\n\n", trim: true)

    rules =
      rules_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        [a, b] = String.split(rule, "|")
        {String.to_integer(a), String.to_integer(b)}
      end)

    updates =
      updates_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn update ->
        update |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  def valid_order?(update, rules) do
    Enum.all?(rules, fn {x, y} ->
      ix = Enum.find_index(update, &(&1 == x))
      iy = Enum.find_index(update, &(&1 == y))
      ix == nil || iy == nil || ix < iy
    end)
  end

  def reorder(update, rules) do
    graph = build_graph(update, rules)
    topological_sort(graph)
  end

  defp build_graph(update, rules) do
    update
    |> Enum.reduce(%{}, fn page, acc ->
      Map.put(acc, page, [])
    end)
    |> Map.merge(
      Enum.reduce(rules, %{}, fn {x, y}, acc ->
        if x in update and y in update do
          Map.update(acc, x, [y], &[y | &1])
        else
          acc
        end
      end)
    )
  end

  defp topological_sort(graph) do
    graph
    |> Map.keys()
    |> Enum.reduce({[], Map.new(graph, fn {k, _v} -> {k, false} end)}, fn node, {sorted, visited} ->
      if visited[node] do
        {sorted, visited}
      else
        dfs(graph, node, sorted, visited)
      end
    end)
    |> elem(0)
  end

  defp dfs(graph, node, sorted, visited) do
    neighbors = Map.get(graph, node, [])

    {sorted, visited} =
      Enum.reduce(neighbors, {sorted, visited}, fn neighbor, {sorted_acc, visited_acc} ->
        if visited_acc[neighbor] do
          {sorted_acc, visited_acc}
        else
          dfs(graph, neighbor, sorted_acc, visited_acc)
        end
      end)

    {[node | sorted], Map.put(visited, node, true)}
  end

  def middle_number(update) do
    Enum.at(update, div(length(update), 2))
  end

  def run(file_path) do
    case File.read(file_path) do
      {:ok, input} ->
        {rules, updates} = parse_input(input)

        incorrectly_ordered_updates =
          updates
          |> Enum.reject(&valid_order?(&1, rules))

        reordered_updates =
          incorrectly_ordered_updates
          |> Enum.map(&reorder(&1, rules))

        result =
          reordered_updates
          |> Enum.map(&middle_number/1)
          |> Enum.sum()

        IO.puts("Result: #{result}")
        result

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
        :error
    end
  end
end

# Run the solution
Day5Part2.run("input.txt")