~S"""
Brute Force

defmodule Solution do
  import Bitwise

  @spec palindrome_path(n :: integer, edges :: [[integer]], s :: String.t, queries :: [String.t]) :: [boolean]
  def palindrome_path(n, edges, s, queries) do
    g = graph(n, edges)
    ch = s |> String.to_charlist() |> Enum.with_index() |> Map.new(fn {c, i} -> {i, c - ?a} end)

    {ans, _} =
      Enum.reduce(queries, {[], ch}, fn q, {ans, ch} ->
        case String.split(q) do
          ["update", a, <<c>>] ->
            {ans, Map.put(ch, String.to_integer(a), c - ?a)}

          ["query", a, b] ->
            u = String.to_integer(a)
            par = search(g, [u], %{u => u})
            mask = walk(par, ch, String.to_integer(b), u, 0)
            {[band(mask, mask - 1) == 0 | ans], ch}
        end
      end)

    Enum.reverse(ans)
  end

  def graph(n, edges) do
    Enum.reduce(edges, Map.new(0..(n - 1), &{&1, []}), fn [a, b], g ->
      g |> Map.update!(a, &[b | &1]) |> Map.update!(b, &[a | &1])
    end)
  end

  def search(_g, [], par), do: par

  def search(g, [x | rest], par) do
    new = Enum.reject(g[x], &Map.has_key?(par, &1))
    search(g, new ++ rest, Enum.reduce(new, par, &Map.put(&2, &1, x)))
  end

  def walk(_par, ch, u, u, mask), do: bxor(mask, bsl(1, ch[u]))
  def walk(par, ch, x, u, mask), do: walk(par, ch, par[x], u, bxor(mask, bsl(1, ch[x])))
end
"""

~S"""
Better Approach

defmodule Solution do
  import Bitwise

  @spec palindrome_path(n :: integer, edges :: [[integer]], s :: String.t, queries :: [String.t]) :: [boolean]
  def palindrome_path(n, edges, s, queries) do
    g = graph(n, edges)
    {par, depth} = root(g, [0], %{0 => 0}, %{0 => 0})
    ch = s |> String.to_charlist() |> Enum.with_index() |> Map.new(fn {c, i} -> {i, c - ?a} end)

    {ans, _} =
      Enum.reduce(queries, {[], ch}, fn q, {ans, ch} ->
        case String.split(q) do
          ["update", a, <<c>>] ->
            {ans, Map.put(ch, String.to_integer(a), c - ?a)}

          ["query", a, b] ->
            mask = climb(par, depth, ch, String.to_integer(a), String.to_integer(b), 0)
            {[band(mask, mask - 1) == 0 | ans], ch}
        end
      end)

    Enum.reverse(ans)
  end

  def graph(n, edges) do
    Enum.reduce(edges, Map.new(0..(n - 1), &{&1, []}), fn [a, b], g ->
      g |> Map.update!(a, &[b | &1]) |> Map.update!(b, &[a | &1])
    end)
  end

  def root(_g, [], par, depth), do: {par, depth}

  def root(g, [x | rest], par, depth) do
    new = Enum.reject(g[x], &Map.has_key?(par, &1))
    d = depth[x] + 1
    root(g, new ++ rest, Enum.reduce(new, par, &Map.put(&2, &1, x)), Enum.reduce(new, depth, &Map.put(&2, &1, d)))
  end

  def climb(_par, _depth, ch, x, x, mask), do: bxor(mask, bsl(1, ch[x]))

  def climb(par, depth, ch, u, v, mask) do
    if depth[u] < depth[v],
      do: climb(par, depth, ch, v, u, mask),
      else: climb(par, depth, ch, par[u], v, bxor(mask, bsl(1, ch[u])))
  end
end
"""

