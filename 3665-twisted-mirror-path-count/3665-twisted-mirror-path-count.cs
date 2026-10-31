/*
Brute Force

public class Solution {
    const int MOD = 1000000007;
    int m, n;
    int[][] grid;

    public int UniquePaths(int[][] grid) {
        this.grid = grid;
        m = grid.Length;
        n = grid[0].Length;
        return Dfs(0, 0, 0);
    }

    int Dfs(int i, int j, int d) {
        if (i >= m || j >= n) return 0;
        if (i == m - 1 && j == n - 1) return 1;
        if (grid[i][j] == 1) return d == 0 ? Dfs(i + 1, j, 1) : Dfs(i, j + 1, 0);
        return (Dfs(i, j + 1, 0) + Dfs(i + 1, j, 1)) % MOD;
    }
}
*/

/*
Better Approach

public class Solution {
    const int MOD = 1000000007;
    int m, n;
    int[][] grid;
    int[,,] memo;

    public int UniquePaths(int[][] grid) {
        this.grid = grid;
        m = grid.Length;
        n = grid[0].Length;
        memo = new int[m, n, 2];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) memo[i, j, 0] = memo[i, j, 1] = -1;
        return Dfs(0, 0, 0);
    }

    int Dfs(int i, int j, int d) {
        if (i >= m || j >= n) return 0;
        if (i == m - 1 && j == n - 1) return 1;
        if (memo[i, j, d] != -1) return memo[i, j, d];
        if (grid[i][j] == 1) return memo[i, j, d] = d == 0 ? Dfs(i + 1, j, 1) : Dfs(i, j + 1, 0);
        return memo[i, j, d] = (Dfs(i, j + 1, 0) + Dfs(i + 1, j, 1)) % MOD;
    }
}
*/

public class Solution {
    public int UniquePaths(int[][] grid) {
        const int MOD = 1000000007;
        int m = grid.Length, n = grid[0].Length;
        int[] r = new int[n], d = new int[n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j == 0) {
                    r[0] = 1;
                    continue;
                }
                int nd = i == 0 ? 0 : grid[i - 1][j] == 0 ? (r[j] + d[j]) % MOD : r[j];
                int nr = j == 0 ? 0 : grid[i][j - 1] == 0 ? (r[j - 1] + d[j - 1]) % MOD : d[j - 1];
                r[j] = nr;
                d[j] = nd;
            }
        }
        return (r[n - 1] + d[n - 1]) % MOD;
    }
}