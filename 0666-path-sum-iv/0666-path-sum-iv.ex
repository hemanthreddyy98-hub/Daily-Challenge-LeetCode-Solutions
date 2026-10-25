~S"""
Brute Force

defmodule Solution do
  @spec path_sum(nums :: [integer]) :: integer
  def path_sum(nums) do
    nums
    |> Enum.reject(fn x ->
      d = div(x, 100)
      p = rem(div(x, 10), 10)
      Enum.any?(nums, fn y -> div(y, 100) == d + 1 and rem(div(y, 10), 10) in [2 * p - 1, 2 * p] end)
    end)
    |> Enum.map(fn x -> climb(nums, div(x, 100), rem(div(x, 10), 10)) end)
    |> Enum.sum()
  end

  def climb(_nums, 0, _p), do: 0

  def climb(nums, d, p) do
    node = Enum.find(nums, fn y -> div(y, 100) == d and rem(div(y, 10), 10) == p end)
    rem(node, 10) + climb(nums, d - 1, div(p + 1, 2))
  end
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec path_sum(nums :: [integer]) :: integer
  def path_sum(nums) do
    tree = Map.new(nums, fn x -> {div(x, 10), rem(x, 10)} end)
    dfs(tree, 1, 1, 0)
  end

  def dfs(tree, d, p, sum) do
    case Map.fetch(tree, d * 10 + p) do
      :error ->
        0

      {:ok, v} ->
        total = sum + v
        left = (d + 1) * 10 + 2 * p - 1

        if Map.has_key?(tree, left) or Map.has_key?(tree, left + 1) do
          dfs(tree, d + 1, 2 * p - 1, total) + dfs(tree, d + 1, 2 * p, total)
        else
          total
        end
    end
  end
end
"""

defmodule Solution do
  @spec path_sum(nums :: [integer]) :: integer
  def path_sum(nums) do
    {ans, _} =
      nums
      |> Enum.reverse()
      |> Enum.reduce({0, :erlang.make_tuple(16, 0)}, fn x, {ans, leaves} ->
        idx = Bitwise.bsl(1, div(x, 100) - 1) + rem(div(x, 10), 10) - 1
        count = max(elem(leaves, idx), 1)
        parent = div(idx, 2)
        leaves = if idx > 1, do: put_elem(leaves, parent, elem(leaves, parent) + count), else: leaves
        {ans + rem(x, 10) * count, leaves}
      end)

    ans
  end
end