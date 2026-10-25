/*
Brute Force

class Solution {
    fun closedIsland(grid: Array<IntArray>): Int {
        val m = grid.size
        val n = grid[0].size
        val dr = intArrayOf(1, -1, 0, 0)
        val dc = intArrayOf(0, 0, 1, -1)
        var count = 0
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (grid[i][j] != 0) continue
                val seen = Array(m) { BooleanArray(n) }
                val stack = ArrayDeque<IntArray>()
                stack.addLast(intArrayOf(i, j))
                seen[i][j] = true
                var closed = true
                var first = true
                while (stack.isNotEmpty()) {
                    val (r, c) = stack.removeLast()
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false
                    if (r * n + c < i * n + j) first = false
                    for (k in 0 until 4) {
                        val nr = r + dr[k]
                        val nc = c + dc[k]
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0 && !seen[nr][nc]) {
                            seen[nr][nc] = true
                            stack.addLast(intArrayOf(nr, nc))
                        }
                    }
                }
                if (closed && first) count++
            }
        }
        return count
    }
}
*/

/*
Better Approach

class Solution {
    fun closedIsland(grid: Array<IntArray>): Int {
        val m = grid.size
        val n = grid[0].size
        for (i in 0 until m) {
            sink(grid, i, 0)
            sink(grid, i, n - 1)
        }
        for (j in 0 until n) {
            sink(grid, 0, j)
            sink(grid, m - 1, j)
        }
        var count = 0
        for (i in 0 until m)
            for (j in 0 until n)
                if (grid[i][j] == 0) {
                    sink(grid, i, j)
                    count++
                }
        return count
    }

    fun sink(grid: Array<IntArray>, r: Int, c: Int) {
        if (r < 0 || c < 0 || r >= grid.size || c >= grid[0].size || grid[r][c] != 0) return
        grid[r][c] = 1
        sink(grid, r + 1, c)
        sink(grid, r - 1, c)
        sink(grid, r, c + 1)
        sink(grid, r, c - 1)
    }
}
*/

class Solution {
    fun closedIsland(grid: Array<IntArray>): Int {
        val m = grid.size
        val n = grid[0].size
        val q = IntArray(m * n)
        val dr = intArrayOf(1, -1, 0, 0)
        val dc = intArrayOf(0, 0, 1, -1)
        var count = 0
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (grid[i][j] != 0) continue
                var head = 0
                var tail = 0
                var closed = true
                grid[i][j] = 1
                q[tail++] = i * n + j
                while (head < tail) {
                    val id = q[head++]
                    val r = id / n
                    val c = id % n
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false
                    for (k in 0 until 4) {
                        val nr = r + dr[k]
                        val nc = c + dc[k]
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0) {
                            grid[nr][nc] = 1
                            q[tail++] = nr * n + nc
                        }
                    }
                }
                if (closed) count++
            }
        }
        return count
    }
}