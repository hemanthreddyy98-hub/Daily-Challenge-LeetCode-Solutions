~S"""
Brute Force

defmodule Solution do
  @spec min_cost(grid :: [[integer]]) :: integer
  def min_cost(grid) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    dfs(g, tuple_size(g), tuple_size(elem(g, 0)), 0, 0, cell(g, 0, 0))
  end

  def cell(g, i, j), do: elem(elem(g, i), j)

  def dfs(_g, m, n, i, j, x) when i == m - 1 and j == n - 1, do: x
  def dfs(g, m, n, i, j, x) when i == m - 1, do: dfs(g, m, n, i, j + 1, Bitwise.bxor(x, cell(g, i, j + 1)))
  def dfs(g, m, n, i, j, x) when j == n - 1, do: dfs(g, m, n, i + 1, j, Bitwise.bxor(x, cell(g, i + 1, j)))

  def dfs(g, m, n, i, j, x) do
    min(
      dfs(g, m, n, i + 1, j, Bitwise.bxor(x, cell(g, i + 1, j))),
      dfs(g, m, n, i, j + 1, Bitwise.bxor(x, cell(g, i, j + 1)))
    )
  end
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec min_cost(grid :: [[integer]]) :: integer
  def min_cost(grid) do
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    {best, _} = dfs(g, tuple_size(g), tuple_size(elem(g, 0)), 0, 0, cell(g, 0, 0), %{})
    best
  end

  def cell(g, i, j), do: elem(elem(g, i), j)

  def dfs(_g, m, n, i, j, x, memo) when i == m - 1 and j == n - 1, do: {x, memo}

  def dfs(g, m, n, i, j, x, memo) do
    case Map.fetch(memo, {i, j, x}) do
      {:ok, best} ->
        {best, memo}

      :error ->
        {down, memo} =
          if i + 1 < m,
            do: dfs(g, m, n, i + 1, j, Bitwise.bxor(x, cell(g, i + 1, j)), memo),
            else: {:infinity, memo}

        {right, memo} =
          if j + 1 < n,
            do: dfs(g, m, n, i, j + 1, Bitwise.bxor(x, cell(g, i, j + 1)), memo),
            else: {:infinity, memo}

        best = min(down, right)
        {best, Map.put(memo, {i, j, x}, best)}
    end
  end
end
"""

defmodule Solution do
  @spec min_cost(grid :: [[integer]]) :: integer
  def min_cost(grid) do
    n = length(hd(grid))

    grid
    |> Enum.with_index()
    |> Enum.reduce(List.duplicate(MapSet.new(), n), fn {row, i}, prev ->
      {cur, _} =
        row
        |> Enum.zip(prev)
        |> Enum.with_index()
        |> Enum.map_reduce(MapSet.new(), fn {{v, up}, j}, left ->
          from = if i == 0 and j == 0, do: MapSet.new([0]), else: MapSet.union(up, left)
          set = MapSet.new(from, &Bitwise.bxor(&1, v))
          {set, set}
        end)

      cur
    end)
    |> List.last()
    |> Enum.min()
  end
end