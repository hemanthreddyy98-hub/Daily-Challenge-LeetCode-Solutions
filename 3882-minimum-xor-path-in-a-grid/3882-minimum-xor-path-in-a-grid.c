/*
Brute Force

int dfs(int** grid, int m, int n, int i, int j, int x) {
    if (i == m - 1 && j == n - 1) return x;
    int best = INT_MAX;
    if (i + 1 < m) {
        int r = dfs(grid, m, n, i + 1, j, x ^ grid[i + 1][j]);
        if (r < best) best = r;
    }
    if (j + 1 < n) {
        int r = dfs(grid, m, n, i, j + 1, x ^ grid[i][j + 1]);
        if (r < best) best = r;
    }
    return best;
}

int minCost(int** grid, int gridSize, int* gridColSize) {
    return dfs(grid, gridSize, gridColSize[0], 0, 0, grid[0][0]);
}
*/

/*
Better Approach

int dfs(int** grid, int m, int n, int* memo, int i, int j, int x) {
    if (i == m - 1 && j == n - 1) return x;
    int key = (i * n + j) * 1024 + x;
    if (memo[key] != -1) return memo[key];
    int best = INT_MAX;
    if (i + 1 < m) {
        int r = dfs(grid, m, n, memo, i + 1, j, x ^ grid[i + 1][j]);
        if (r < best) best = r;
    }
    if (j + 1 < n) {
        int r = dfs(grid, m, n, memo, i, j + 1, x ^ grid[i][j + 1]);
        if (r < best) best = r;
    }
    return memo[key] = best;
}

int minCost(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int* memo = (int*)malloc(sizeof(int) * m * n * 1024);
    memset(memo, -1, sizeof(int) * m * n * 1024);
    int ans = dfs(grid, m, n, memo, 0, 0, grid[0][0]);
    free(memo);
    return ans;
}
*/

int minCost(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    bool* dp = (bool*)calloc(n * 1024, sizeof(bool));
    bool tmp[1024];
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) {
            for (int x = 0; x < 1024; x++)
                tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j * 1024 + x]) || (j > 0 && dp[(j - 1) * 1024 + x]);
            for (int x = 0; x < 1024; x++) dp[j * 1024 + (x ^ grid[i][j])] = tmp[x];
        }
    int x = 0;
    while (!dp[(n - 1) * 1024 + x]) x++;
    free(dp);
    return x;
}