/*
Brute Force

object Solution {
  def uniquePaths(grid: Array[Array[Int]]): Int = {
    val mod = 1000000007
    val m = grid.length
    val n = grid(0).length
    def dfs(i: Int, j: Int, d: Int): Int = {
      if (i >= m || j >= n) 0
      else if (i == m - 1 && j == n - 1) 1
      else if (grid(i)(j) == 0) (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod
      else if (d == 0) dfs(i + 1, j, 1)
      else dfs(i, j + 1, 0)
    }
    dfs(0, 0, 0)
  }
}
*/

/*
Better Approach

object Solution {
  def uniquePaths(grid: Array[Array[Int]]): Int = {
    val mod = 1000000007
    val m = grid.length
    val n = grid(0).length
    val memo = Array.fill(m * n * 2)(-1)
    def dfs(i: Int, j: Int, d: Int): Int = {
      if (i >= m || j >= n) 0
      else if (i == m - 1 && j == n - 1) 1
      else {
        val key = (i * n + j) * 2 + d
        if (memo(key) == -1) {
          memo(key) =
            if (grid(i)(j) == 0) (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod
            else if (d == 0) dfs(i + 1, j, 1)
            else dfs(i, j + 1, 0)
        }
        memo(key)
      }
    }
    dfs(0, 0, 0)
  }
}
*/

object Solution {
  def uniquePaths(grid: Array[Array[Int]]): Int = {
    val mod = 1000000007
    val m = grid.length
    val n = grid(0).length
    val r = new Array[Int](n)
    val d = new Array[Int](n)
    for (i <- 0 until m; j <- 0 until n) {
      if (i == 0 && j == 0) r(0) = 1
      else {
        val nd = if (i == 0) 0 else if (grid(i - 1)(j) == 0) (r(j) + d(j)) % mod else r(j)
        val nr = if (j == 0) 0 else if (grid(i)(j - 1) == 0) (r(j - 1) + d(j - 1)) % mod else d(j - 1)
        r(j) = nr
        d(j) = nd
      }
    }
    (r(n - 1) + d(n - 1)) % mod
  }
}