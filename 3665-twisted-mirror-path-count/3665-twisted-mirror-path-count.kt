/*
Brute Force

class Solution {
    fun uniquePaths(grid: Array<IntArray>): Int {
        val mod = 1_000_000_007
        val m = grid.size
        val n = grid[0].size
        fun dfs(i: Int, j: Int, d: Int): Int {
            if (i >= m || j >= n) return 0
            if (i == m - 1 && j == n - 1) return 1
            if (grid[i][j] == 1) return if (d == 0) dfs(i + 1, j, 1) else dfs(i, j + 1, 0)
            return (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod
        }
        return dfs(0, 0, 0)
    }
}
*/

/*
Better Approach

class Solution {
    fun uniquePaths(grid: Array<IntArray>): Int {
        val mod = 1_000_000_007
        val m = grid.size
        val n = grid[0].size
        val memo = Array(m) { Array(n) { IntArray(2) { -1 } } }
        fun dfs(i: Int, j: Int, d: Int): Int {
            if (i >= m || j >= n) return 0
            if (i == m - 1 && j == n - 1) return 1
            if (memo[i][j][d] != -1) return memo[i][j][d]
            memo[i][j][d] = if (grid[i][j] == 0) (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod
            else if (d == 0) dfs(i + 1, j, 1)
            else dfs(i, j + 1, 0)
            return memo[i][j][d]
        }
        return dfs(0, 0, 0)
    }
}
*/

class Solution {
    fun uniquePaths(grid: Array<IntArray>): Int {
        val mod = 1_000_000_007
        val m = grid.size
        val n = grid[0].size
        val r = IntArray(n)
        val d = IntArray(n)
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (i == 0 && j == 0) {
                    r[0] = 1
                    continue
                }
                val nd = if (i == 0) 0 else if (grid[i - 1][j] == 0) (r[j] + d[j]) % mod else r[j]
                val nr = if (j == 0) 0 else if (grid[i][j - 1] == 0) (r[j - 1] + d[j - 1]) % mod else d[j - 1]
                r[j] = nr
                d[j] = nd
            }
        }
        return (r[n - 1] + d[n - 1]) % mod
    }
}