defmodule Solution do
  import Bitwise

  @spec palindrome_path(n :: integer, edges :: [[integer]], s :: String.t, queries :: [String.t]) :: [boolean]
  def palindrome_path(n, edges, s, queries) do
    start = :atomics.new(n + 1, [])
    nb = :atomics.new(2 * n, [])
    Enum.each(edges, fn [a, b] -> :atomics.add(start, a + 2, 1); :atomics.add(start, b + 2, 1) end)
    Enum.each(2..(n + 1)//1, fn i -> :atomics.add(start, i, :atomics.get(start, i - 1)) end)

    Enum.each(edges, fn [a, b] ->
      :atomics.put(nb, :atomics.add_get(start, a + 1, 1), b)
      :atomics.put(nb, :atomics.add_get(start, b + 1, 1), a)
    end)

    [ch, par, dep, tin, pm, size, bit] = for _ <- 1..7, do: :atomics.new(n, [])
    s |> :binary.bin_to_list() |> Enum.with_index(1) |> Enum.each(fn {c, i} -> :atomics.put(ch, i, c - ?a) end)
    rev = dfs({start, nb}, [{0, 0, 0, 0}], par, dep, tin, pm, ch, 0, [])

    Enum.each(rev, fn
      0 -> :ok
      x -> :atomics.add(size, :atomics.get(par, x + 1) + 1, :atomics.get(size, x + 1) + 1)
    end)

    build(bit, pm, n, 1, 0)
    max_depth = Enum.reduce(1..n, 0, fn i, m -> max(m, :atomics.get(dep, i)) end)
    up0 = List.to_tuple(for i <- 1..n, do: :atomics.get(par, i))

    up =
      [up0 | Enum.scan(2..max(1, bits(max_depth))//1, up0, fn _, prev -> List.to_tuple(for x <- 0..(n - 1), do: elem(prev, elem(prev, x))) end)]
      |> List.to_tuple()

    queries
    |> Enum.reduce([], fn
      "update " <> rest, acc ->
        [a, <<c>>] = :binary.split(rest, " ")
        u = String.to_integer(a)
        d = bxor(bsl(1, :atomics.get(ch, u + 1)), bsl(1, c - ?a))
        t = :atomics.get(tin, u + 1)
        add(bit, n, t + 1, d)
        add(bit, n, t + :atomics.get(size, u + 1) + 2, d)
        :atomics.put(ch, u + 1, c - ?a)
        acc

      "query " <> rest, acc ->
        [a, b] = :binary.split(rest, " ")
        u = String.to_integer(a)
        v = String.to_integer(b)
        w = lca(up, dep, u, v)
        mask = bxor(prefix(bit, :atomics.get(tin, u + 1) + 1, 0), prefix(bit, :atomics.get(tin, v + 1) + 1, 0))
        mask = bxor(mask, bsl(1, :atomics.get(ch, w + 1)))
        [band(mask, mask - 1) == 0 | acc]
    end)
    |> Enum.reverse()
  end

  def dfs(_g, [], _par, _dep, _tin, _pm, _ch, _t, rev), do: rev

  def dfs({start, nb} = g, [{x, p, d, m} | stack], par, dep, tin, pm, ch, t, rev) do
    m = bxor(m, bsl(1, :atomics.get(ch, x + 1)))
    :atomics.put(par, x + 1, p)
    :atomics.put(dep, x + 1, d)
    :atomics.put(tin, x + 1, t)
    :atomics.put(pm, t + 1, m)
    from = if x == 0, do: 1, else: :atomics.get(start, x) + 1
    stack = push(nb, from, :atomics.get(start, x + 1), x, p, d + 1, m, stack)
    dfs(g, stack, par, dep, tin, pm, ch, t + 1, [x | rev])
  end

  def push(_nb, i, e, _x, _p, _d, _m, stack) when i > e, do: stack

  def push(nb, i, e, x, p, d, m, stack) do
    case :atomics.get(nb, i) do
      ^p -> push(nb, i + 1, e, x, p, d, m, stack)
      y -> push(nb, i + 1, e, x, p, d, m, [{y, x, d, m} | stack])
    end
  end

  def build(_bit, _pm, n, i, _prev) when i > n, do: :ok

  def build(bit, pm, n, i, prev) do
    a = :atomics.get(pm, i)
    v = bxor(:atomics.get(bit, i), bxor(a, prev))
    :atomics.put(bit, i, v)
    j = i + band(i, -i)
    if j <= n, do: :atomics.put(bit, j, bxor(:atomics.get(bit, j), v))
    build(bit, pm, n, i + 1, a)
  end

  def add(_bit, n, i, _d) when i > n, do: :ok

  def add(bit, n, i, d) do
    :atomics.put(bit, i, bxor(:atomics.get(bit, i), d))
    add(bit, n, i + band(i, -i), d)
  end

  def prefix(_bit, 0, acc), do: acc
  def prefix(bit, i, acc), do: prefix(bit, i - band(i, -i), bxor(acc, :atomics.get(bit, i)))

  def bits(0), do: 0
  def bits(d), do: 1 + bits(d >>> 1)

  def lca(up, dep, a, b) do
    da = :atomics.get(dep, a + 1)
    db = :atomics.get(dep, b + 1)

    if da < db do
      lca(up, dep, b, a)
    else
      a = lift(up, a, da - db, 0)
      if a == b, do: a, else: meet(up, a, b, tuple_size(up) - 1)
    end
  end

  def lift(_up, x, 0, _k), do: x
  def lift(up, x, diff, k) when band(diff, 1) == 1, do: lift(up, elem(elem(up, k), x), diff >>> 1, k + 1)
  def lift(up, x, diff, k), do: lift(up, x, diff >>> 1, k + 1)

  def meet(up, a, _b, -1), do: elem(elem(up, 0), a)

  def meet(up, a, b, k) do
    level = elem(up, k)
    pa = elem(level, a)
    pb = elem(level, b)
    if pa == pb, do: meet(up, a, b, k - 1), else: meet(up, pa, pb, k - 1)
  end
end