~S"""
Brute Force

defmodule Solution do
  @spec create_grid(m :: integer, n :: integer) :: [String.t]
  def create_grid(m, n) do
    cells = for i <- 0..(m - 1), j <- 0..(n - 1), {i, j} != {0, 0}, {i, j} != {m - 1, n - 1}, do: {i, j}

    blocked =
      Enum.reduce(cells, MapSet.new(), fn cell, blocked ->
        trial = MapSet.put(blocked, cell)
        if reach?(trial, m, n, 0, 0), do: trial, else: blocked
      end)

    for i <- 0..(m - 1) do
      for j <- 0..(n - 1), into: "", do: if(MapSet.member?(blocked, {i, j}), do: "#", else: ".")
    end
  end

  def reach?(_blocked, m, n, r, c) when r >= m or c >= n, do: false

  def reach?(blocked, m, n, r, c) do
    cond do
      MapSet.member?(blocked, {r, c}) -> false
      r == m - 1 and c == n - 1 -> true
      true -> reach?(blocked, m, n, r + 1, c) or reach?(blocked, m, n, r, c + 1)
    end
  end
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec create_grid(m :: integer, n :: integer) :: [String.t]
  def create_grid(m, n) do
    cells = for i <- 0..(m - 1), j <- 0..(n - 1), {i, j} != {0, 0}, {i, j} != {m - 1, n - 1}, do: {i, j}

    blocked =
      Enum.reduce(cells, MapSet.new(), fn cell, blocked ->
        trial = MapSet.put(blocked, cell)
        if reach?(trial, m, n), do: trial, else: blocked
      end)

    for i <- 0..(m - 1) do
      for j <- 0..(n - 1), into: "", do: if(MapSet.member?(blocked, {i, j}), do: "#", else: ".")
    end
  end

  def reach?(blocked, m, n) do
    0..(m - 1)
    |> Enum.reduce(List.duplicate(false, n), fn i, prev ->
      {row, _} =
        Enum.map_reduce(Enum.zip(0..(n - 1), prev), false, fn {j, up}, left ->
          ok = not MapSet.member?(blocked, {i, j}) and ((i == 0 and j == 0) or up or left)
          {ok, ok}
        end)

      row
    end)
    |> List.last()
  end
end
"""

defmodule Solution do
  @spec create_grid(m :: integer, n :: integer) :: [String.t]
  def create_grid(m, n) do
    top = String.duplicate(".", n)
    rest = String.duplicate("#", n - 1) <> "."
    [top | List.duplicate(rest, m - 1)]
  end
end