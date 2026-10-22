~S"""
Brute Force

defmodule Solution do
  @spec get_food(grid :: [[char]]) :: integer
  def get_food(grid) do
    g = grid |> Enum.map(fn row -> row |> Enum.map(&to_c/1) |> List.to_tuple() end) |> List.to_tuple()
    m = tuple_size(g)
    n = tuple_size(elem(g, 0))

    best =
      for r <- 0..(m - 1), c <- 0..(n - 1), cell(g, r, c) == ?*, reduce: :infinity do
        acc -> min(acc, dfs(g, m, n, r, c, 0, MapSet.new()))
      end

    if best == :infinity, do: -1, else: best
  end

  defp dfs(_g, m, n, r, c, _steps, _seen) when r < 0 or c < 0 or r >= m or c >= n, do: :infinity

  defp dfs(g, m, n, r, c, steps, seen) do
    ch = cell(g, r, c)

    cond do
      ch == ?X or MapSet.member?(seen, {r, c}) ->
        :infinity

      ch == ?# ->
        steps

      true ->
        seen = MapSet.put(seen, {r, c})

        [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
        |> Enum.map(fn {dr, dc} -> dfs(g, m, n, r + dr, c + dc, steps + 1, seen) end)
        |> Enum.min()
    end
  end

  defp cell(g, r, c), do: g |> elem(r) |> elem(c)

  defp to_c(c) when is_integer(c), do: c
  defp to_c(<<c>>), do: c
end
"""

~S"""
Basic Approach

defmodule Solution do
  @spec get_food(grid :: [[char]]) :: integer
  def get_food(grid) do
    g = grid |> Enum.map(fn row -> row |> Enum.map(&to_c/1) |> List.to_tuple() end) |> List.to_tuple()
    m = tuple_size(g)
    n = tuple_size(elem(g, 0))
    start = for r <- 0..(m - 1), c <- 0..(n - 1), cell(g, r, c) == ?*, do: {r, c}
    bfs(g, m, n, start, MapSet.new(start), 0)
  end

  defp bfs(_g, _m, _n, [], _visited, _steps), do: -1

  defp bfs(g, m, n, queue, visited, steps) do
    if Enum.any?(queue, fn {r, c} -> cell(g, r, c) == ?# end) do
      steps
    else
      {next, visited} =
        for {r0, c0} <- queue, {dr, dc} <- [{1, 0}, {-1, 0}, {0, 1}, {0, -1}], reduce: {[], visited} do
          {nx, v} ->
            r = r0 + dr
            c = c0 + dc

            if r >= 0 and c >= 0 and r < m and c < n and not MapSet.member?(v, {r, c}) and
                 cell(g, r, c) != ?X do
              {[{r, c} | nx], MapSet.put(v, {r, c})}
            else
              {nx, v}
            end
        end

      bfs(g, m, n, next, visited, steps + 1)
    end
  end

  defp cell(g, r, c), do: g |> elem(r) |> elem(c)

  defp to_c(c) when is_integer(c), do: c
  defp to_c(<<c>>), do: c
end
"""

defmodule Solution do
  @spec get_food(grid :: [[char]]) :: integer
  def get_food(grid) do
    m = length(grid)
    n = length(hd(grid))
    cells = :atomics.new(m * n, [])

    case load(Enum.concat(grid), cells, 0, -1) do
      -1 ->
        -1

      start ->
        q = :atomics.new(m * n, [])
        :atomics.put(q, 1, start)
        level(cells, q, m, n, 0, 1, 1)
    end
  end

  defp load([], _cells, _i, start), do: start

  defp load([ch | rest], cells, i, start) do
    c = to_c(ch)
    :atomics.put(cells, i + 1, c)
    load(rest, cells, i + 1, if(c == ?*, do: i, else: start))
  end

  defp to_c(c) when is_integer(c), do: c
  defp to_c(<<c>>), do: c

  defp level(_cells, _q, _m, _n, head, tail, _steps) when head >= tail, do: -1

  defp level(cells, q, m, n, head, tail, steps) do
    case drain(cells, q, m, n, head, tail, tail, steps) do
      {:found, s} -> s
      new_tail -> level(cells, q, m, n, tail, new_tail, steps + 1)
    end
  end

  defp drain(_cells, _q, _m, _n, pos, level_end, tail, _steps) when pos >= level_end, do: tail

  defp drain(cells, q, m, n, pos, level_end, tail, steps) do
    id = :atomics.get(q, pos + 1)
    r = div(id, n)
    c = rem(id, n)

    case visit([{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}], cells, q, m, n, tail, steps) do
      {:found, s} -> {:found, s}
      new_tail -> drain(cells, q, m, n, pos + 1, level_end, new_tail, steps)
    end
  end

  defp visit([], _cells, _q, _m, _n, tail, _steps), do: tail

  defp visit([{r, c} | rest], cells, q, m, n, tail, steps)
       when r >= 0 and c >= 0 and r < m and c < n do
    id = r * n + c

    case :atomics.get(cells, id + 1) do
      ?# ->
        {:found, steps}

      ?O ->
        :atomics.put(cells, id + 1, ?X)
        :atomics.put(q, tail + 1, id)
        visit(rest, cells, q, m, n, tail + 1, steps)

      _ ->
        visit(rest, cells, q, m, n, tail, steps)
    end
  end

  defp visit([_ | rest], cells, q, m, n, tail, steps),
    do: visit(rest, cells, q, m, n, tail, steps)
end