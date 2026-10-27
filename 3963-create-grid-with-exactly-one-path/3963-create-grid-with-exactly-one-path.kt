/*
Brute Force

class Solution {
    fun createGrid(m: Int, n: Int): Array<String> {
        val g = Array(m) { CharArray(n) { '.' } }
        for (i in 0 until m)
            for (j in 0 until n) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue
                g[i][j] = '#'
                if (!reach(g, 0, 0)) g[i][j] = '.'
            }
        return Array(m) { String(g[it]) }
    }

    fun reach(g: Array<CharArray>, r: Int, c: Int): Boolean {
        if (r >= g.size || c >= g[0].size || g[r][c] == '#') return false
        if (r == g.size - 1 && c == g[0].size - 1) return true
        return reach(g, r + 1, c) || reach(g, r, c + 1)
    }
}
*/

/*
Better Approach

class Solution {
    fun createGrid(m: Int, n: Int): Array<String> {
        val g = Array(m) { CharArray(n) { '.' } }
        for (i in 0 until m)
            for (j in 0 until n) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue
                g[i][j] = '#'
                if (!reach(g)) g[i][j] = '.'
            }
        return Array(m) { String(g[it]) }
    }

    fun reach(g: Array<CharArray>): Boolean {
        val m = g.size
        val n = g[0].size
        val ok = Array(m) { BooleanArray(n) }
        for (i in 0 until m)
            for (j in 0 until n) {
                if (g[i][j] == '#') continue
                ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1])
            }
        return ok[m - 1][n - 1]
    }
}
*/

class Solution {
    fun createGrid(m: Int, n: Int): Array<String> {
        val rest = "#".repeat(n - 1) + "."
        return Array(m) { if (it == 0) ".".repeat(n) else rest }
    }
}