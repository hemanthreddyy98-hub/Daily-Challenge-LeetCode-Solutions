/*
Brute Force

class Solution {
    func uniquePaths(_ grid: [[Int]]) -> Int {
        let mod = 1_000_000_007
        let m = grid.count, n = grid[0].count
        func dfs(_ i: Int, _ j: Int, _ d: Int) -> Int {
            if i >= m || j >= n { return 0 }
            if i == m - 1 && j == n - 1 { return 1 }
            if grid[i][j] == 1 { return d == 0 ? dfs(i + 1, j, 1) : dfs(i, j + 1, 0) }
            return (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod
        }
        return dfs(0, 0, 0)
    }
}
*/

/*
Better Approach

class Solution {
    func uniquePaths(_ grid: [[Int]]) -> Int {
        let mod = 1_000_000_007
        let m = grid.count, n = grid[0].count
        var memo = [Int](repeating: -1, count: m * n * 2)
        func dfs(_ i: Int, _ j: Int, _ d: Int) -> Int {
            if i >= m || j >= n { return 0 }
            if i == m - 1 && j == n - 1 { return 1 }
            let key = (i * n + j) * 2 + d
            if memo[key] != -1 { return memo[key] }
            var res = 0
            if grid[i][j] == 0 {
                res = (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod
            } else if d == 0 {
                res = dfs(i + 1, j, 1)
            } else {
                res = dfs(i, j + 1, 0)
            }
            memo[key] = res
            return res
        }
        return dfs(0, 0, 0)
    }
}
*/

class Solution {
    func uniquePaths(_ grid: [[Int]]) -> Int {
        let mod = 1_000_000_007
        let m = grid.count, n = grid[0].count
        var r = [Int](repeating: 0, count: n)
        var d = [Int](repeating: 0, count: n)
        for i in 0..<m {
            for j in 0..<n {
                if i == 0 && j == 0 {
                    r[0] = 1
                    continue
                }
                let nd = i == 0 ? 0 : grid[i - 1][j] == 0 ? (r[j] + d[j]) % mod : r[j]
                let nr = j == 0 ? 0 : grid[i][j - 1] == 0 ? (r[j - 1] + d[j - 1]) % mod : d[j - 1]
                r[j] = nr
                d[j] = nd
            }
        }
        return (r[n - 1] + d[n - 1]) % mod
    }
}