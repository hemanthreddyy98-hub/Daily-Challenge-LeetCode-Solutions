~S"""
Brute Force

defmodule Solution do
  @spec count_islands(grid :: [[integer]], k :: integer) :: integer
  def count_islands(grid, k) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    m = tuple_size(g)
    n = tuple_size(elem(g, 0))

    for r <- 0..(m - 1),
        c <- 0..(n - 1),
        cell(g, r, c) > 0,
        {sum, first} = explore(g, m, n, [{r, c}], MapSet.new([{r, c}]), 0, true, r * n + c),
        first and rem(sum, k) == 0,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  def explore(_g, _m, _n, [], _seen, sum, first, _id), do: {sum, first}

  def explore(g, m, n, [{r, c} | stack], seen, sum, first, id) do
    next =
      for {nr, nc} <- [{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}],
          nr >= 0 and nc >= 0 and nr < m and nc < n,
          cell(g, nr, nc) > 0,
          not MapSet.member?(seen, {nr, nc}),
          do: {nr, nc}

    explore(g, m, n, next ++ stack, Enum.into(next, seen), sum + cell(g, r, c), first and r * n + c >= id, id)
  end

  def cell(g, r, c), do: g |> elem(r) |> elem(c)
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec count_islands(grid :: [[integer]], k :: integer) :: integer
  def count_islands(grid, k) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    m = tuple_size(g)
    n = tuple_size(elem(g, 0))

    {count, _} =
      for r <- 0..(m - 1), c <- 0..(n - 1), reduce: {0, MapSet.new()} do
        {count, visited} ->
          if cell(g, r, c) > 0 and not MapSet.member?(visited, {r, c}) do
            {sum, visited} = bfs(g, m, n, :queue.from_list([{r, c}]), MapSet.put(visited, {r, c}), 0)
            {if(rem(sum, k) == 0, do: count + 1, else: count), visited}
          else
            {count, visited}
          end
      end

    count
  end

  def bfs(g, m, n, queue, visited, sum) do
    case :queue.out(queue) do
      {:empty, _} ->
        {sum, visited}

      {{:value, {r, c}}, queue} ->
        {queue, visited} =
          Enum.reduce([{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}], {queue, visited}, fn {nr, nc}, {q, v} ->
            if nr >= 0 and nc >= 0 and nr < m and nc < n and cell(g, nr, nc) > 0 and
                 not MapSet.member?(v, {nr, nc}) do
              {:queue.in({nr, nc}, q), MapSet.put(v, {nr, nc})}
            else
              {q, v}
            end
          end)

        bfs(g, m, n, queue, visited, sum + cell(g, r, c))
    end
  end

  def cell(g, r, c), do: g |> elem(r) |> elem(c)
end
"""

defmodule Solution do
  @spec count_islands(grid :: [[integer]], k :: integer) :: integer
  def count_islands(grid, k) do
    m = length(grid)
    n = length(hd(grid))
    cells = :atomics.new(m * n, [])

    grid
    |> Enum.concat()
    |> Enum.with_index(1)
    |> Enum.each(fn {v, i} -> :atomics.put(cells, i, v) end)

    q = :atomics.new(m * n, [])

    Enum.reduce(0..(m * n - 1), 0, fn id, count ->
      v = :atomics.get(cells, id + 1)

      if v > 0 do
        :atomics.put(cells, id + 1, 0)
        :atomics.put(q, 1, id)
        if bfs(0, 1, cells, q, m, n, k, rem(v, k)) == 0, do: count + 1, else: count
      else
        count
      end
    end)
  end

  def bfs(head, tail, _cells, _q, _m, _n, _k, sum) when head >= tail, do: sum

  def bfs(head, tail, cells, q, m, n, k, sum) do
    id = :atomics.get(q, head + 1)
    r = div(id, n)
    c = rem(id, n)

    {tail, sum} =
      Enum.reduce([{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}], {tail, sum}, fn {nr, nc}, {t, s} ->
        v = if nr >= 0 and nc >= 0 and nr < m and nc < n, do: :atomics.get(cells, nr * n + nc + 1), else: 0

        if v > 0 do
          :atomics.put(cells, nr * n + nc + 1, 0)
          :atomics.put(q, t + 1, nr * n + nc)
          {t + 1, rem(s + v, k)}
        else
          {t, s}
        end
      end)

    bfs(head + 1, tail, cells, q, m, n, k, sum)
  end
end