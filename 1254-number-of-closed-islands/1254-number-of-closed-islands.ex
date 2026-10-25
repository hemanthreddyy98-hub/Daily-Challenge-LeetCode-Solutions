~S"""
Brute Force

defmodule Solution do
  @spec closed_island(grid :: [[integer]]) :: integer
  def closed_island(grid) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    m = tuple_size(g)
    n = tuple_size(elem(g, 0))

    for r <- 0..(m - 1),
        c <- 0..(n - 1),
        cell(g, r, c) == 0,
        explore(g, m, n, [{r, c}], MapSet.new([{r, c}]), true, true, r * n + c),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  def explore(_g, _m, _n, [], _seen, closed, first, _id), do: closed and first

  def explore(g, m, n, [{r, c} | stack], seen, closed, first, id) do
    closed = closed and r > 0 and c > 0 and r < m - 1 and c < n - 1
    first = first and r * n + c >= id

    next =
      for {nr, nc} <- [{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}],
          nr >= 0 and nc >= 0 and nr < m and nc < n,
          cell(g, nr, nc) == 0,
          not MapSet.member?(seen, {nr, nc}),
          do: {nr, nc}

    explore(g, m, n, next ++ stack, Enum.into(next, seen), closed, first, id)
  end

  def cell(g, r, c), do: g |> elem(r) |> elem(c)
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec closed_island(grid :: [[integer]]) :: integer
  def closed_island(grid) do
    m = length(grid)
    n = length(hd(grid))

    land =
      for {row, r} <- Enum.with_index(grid),
          {v, c} <- Enum.with_index(row),
          v == 0,
          into: MapSet.new(),
          do: {r, c}

    land =
      land
      |> Enum.filter(fn {r, c} -> r == 0 or c == 0 or r == m - 1 or c == n - 1 end)
      |> Enum.reduce(land, &sink/2)

    {_, count} =
      Enum.reduce(land, {land, 0}, fn p, {l, k} ->
        if MapSet.member?(l, p), do: {sink(p, l), k + 1}, else: {l, k}
      end)

    count
  end

  def sink({r, c} = p, land) do
    if MapSet.member?(land, p) do
      Enum.reduce([{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}], MapSet.delete(land, p), &sink/2)
    else
      land
    end
  end
end
"""

defmodule Solution do
  @spec closed_island(grid :: [[integer]]) :: integer
  def closed_island(grid) do
    m = length(grid)
    n = length(hd(grid))
    cells = :atomics.new(m * n, [])

    grid
    |> Enum.concat()
    |> Enum.with_index(1)
    |> Enum.each(fn {v, i} -> :atomics.put(cells, i, v) end)

    q = :atomics.new(m * n, [])

    Enum.reduce(0..(m * n - 1), 0, fn id, count ->
      if :atomics.get(cells, id + 1) == 0 do
        :atomics.put(cells, id + 1, 1)
        :atomics.put(q, 1, id)
        if bfs(0, 1, cells, q, m, n, true), do: count + 1, else: count
      else
        count
      end
    end)
  end

  def bfs(head, tail, _cells, _q, _m, _n, closed) when head >= tail, do: closed

  def bfs(head, tail, cells, q, m, n, closed) do
    id = :atomics.get(q, head + 1)
    r = div(id, n)
    c = rem(id, n)
    closed = closed and r > 0 and c > 0 and r < m - 1 and c < n - 1

    tail =
      Enum.reduce([{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}], tail, fn {nr, nc}, t ->
        if nr >= 0 and nc >= 0 and nr < m and nc < n and :atomics.get(cells, nr * n + nc + 1) == 0 do
          :atomics.put(cells, nr * n + nc + 1, 1)
          :atomics.put(q, t + 1, nr * n + nc)
          t + 1
        else
          t
        end
      end)

    bfs(head + 1, tail, cells, q, m, n, closed)
  end
end