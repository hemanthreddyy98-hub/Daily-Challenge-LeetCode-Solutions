/*
Brute Force

class Solution {
    func createGrid(_ m: Int, _ n: Int) -> [String] {
        var g = [[Character]](repeating: [Character](repeating: ".", count: n), count: m)
        func reach(_ r: Int, _ c: Int) -> Bool {
            if r >= m || c >= n || g[r][c] == "#" { return false }
            if r == m - 1 && c == n - 1 { return true }
            return reach(r + 1, c) || reach(r, c + 1)
        }
        for i in 0..<m {
            for j in 0..<n {
                if (i == 0 && j == 0) || (i == m - 1 && j == n - 1) { continue }
                g[i][j] = "#"
                if !reach(0, 0) { g[i][j] = "." }
            }
        }
        return g.map { String($0) }
    }
}
*/

/*
Better Approach

class Solution {
    func createGrid(_ m: Int, _ n: Int) -> [String] {
        var g = [[Character]](repeating: [Character](repeating: ".", count: n), count: m)
        func reach() -> Bool {
            var ok = [[Bool]](repeating: [Bool](repeating: false, count: n), count: m)
            for i in 0..<m {
                for j in 0..<n where g[i][j] != "#" {
                    ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1])
                }
            }
            return ok[m - 1][n - 1]
        }
        for i in 0..<m {
            for j in 0..<n {
                if (i == 0 && j == 0) || (i == m - 1 && j == n - 1) { continue }
                g[i][j] = "#"
                if !reach() { g[i][j] = "." }
            }
        }
        return g.map { String($0) }
    }
}
*/

class Solution {
    func createGrid(_ m: Int, _ n: Int) -> [String] {
        let rest = String(repeating: "#", count: n - 1) + "."
        return [String(repeating: ".", count: n)] + Array(repeating: rest, count: m - 1)
    }
}