~S"""
Brute Force

defmodule Solution do
  @spec shortest_path(n :: integer, edges :: [[integer]], labels :: String.t, k :: integer) :: integer
  def shortest_path(n, edges, labels, k) do
    dist = relax_all(%{{0, 1} => 0}, edges, labels, k)

    case for(run <- 1..k, Map.has_key?(dist, {n - 1, run}), do: dist[{n - 1, run}]) do
      [] -> -1
      ds -> Enum.min(ds)
    end
  end

  def relax_all(dist, edges, labels, k) do
    new =
      for [u, v, w] <- edges, run <- 1..k, reduce: dist do
        acc ->
          next = if :binary.at(labels, v) == :binary.at(labels, u), do: run + 1, else: 1

          with {:ok, d} <- Map.fetch(acc, {u, run}),
               true <- next <= k,
               true <- d + w < Map.get(acc, {v, next}, :infinity) do
            Map.put(acc, {v, next}, d + w)
          else
            _ -> acc
          end
      end

    if new == dist, do: dist, else: relax_all(new, edges, labels, k)
  end
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec shortest_path(n :: integer, edges :: [[integer]], labels :: String.t, k :: integer) :: integer
  def shortest_path(n, edges, labels, k) do
    g = Enum.group_by(edges, &hd/1, fn [_, v, w] -> {v, w} end)
    loop(:gb_sets.singleton({0, 0, 1}), %{{0, 1} => 0}, g, labels, n, k)
  end

  def loop(q, dist, g, labels, n, k) do
    if :gb_sets.is_empty(q) do
      -1
    else
      {{d, u, run}, q} = :gb_sets.take_smallest(q)

      cond do
        u == n - 1 ->
          d

        d > Map.get(dist, {u, run}) ->
          loop(q, dist, g, labels, n, k)

        true ->
          c = :binary.at(labels, u)

          {q, dist} =
            Enum.reduce(Map.get(g, u, []), {q, dist}, fn {v, w}, {q, dist} ->
              next = if :binary.at(labels, v) == c, do: run + 1, else: 1

              if next <= k and d + w < Map.get(dist, {v, next}, :infinity),
                do: {:gb_sets.add({d + w, v, next}, q), Map.put(dist, {v, next}, d + w)},
                else: {q, dist}
            end)

          loop(q, dist, g, labels, n, k)
      end
    end
  end
end
"""

defmodule Solution do
  @spec shortest_path(n :: integer, edges :: [[integer]], labels :: String.t, k :: integer) :: integer
  def shortest_path(n, edges, labels, k) do
    m = length(edges)
    start = :atomics.new(n + 1, [])
    to = :atomics.new(max(1, m), [])
    wt = :atomics.new(max(1, m), [])
    Enum.each(edges, fn [u, _, _] -> :atomics.add(start, u + 2, 1) end)
    Enum.each(2..(n + 1)//1, fn i -> :atomics.add(start, i, :atomics.get(start, i - 1)) end)

    Enum.each(edges, fn [u, v, w] ->
      p = :atomics.add_get(start, u + 1, 1)
      :atomics.put(to, p, v)
      :atomics.put(wt, p, w)
    end)

    best = :atomics.new(n, [])
    dijkstra(:gb_sets.singleton({0, 0, 1}), {start, to, wt}, best, labels, n, k)
  end

  def dijkstra(q, g, best, labels, n, k) do
    if :gb_sets.is_empty(q) do
      -1
    else
      {{d, u, run}, q} = :gb_sets.take_smallest(q)
      b = :atomics.get(best, u + 1)

      cond do
        b != 0 and run >= b ->
          dijkstra(q, g, best, labels, n, k)

        u == n - 1 ->
          d

        true ->
          :atomics.put(best, u + 1, run)
          {start, _, _} = g
          from = if u == 0, do: 1, else: :atomics.get(start, u) + 1
          q = relax(g, from, :atomics.get(start, u + 1), d, run, :binary.at(labels, u), best, labels, k, q)
          dijkstra(q, g, best, labels, n, k)
      end
    end
  end

  def relax(_g, i, e, _d, _run, _c, _best, _labels, _k, q) when i > e, do: q

  def relax({_, to, wt} = g, i, e, d, run, c, best, labels, k, q) do
    v = :atomics.get(to, i)
    next = if :binary.at(labels, v) == c, do: run + 1, else: 1
    b = :atomics.get(best, v + 1)
    q = if next <= k and (b == 0 or next < b), do: :gb_sets.add({d + :atomics.get(wt, i), v, next}, q), else: q
    relax(g, i + 1, e, d, run, c, best, labels, k, q)
  end
end