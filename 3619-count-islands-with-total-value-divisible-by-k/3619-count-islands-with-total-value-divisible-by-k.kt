/*
Brute Force

class Solution {
    fun countIslands(grid: Array<IntArray>, k: Int): Int {
        val m = grid.size
        val n = grid[0].size
        val dr = intArrayOf(1, -1, 0, 0)
        val dc = intArrayOf(0, 0, 1, -1)
        var count = 0
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (grid[i][j] == 0) continue
                val seen = Array(m) { BooleanArray(n) }
                val stack = ArrayDeque<IntArray>()
                stack.addLast(intArrayOf(i, j))
                seen[i][j] = true
                var sum = 0L
                var first = true
                while (stack.isNotEmpty()) {
                    val (r, c) = stack.removeLast()
                    sum += grid[r][c]
                    if (r * n + c < i * n + j) first = false
                    for (d in 0 until 4) {
                        val nr = r + dr[d]
                        val nc = c + dc[d]
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 && !seen[nr][nc]) {
                            seen[nr][nc] = true
                            stack.addLast(intArrayOf(nr, nc))
                        }
                    }
                }
                if (first && sum % k == 0L) count++
            }
        }
        return count
    }
}
*/

/*
Better Approach

class Solution {
    fun countIslands(grid: Array<IntArray>, k: Int): Int {
        val m = grid.size
        val n = grid[0].size
        val visited = Array(m) { BooleanArray(n) }
        val dirs = arrayOf(intArrayOf(1, 0), intArrayOf(-1, 0), intArrayOf(0, 1), intArrayOf(0, -1))
        var count = 0
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (grid[i][j] == 0 || visited[i][j]) continue
                val queue = ArrayDeque<IntArray>()
                queue.addLast(intArrayOf(i, j))
                visited[i][j] = true
                var sum = 0L
                while (queue.isNotEmpty()) {
                    val (r0, c0) = queue.removeFirst()
                    sum += grid[r0][c0]
                    for (d in dirs) {
                        val r = r0 + d[0]
                        val c = c0 + d[1]
                        if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r][c]) {
                            visited[r][c] = true
                            queue.addLast(intArrayOf(r, c))
                        }
                    }
                }
                if (sum % k == 0L) count++
            }
        }
        return count
    }
}
*/

class Solution {
    fun countIslands(grid: Array<IntArray>, k: Int): Int {
        val m = grid.size
        val n = grid[0].size
        val q = IntArray(m * n)
        val dr = intArrayOf(1, -1, 0, 0)
        val dc = intArrayOf(0, 0, 1, -1)
        var count = 0
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (grid[i][j] == 0) continue
                var head = 0
                var tail = 0
                var sum = grid[i][j] % k
                grid[i][j] = 0
                q[tail++] = i * n + j
                while (head < tail) {
                    val id = q[head++]
                    val r = id / n
                    val c = id % n
                    for (d in 0 until 4) {
                        val nr = r + dr[d]
                        val nc = c + dc[d]
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0) {
                            sum = (sum + grid[nr][nc]) % k
                            grid[nr][nc] = 0
                            q[tail++] = nr * n + nc
                        }
                    }
                }
                if (sum == 0) count++
            }
        }
        return count
    }
}