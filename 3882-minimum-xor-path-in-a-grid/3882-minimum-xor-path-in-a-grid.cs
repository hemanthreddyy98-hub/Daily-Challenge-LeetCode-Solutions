/*
Brute Force

public class Solution {
    public int MinCost(int[][] grid) {
        return Dfs(grid, 0, 0, grid[0][0]);
    }

    int Dfs(int[][] grid, int i, int j, int x) {
        int m = grid.Length, n = grid[0].Length;
        if (i == m - 1 && j == n - 1) return x;
        int best = int.MaxValue;
        if (i + 1 < m) best = Math.Min(best, Dfs(grid, i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = Math.Min(best, Dfs(grid, i, j + 1, x ^ grid[i][j + 1]));
        return best;
    }
}
*/

/*
Better Approach

public class Solution {
    public int MinCost(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        int[] memo = new int[m * n * 1024];
        Array.Fill(memo, -1);
        return Dfs(grid, memo, 0, 0, grid[0][0]);
    }

    int Dfs(int[][] grid, int[] memo, int i, int j, int x) {
        int m = grid.Length, n = grid[0].Length;
        if (i == m - 1 && j == n - 1) return x;
        int key = (i * n + j) * 1024 + x;
        if (memo[key] != -1) return memo[key];
        int best = int.MaxValue;
        if (i + 1 < m) best = Math.Min(best, Dfs(grid, memo, i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = Math.Min(best, Dfs(grid, memo, i, j + 1, x ^ grid[i][j + 1]));
        return memo[key] = best;
    }
}
*/

public class Solution {
    public int MinCost(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        bool[][] dp = new bool[n][];
        for (int j = 0; j < n; j++) dp[j] = new bool[1024];
        bool[] tmp = new bool[1024];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                for (int x = 0; x < 1024; x++)
                    tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j - 1][x]);
                for (int x = 0; x < 1024; x++) dp[j][x ^ grid[i][j]] = tmp[x];
            }
        int ans = 0;
        while (!dp[n - 1][ans]) ans++;
        return ans;
    }
}