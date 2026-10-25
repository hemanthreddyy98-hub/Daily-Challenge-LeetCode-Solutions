/*
Brute Force

class Solution {
    func closedIsland(_ grid: [[Int]]) -> Int {
        let m = grid.count, n = grid[0].count
        let dr = [1, -1, 0, 0], dc = [0, 0, 1, -1]
        var count = 0
        for i in 0..<m {
            for j in 0..<n where grid[i][j] == 0 {
                var seen = [Bool](repeating: false, count: m * n)
                var stack = [i * n + j]
                seen[i * n + j] = true
                var closed = true, first = true
                while let id = stack.popLast() {
                    let r = id / n, c = id % n
                    if r == 0 || c == 0 || r == m - 1 || c == n - 1 { closed = false }
                    if id < i * n + j { first = false }
                    for k in 0..<4 {
                        let nr = r + dr[k], nc = c + dc[k]
                        if nr < 0 || nc < 0 || nr >= m || nc >= n { continue }
                        if grid[nr][nc] == 0 && !seen[nr * n + nc] {
                            seen[nr * n + nc] = true
                            stack.append(nr * n + nc)
                        }
                    }
                }
                if closed && first { count += 1 }
            }
        }
        return count
    }
}
*/

/*
Better Approach

class Solution {
    func closedIsland(_ grid: [[Int]]) -> Int {
        var g = grid
        let m = g.count, n = g[0].count
        func sink(_ r: Int, _ c: Int) {
            if r < 0 || c < 0 || r >= m || c >= n || g[r][c] != 0 { return }
            g[r][c] = 1
            sink(r + 1, c)
            sink(r - 1, c)
            sink(r, c + 1)
            sink(r, c - 1)
        }
        for i in 0..<m {
            sink(i, 0)
            sink(i, n - 1)
        }
        for j in 0..<n {
            sink(0, j)
            sink(m - 1, j)
        }
        var count = 0
        for i in 0..<m {
            for j in 0..<n where g[i][j] == 0 {
                sink(i, j)
                count += 1
            }
        }
        return count
    }
}
*/

class Solution {
    func closedIsland(_ grid: [[Int]]) -> Int {
        var g = grid
        let m = g.count, n = g[0].count
        var q = [Int](repeating: 0, count: m * n)
        let dr = [1, -1, 0, 0], dc = [0, 0, 1, -1]
        var count = 0
        for i in 0..<m {
            for j in 0..<n where g[i][j] == 0 {
                var head = 0, tail = 0
                var closed = true
                g[i][j] = 1
                q[tail] = i * n + j
                tail += 1
                while head < tail {
                    let id = q[head]
                    head += 1
                    let r = id / n, c = id % n
                    if r == 0 || c == 0 || r == m - 1 || c == n - 1 { closed = false }
                    for k in 0..<4 {
                        let nr = r + dr[k], nc = c + dc[k]
                        if nr < 0 || nc < 0 || nr >= m || nc >= n { continue }
                        if g[nr][nc] == 0 {
                            g[nr][nc] = 1
                            q[tail] = nr * n + nc
                            tail += 1
                        }
                    }
                }
                if closed { count += 1 }
            }
        }
        return count
    }
}