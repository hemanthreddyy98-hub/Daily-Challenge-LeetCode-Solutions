/*
Brute Force

class Solution {
public:
    int minCost(vector<vector<int>>& grid) {
        return dfs(grid, 0, 0, grid[0][0]);
    }

    int dfs(vector<vector<int>>& grid, int i, int j, int x) {
        int m = grid.size(), n = grid[0].size();
        if (i == m - 1 && j == n - 1) return x;
        int best = INT_MAX;
        if (i + 1 < m) best = min(best, dfs(grid, i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = min(best, dfs(grid, i, j + 1, x ^ grid[i][j + 1]));
        return best;
    }
};
*/

/*
Better Approach

class Solution {
public:
    int minCost(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<vector<int>>> memo(m, vector<vector<int>>(n, vector<int>(1024, -1)));
        return dfs(grid, memo, 0, 0, grid[0][0]);
    }

    int dfs(vector<vector<int>>& grid, vector<vector<vector<int>>>& memo, int i, int j, int x) {
        int m = grid.size(), n = grid[0].size();
        if (i == m - 1 && j == n - 1) return x;
        if (memo[i][j][x] != -1) return memo[i][j][x];
        int best = INT_MAX;
        if (i + 1 < m) best = min(best, dfs(grid, memo, i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = min(best, dfs(grid, memo, i, j + 1, x ^ grid[i][j + 1]));
        return memo[i][j][x] = best;
    }
};
*/

class Solution {
public:
    int minCost(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<bool>> dp(n, vector<bool>(1024, false));
        vector<bool> tmp(1024);
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
};