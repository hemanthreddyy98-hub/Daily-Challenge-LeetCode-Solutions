~S"""
Brute Force

defmodule Solution do
  @spec unique_paths(grid :: [[integer]]) :: integer
  def unique_paths(grid) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    dfs(g, tuple_size(g), tuple_size(elem(g, 0)), 0, 0, 0)
  end

  def dfs(_g, m, n, i, j, _d) when i >= m or j >= n, do: 0
  def dfs(_g, m, n, i, j, _d) when i == m - 1 and j == n - 1, do: 1

  def dfs(g, m, n, i, j, d) do
    cond do
      elem(elem(g, i), j) == 0 -> rem(dfs(g, m, n, i, j + 1, 0) + dfs(g, m, n, i + 1, j, 1), 1_000_000_007)
      d == 0 -> dfs(g, m, n, i + 1, j, 1)
      true -> dfs(g, m, n, i, j + 1, 0)
    end
  end
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec unique_paths(grid :: [[integer]]) :: integer
  def unique_paths(grid) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    {ans, _} = dfs(g, tuple_size(g), tuple_size(elem(g, 0)), 0, 0, 0, %{})
    ans
  end

  def dfs(_g, m, n, i, j, _d, memo) when i >= m or j >= n, do: {0, memo}
  def dfs(_g, m, n, i, j, _d, memo) when i == m - 1 and j == n - 1, do: {1, memo}

  def dfs(g, m, n, i, j, d, memo) do
    key = (i * n + j) * 2 + d

    case memo do
      %{^key => v} ->
        {v, memo}

      _ ->
        {v, memo} =
          cond do
            elem(elem(g, i), j) == 0 ->
              {a, memo} = dfs(g, m, n, i, j + 1, 0, memo)
              {b, memo} = dfs(g, m, n, i + 1, j, 1, memo)
              {rem(a + b, 1_000_000_007), memo}

            d == 0 ->
              dfs(g, m, n, i + 1, j, 1, memo)

            true ->
              dfs(g, m, n, i, j + 1, 0, memo)
          end

        {v, Map.put(memo, key, v)}
    end
  end
end
"""

defmodule Solution do
  @spec unique_paths(grid :: [[integer]]) :: integer
  def unique_paths([g0 | _] = grid) do
    n = length(g0)
    {r, d} = rows(grid, List.duplicate(1, n), List.duplicate({0, 0}, n), 0, 1) |> List.last()
    rem(r + d, 1_000_000_007)
  end

  def rows([], _prev, up, _lg, _lr), do: up
  def rows([g | gs], prev, up, lg, lr), do: rows(gs, g, cells(g, prev, up, lg, lr, 0, []), 1, 0)

  def cells([], _prev, _up, _lg, _lr, _ld, acc), do: Enum.reverse(acc)

  def cells([c | cs], [p | ps], [{ur, ud} | us], lg, lr, ld, acc) do
    r = if lg == 0, do: rem(lr + ld, 1_000_000_007), else: ld
    d = if p == 0, do: rem(ur + ud, 1_000_000_007), else: ur
    cells(cs, ps, us, c, r, d, [{r, d} | acc])
  end
end