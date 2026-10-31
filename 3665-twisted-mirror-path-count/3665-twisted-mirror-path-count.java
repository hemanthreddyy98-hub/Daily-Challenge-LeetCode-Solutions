/*
Brute Force

class Solution {
    final int MOD = 1_000_000_007;
    int m, n;
    int[][] grid;

    public int uniquePaths(int[][] grid) {
        this.grid = grid;
        m = grid.length;
        n = grid[0].length;
        return dfs(0, 0, 0);
    }

    int dfs(int i, int j, int d) {
        if (i >= m || j >= n) return 0;
        if (i == m - 1 && j == n - 1) return 1;
        if (grid[i][j] == 1) return d == 0 ? dfs(i + 1, j, 1) : dfs(i, j + 1, 0);
        return (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % MOD;
    }
}
*/

/*
Better Approach

class Solution {
    final int MOD = 1_000_000_007;
    int m, n;
    int[][] grid;
    int[][][] memo;

    public int uniquePaths(int[][] grid) {
        this.grid = grid;
        m = grid.length;
        n = grid[0].length;
        memo = new int[m][n][2];
        for (int[][] row : memo)
            for (int[] cell : row) Arrays.fill(cell, -1);
        return dfs(0, 0, 0);
    }

    int dfs(int i, int j, int d) {
        if (i >= m || j >= n) return 0;
        if (i == m - 1 && j == n - 1) return 1;
        if (memo[i][j][d] != -1) return memo[i][j][d];
        if (grid[i][j] == 1) return memo[i][j][d] = d == 0 ? dfs(i + 1, j, 1) : dfs(i, j + 1, 0);
        return memo[i][j][d] = (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % MOD;
    }
}
*/

class Solution {
    public int uniquePaths(int[][] grid) {
        final int MOD = 1_000_000_007;
        int m = grid.length, n = grid[0].length;
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