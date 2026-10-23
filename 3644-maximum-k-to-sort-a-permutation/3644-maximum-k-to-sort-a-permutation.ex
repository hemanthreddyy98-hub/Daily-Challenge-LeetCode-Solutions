~S"""
Brute Force

defmodule Solution do
  @spec sort_permutation(nums :: [integer]) :: integer
  def sort_permutation(nums) do
    n = length(nums)
    idx = Enum.with_index(nums)

    if Enum.all?(idx, fn {v, i} -> v == i end) do
      0
    else
      Enum.find((n - 1)..0//-1, 0, fn k ->
        p0 = Map.new(0..(n - 1), &{&1, &1})

        p =
          for a <- nums, b <- nums, a < b, Bitwise.band(a, b) == k, reduce: p0 do
            acc -> union(acc, a, b)
          end

        Enum.all?(idx, fn {v, i} -> find(p, v) == find(p, i) end)
      end)
    end
  end

  defp find(p, x) do
    case Map.fetch!(p, x) do
      ^x -> x
      y -> find(p, y)
    end
  end

  defp union(p, a, b), do: Map.put(p, find(p, a), find(p, b))
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec sort_permutation(nums :: [integer]) :: integer
  def sort_permutation(nums) do
    misplaced = for {v, i} <- Enum.with_index(nums), v != i, do: v

    if misplaced == [] do
      0
    else
      Enum.find((length(nums) - 1)..0//-1, 0, fn k ->
        Enum.all?(misplaced, fn v -> Bitwise.band(v, k) == k end)
      end)
    end
  end
end
"""

defmodule Solution do
  @spec sort_permutation(nums :: [integer]) :: integer
  def sort_permutation(nums) do
    nums
    |> Enum.with_index()
    |> Enum.reduce(-1, fn {v, i}, ans -> if v == i, do: ans, else: Bitwise.band(ans, v) end)
    |> max(0)
  end
end