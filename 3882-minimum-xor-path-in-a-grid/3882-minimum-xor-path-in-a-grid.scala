/*
Brute Force

object Solution {
  def minCost(grid: Array[Array[Int]]): Int = dfs(grid, 0, 0, grid(0)(0))

  def dfs(grid: Array[Array[Int]], i: Int, j: Int, x: Int): Int = {
    val m = grid.length
    val n = grid(0).length
    if (i == m - 1 && j == n - 1) x
    else {
      var best = Int.MaxValue
      if (i + 1 < m) best = math.min(best, dfs(grid, i + 1, j, x ^ grid(i + 1)(j)))
      if (j + 1 < n) best = math.min(best, dfs(grid, i, j + 1, x ^ grid(i)(j + 1)))
      best
    }
  }
}
*/

/*
Better Approach

object Solution {
  def minCost(grid: Array[Array[Int]]): Int = {
    val memo = Array.fill(grid.length * grid(0).length * 1024)(-1)
    dfs(grid, memo, 0, 0, grid(0)(0))
  }

  def dfs(grid: Array[Array[Int]], memo: Array[Int], i: Int, j: Int, x: Int): Int = {
    val m = grid.length
    val n = grid(0).length
    val key = (i * n + j) * 1024 + x
    if (i == m - 1 && j == n - 1) x
    else if (memo(key) != -1) memo(key)
    else {
      var best = Int.MaxValue
      if (i + 1 < m) best = math.min(best, dfs(grid, memo, i + 1, j, x ^ grid(i + 1)(j)))
      if (j + 1 < n) best = math.min(best, dfs(grid, memo, i, j + 1, x ^ grid(i)(j + 1)))
      memo(key) = best
      best
    }
  }
}
*/

object Solution {
  def minCost(grid: Array[Array[Int]]): Int = {
    val m = grid.length
    val n = grid(0).length
    val dp = Array.ofDim[Boolean](n, 1024)
    val tmp = new Array[Boolean](1024)
    for (i <- 0 until m; j <- 0 until n) {
      for (x <- 0 until 1024)
        tmp(x) = (i == 0 && j == 0 && x == 0) || (i > 0 && dp(j)(x)) || (j > 0 && dp(j - 1)(x))
      for (x <- 0 until 1024) dp(j)(x ^ grid(i)(j)) = tmp(x)
    }
    dp(n - 1).indexOf(true)
  }
}