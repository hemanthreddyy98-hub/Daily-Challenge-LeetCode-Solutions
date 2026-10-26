/*
Brute Force

class Solution {
    func countIslands(_ grid: [[Int]], _ k: Int) -> Int {
        let m = grid.count, n = grid[0].count
        let dr = [1, -1, 0, 0], dc = [0, 0, 1, -1]
        var count = 0
        for i in 0..<m {
            for j in 0..<n where grid[i][j] > 0 {
                var seen = [Bool](repeating: false, count: m * n)
                var stack = [i * n + j]
                seen[i * n + j] = true
                var sum = 0
                var first = true
                while let id = stack.popLast() {
                    let r = id / n, c = id % n
                    sum += grid[r][c]
                    if id < i * n + j { first = false }
                    for d in 0..<4 {
                        let nr = r + dr[d], nc = c + dc[d]
                        if nr < 0 || nc < 0 || nr >= m || nc >= n { continue }
                        if grid[nr][nc] > 0 && !seen[nr * n + nc] {
                            seen[nr * n + nc] = true
                            stack.append(nr * n + nc)
                        }
                    }
                }
                if first && sum % k == 0 { count += 1 }
            }
        }
        return count
    }
}
*/

/*
Better Approach

class Solution {
    func countIslands(_ grid: [[Int]], _ k: Int) -> Int {
        let m = grid.count, n = grid[0].count
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: n), count: m)
        let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        var count = 0
        for i in 0..<m {
            for j in 0..<n where grid[i][j] > 0 && !visited[i][j] {
                var queue = [(i, j)]
                visited[i][j] = true
                var head = 0
                var sum = 0
                while head < queue.count {
                    let (r0, c0) = queue[head]
                    head += 1
                    sum += grid[r0][c0]
                    for (dr, dc) in dirs {
                        let r = r0 + dr, c = c0 + dc
                        if r < 0 || c < 0 || r >= m || c >= n { continue }
                        if grid[r][c] > 0 && !visited[r][c] {
                            visited[r][c] = true
                            queue.append((r, c))
                        }
                    }
                }
                if sum % k == 0 { count += 1 }
            }
        }
        return count
    }
}
*/

class Solution {
    func countIslands(_ grid: [[Int]], _ k: Int) -> Int {
        var g = grid
        let m = g.count, n = g[0].count
        var q = [Int](repeating: 0, count: m * n)
        let dr = [1, -1, 0, 0], dc = [0, 0, 1, -1]
        var count = 0
        for i in 0..<m {
            for j in 0..<n where g[i][j] > 0 {
                var head = 0, tail = 0
                var sum = g[i][j] % k
                g[i][j] = 0
                q[tail] = i * n + j
                tail += 1
                while head < tail {
                    let id = q[head]
                    head += 1
                    let r = id / n, c = id % n
                    for d in 0..<4 {
                        let nr = r + dr[d], nc = c + dc[d]
                        if nr < 0 || nc < 0 || nr >= m || nc >= n { continue }
                        if g[nr][nc] > 0 {
                            sum = (sum + g[nr][nc]) % k
                            g[nr][nc] = 0
                            q[tail] = nr * n + nc
                            tail += 1
                        }
                    }
                }
                if sum == 0 { count += 1 }
            }
        }
        return count
    }
}