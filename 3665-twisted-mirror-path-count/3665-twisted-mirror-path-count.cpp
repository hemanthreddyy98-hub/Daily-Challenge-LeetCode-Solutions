/*
Brute Force

class Solution {
public:
    const int MOD = 1e9 + 7;
    int m, n;

    int dfs(vector<vector<int>>& grid, int i, int j, int d) {
        if (i >= m || j >= n) return 0;
        if (i == m - 1 && j == n - 1) return 1;
        if (grid[i][j] == 1) return d == 0 ? dfs(grid, i + 1, j, 1) : dfs(grid, i, j + 1, 0);
        return (dfs(grid, i, j + 1, 0) + dfs(grid, i + 1, j, 1)) % MOD;
    }

    int uniquePaths(vector<vector<int>>& grid) {
        m = grid.size();
        n = grid[0].size();
        return dfs(grid, 0, 0, 0);
    }
};
*/

/*
Better Approach

class Solution {
public:
    const int MOD = 1e9 + 7;
    int m, n;
    vector<vector<array<int, 2>>> memo;

    int dfs(vector<vector<int>>& grid, int i, int j, int d) {
        if (i >= m || j >= n) return 0;
        if (i == m - 1 && j == n - 1) return 1;
        if (memo[i][j][d] != -1) return memo[i][j][d];
        if (grid[i][j] == 1) return memo[i][j][d] = d == 0 ? dfs(grid, i + 1, j, 1) : dfs(grid, i, j + 1, 0);
        return memo[i][j][d] = (dfs(grid, i, j + 1, 0) + dfs(grid, i + 1, j, 1)) % MOD;
    }

    int uniquePaths(vector<vector<int>>& grid) {
        m = grid.size();
        n = grid[0].size();
        memo.assign(m, vector<array<int, 2>>(n, {-1, -1}));
        return dfs(grid, 0, 0, 0);
    }
};
*/

class Solution {
public:
    int uniquePaths(vector<vector<int>>& grid) {
        const int MOD = 1e9 + 7;
        int m = grid.size(), n = grid[0].size();
        vector<int> r(n, 0), d(n, 0);
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
};