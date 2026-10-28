/*
Brute Force

class Solution {
    public int minCost(int[][] grid) {
        return dfs(grid, 0, 0, grid[0][0]);
    }

    int dfs(int[][] grid, int i, int j, int x) {
        int m = grid.length, n = grid[0].length;
        if (i == m - 1 && j == n - 1) return x;
        int best = Integer.MAX_VALUE;
        if (i + 1 < m) best = Math.min(best, dfs(grid, i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = Math.min(best, dfs(grid, i, j + 1, x ^ grid[i][j + 1]));
        return best;
    }
}
*/

/*
Better Approach

class Solution {
    public int minCost(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[][][] memo = new int[m][n][1024];
        for (int[][] plane : memo)
            for (int[] row : plane) Arrays.fill(row, -1);
        return dfs(grid, memo, 0, 0, grid[0][0]);
    }

    int dfs(int[][] grid, int[][][] memo, int i, int j, int x) {
        int m = grid.length, n = grid[0].length;
        if (i == m - 1 && j == n - 1) return x;
        if (memo[i][j][x] != -1) return memo[i][j][x];
        int best = Integer.MAX_VALUE;
        if (i + 1 < m) best = Math.min(best, dfs(grid, memo, i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = Math.min(best, dfs(grid, memo, i, j + 1, x ^ grid[i][j + 1]));
        return memo[i][j][x] = best;
    }
}
*/

class Solution {
    public int minCost(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        boolean[][] dp = new boolean[n][1024];
        boolean[] tmp = new boolean[1024];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                for (int x = 0; x < 1024; x++)
                    tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j - 1][x]);
                for (int x = 0; x < 1024; x++) dp[j][x ^ grid[i][j]] = tmp[x];
            }
        int x = 0;
        while (!dp[n - 1][x]) x++;
        return x;
    }
}