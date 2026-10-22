/*
Brute Force

class Solution {
    private var best = Int.max

    func getFood(_ grid: [[Character]]) -> Int {
        var g = grid
        best = Int.max
        for i in 0..<g.count {
            for j in 0..<g[0].count where g[i][j] == "*" {
                dfs(&g, i, j, 0)
            }
        }
        return best == Int.max ? -1 : best
    }

    private func dfs(_ g: inout [[Character]], _ r: Int, _ c: Int, _ steps: Int) {
        if r < 0 || c < 0 || r >= g.count || c >= g[0].count { return }
        let ch = g[r][c]
        if ch == "X" || ch == "V" { return }
        if ch == "#" {
            best = min(best, steps)
            return
        }
        g[r][c] = "V"
        dfs(&g, r + 1, c, steps + 1)
        dfs(&g, r - 1, c, steps + 1)
        dfs(&g, r, c + 1, steps + 1)
        dfs(&g, r, c - 1, steps + 1)
        g[r][c] = ch
    }
}
*/

/*
Basic Approach

class Solution {
    func getFood(_ grid: [[Character]]) -> Int {
        let m = grid.count, n = grid[0].count
        var queue = [(Int, Int)]()
        var visited = Array(repeating: Array(repeating: false, count: n), count: m)
        for i in 0..<m {
            for j in 0..<n where grid[i][j] == "*" {
                queue.append((i, j))
                visited[i][j] = true
            }
        }
        let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        var head = 0
        var steps = 0
        while head < queue.count {
            let size = queue.count - head
            for _ in 0..<size {
                let (r0, c0) = queue[head]
                head += 1
                if grid[r0][c0] == "#" { return steps }
                for (dr, dc) in dirs {
                    let r = r0 + dr, c = c0 + dc
                    if r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != "X" {
                        visited[r][c] = true
                        queue.append((r, c))
                    }
                }
            }
            steps += 1
        }
        return -1
    }
}
*/

class Solution {
    func getFood(_ grid: [[Character]]) -> Int {
        var g = grid
        let m = g.count, n = g[0].count

        var start = -1
        for i in 0..<m {
            if let j = g[i].firstIndex(of: "*") {
                start = i * n + j
                break
            }
        }
        if start < 0 { return -1 }

        var q = [Int](repeating: 0, count: m * n)
        var head = 0, tail = 0
        q[tail] = start
        tail += 1
        let dr = [1, -1, 0, 0], dc = [0, 0, 1, -1]
        var steps = 0

        while head < tail {
            steps += 1
            let levelEnd = tail
            while head < levelEnd {
                let id = q[head]
                head += 1
                let r = id / n, c = id % n
                for k in 0..<4 {
                    let nr = r + dr[k], nc = c + dc[k]
                    if nr < 0 || nc < 0 || nr >= m || nc >= n { continue }
                    let ch = g[nr][nc]
                    if ch == "#" { return steps }
                    if ch == "O" {
                        g[nr][nc] = "X"
                        q[tail] = nr * n + nc
                        tail += 1
                    }
                }
            }
        }
        return -1
    }
}