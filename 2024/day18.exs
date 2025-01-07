#!/usr/bin/env elixir

defmodule Parse do
  def get_inverted_graph(file_path, bytes) do
    get_inverted_graph(file_path)
    |> Enum.take(bytes)
  end

  def get_inverted_graph(file_path) do
    {:ok, content} = File.read(file_path)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end
end

defmodule Graph do
  @start {0, 0}
  @finish {70, 70}

  def min_steps(inverted_graph) do
    bfs(inverted_graph |> MapSet.new())
    |> Enum.take(-1)
    |> List.last()
    |> elem(2)
    |> Map.get(@finish)
  end

  def get_neighbours({row, col}, visited, inverted_graph, steps) do
    neighbours =
      [{row + 1, col}, {row - 1, col}, {row, col + 1}, {row, col - 1}]
      |> Enum.filter(fn {r, c} ->
        r >= 0 and r <= elem(@finish, 0) and
          c >= 0 and c <= elem(@finish, 1) and
          not MapSet.member?(inverted_graph, {r, c}) and
          not MapSet.member?(visited, {r, c})
      end)

    updated_steps =
      neighbours
      |> List.foldl(steps, fn x, steps ->
        steps |> Map.put(x, steps[{row, col}] + 1)
      end)

    {neighbours, updated_steps}
  end

  def bfs(inverted_graph) do
    queue = [@start]
    visited = MapSet.new([@start])
    steps = %{@start => 0}

    Stream.unfold({queue, visited, steps}, fn
      {[], _visited, _steps} ->
        nil

      {[head | tail], visited, steps} when head == @finish ->
        {
          {[head | tail], visited, steps},
          {[], MapSet.new(), %{@finish => steps[@finish]}}
          # 1 more emission and then terminate
        }

      {[head | tail], visited, steps} ->
        {neighbours, updated_steps} = get_neighbours(head, visited, inverted_graph, steps)

        updated_visited = Enum.reduce(neighbours, visited, fn x, acc -> MapSet.put(acc, x) end)

        {
          {[head | tail], visited, steps},
          {tail ++ neighbours, updated_visited, updated_steps}
        }
    end)
  end
end

defmodule Day18 do
  def part1(file_path, bytes) do
    inverted_graph = Parse.get_inverted_graph(file_path, bytes)
    Graph.min_steps(inverted_graph)
  end

  def part2(file_path, bytes) do
    inverted_graph = Parse.get_inverted_graph(file_path, bytes)

    case Graph.min_steps(inverted_graph) do
      nil ->
        {r, c} = inverted_graph |> Enum.at(bytes - 1)
        "#{r},#{c}"

      _ ->
        Day18.part2(file_path, bytes + 1)
    end
  end
end

bytes = 1024
file_path = "day18.txt"
IO.puts("part1: #{Day18.part1(file_path, bytes)}")
IO.puts("part2: #{Day18.part2(file_path, bytes)}")
