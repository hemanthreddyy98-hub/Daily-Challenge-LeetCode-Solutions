/*
Brute Force

class Solution {
    private var best = Int.MAX_VALUE

    fun getFood(grid: Array<CharArray>): Int {
        best = Int.MAX_VALUE
        for (i in grid.indices)
            for (j in grid[0].indices)
                if (grid[i][j] == '*') dfs(grid, i, j, 0)
        return if (best == Int.MAX_VALUE) -1 else best
    }

    private fun dfs(grid: Array<CharArray>, r: Int, c: Int, steps: Int) {
        if (r < 0 || c < 0 || r >= grid.size || c >= grid[0].size) return
        val ch = grid[r][c]
        if (ch == 'X' || ch == 'V') return
        if (ch == '#') {
            best = minOf(best, steps)
            return
        }
        grid[r][c] = 'V'
        dfs(grid, r + 1, c, steps + 1)
        dfs(grid, r - 1, c, steps + 1)
        dfs(grid, r, c + 1, steps + 1)
        dfs(grid, r, c - 1, steps + 1)
        grid[r][c] = ch
    }
}
*/

/*
Basic Approach

class Solution {
    fun getFood(grid: Array<CharArray>): Int {
        val m = grid.size
        val n = grid[0].size
        val queue = ArrayDeque<IntArray>()
        val visited = Array(m) { BooleanArray(n) }
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (grid[i][j] == '*') {
                    queue.addLast(intArrayOf(i, j))
                    visited[i][j] = true
                }
            }
        }
        val dirs = arrayOf(intArrayOf(1, 0), intArrayOf(-1, 0), intArrayOf(0, 1), intArrayOf(0, -1))
        var steps = 0
        while (queue.isNotEmpty()) {
            repeat(queue.size) {
                val cur = queue.removeFirst()
                if (grid[cur[0]][cur[1]] == '#') return steps
                for (d in dirs) {
                    val r = cur[0] + d[0]
                    val c = cur[1] + d[1]
                    if (r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != 'X') {
                        visited[r][c] = true
                        queue.addLast(intArrayOf(r, c))
                    }
                }
            }
            steps++
        }
        return -1
    }
}
*/

class Solution {
    fun getFood(grid: Array<CharArray>): Int {
        val m = grid.size
        val n = grid[0].size

        var start = -1
        for (i in 0 until m) {
            val j = grid[i].indexOf('*')
            if (j != -1) { start = i * n + j; break }
        }
        if (start < 0) return -1

        val q = IntArray(m * n)
        var head = 0
        var tail = 0
        q[tail++] = start
        val dr = intArrayOf(1, -1, 0, 0)
        val dc = intArrayOf(0, 0, 1, -1)
        var steps = 0

        while (head < tail) {
            steps++
            val levelEnd = tail
            while (head < levelEnd) {
                val id = q[head++]
                val r = id / n
                val c = id % n
                for (k in 0 until 4) {
                    val nr = r + dr[k]
                    val nc = c + dc[k]
                    if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue
                    val ch = grid[nr][nc]
                    if (ch == '#') return steps
                    if (ch == 'O') {
                        grid[nr][nc] = 'X'
                        q[tail++] = nr * n + nc
                    }
                }
            }
        }
        return -1
    }
}