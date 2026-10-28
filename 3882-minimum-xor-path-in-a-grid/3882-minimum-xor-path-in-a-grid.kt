/*
Brute Force

class Solution {
    fun minCost(grid: Array<IntArray>): Int {
        return dfs(grid, 0, 0, grid[0][0])
    }

    fun dfs(grid: Array<IntArray>, i: Int, j: Int, x: Int): Int {
        val m = grid.size
        val n = grid[0].size
        if (i == m - 1 && j == n - 1) return x
        var best = Int.MAX_VALUE
        if (i + 1 < m) best = minOf(best, dfs(grid, i + 1, j, x xor grid[i + 1][j]))
        if (j + 1 < n) best = minOf(best, dfs(grid, i, j + 1, x xor grid[i][j + 1]))
        return best
    }
}
*/

/*
Better Approach

class Solution {
    fun minCost(grid: Array<IntArray>): Int {
        val memo = Array(grid.size) { Array(grid[0].size) { IntArray(1024) { -1 } } }
        return dfs(grid, memo, 0, 0, grid[0][0])
    }

    fun dfs(grid: Array<IntArray>, memo: Array<Array<IntArray>>, i: Int, j: Int, x: Int): Int {
        val m = grid.size
        val n = grid[0].size
        if (i == m - 1 && j == n - 1) return x
        if (memo[i][j][x] != -1) return memo[i][j][x]
        var best = Int.MAX_VALUE
        if (i + 1 < m) best = minOf(best, dfs(grid, memo, i + 1, j, x xor grid[i + 1][j]))
        if (j + 1 < n) best = minOf(best, dfs(grid, memo, i, j + 1, x xor grid[i][j + 1]))
        memo[i][j][x] = best
        return best
    }
}
*/

class Solution {
    fun minCost(grid: Array<IntArray>): Int {
        val m = grid.size
        val n = grid[0].size
        val dp = Array(n) { BooleanArray(1024) }
        val tmp = BooleanArray(1024)
        for (i in 0 until m)
            for (j in 0 until n) {
                for (x in 0 until 1024)
                    tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j - 1][x])
                for (x in 0 until 1024) dp[j][x xor grid[i][j]] = tmp[x]
            }
        var x = 0
        while (!dp[n - 1][x]) x++
        return x
    }
}