/*
Brute Force

class Solution {
    func minCost(_ grid: [[Int]]) -> Int {
        let m = grid.count, n = grid[0].count
        func dfs(_ i: Int, _ j: Int, _ x: Int) -> Int {
            if i == m - 1 && j == n - 1 { return x }
            var best = Int.max
            if i + 1 < m { best = min(best, dfs(i + 1, j, x ^ grid[i + 1][j])) }
            if j + 1 < n { best = min(best, dfs(i, j + 1, x ^ grid[i][j + 1])) }
            return best
        }
        return dfs(0, 0, grid[0][0])
    }
}
*/

/*
Better Approach

class Solution {
    func minCost(_ grid: [[Int]]) -> Int {
        let m = grid.count, n = grid[0].count
        var memo = [Int](repeating: -1, count: m * n * 1024)
        func dfs(_ i: Int, _ j: Int, _ x: Int) -> Int {
            if i == m - 1 && j == n - 1 { return x }
            let key = (i * n + j) * 1024 + x
            if memo[key] != -1 { return memo[key] }
            var best = Int.max
            if i + 1 < m { best = min(best, dfs(i + 1, j, x ^ grid[i + 1][j])) }
            if j + 1 < n { best = min(best, dfs(i, j + 1, x ^ grid[i][j + 1])) }
            memo[key] = best
            return best
        }
        return dfs(0, 0, grid[0][0])
    }
}
*/

class Solution {
    func minCost(_ grid: [[Int]]) -> Int {
        let m = grid.count, n = grid[0].count
        var dp = [[Bool]](repeating: [Bool](repeating: false, count: 1024), count: n)
        var tmp = [Bool](repeating: false, count: 1024)
        for i in 0..<m {
            for j in 0..<n {
                for x in 0..<1024 {
                    let start = i == 0 && j == 0 && x == 0
                    let up = i > 0 && dp[j][x]
                    let left = j > 0 && dp[j - 1][x]
                    tmp[x] = start || up || left
                }
                for x in 0..<1024 {
                    dp[j][x ^ grid[i][j]] = tmp[x]
                }
            }
        }
        var x = 0
        while !dp[n - 1][x] { x += 1 }
        return x
    }
}