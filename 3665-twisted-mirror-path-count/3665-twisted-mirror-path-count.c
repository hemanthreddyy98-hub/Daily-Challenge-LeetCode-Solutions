/*
Brute Force

int dfs(int** grid, int m, int n, int i, int j, int d) {
    if (i >= m || j >= n) return 0;
    if (i == m - 1 && j == n - 1) return 1;
    if (grid[i][j] == 1) return d == 0 ? dfs(grid, m, n, i + 1, j, 1) : dfs(grid, m, n, i, j + 1, 0);
    return (dfs(grid, m, n, i, j + 1, 0) + dfs(grid, m, n, i + 1, j, 1)) % 1000000007;
}

int uniquePaths(int** grid, int gridSize, int* gridColSize) {
    return dfs(grid, gridSize, gridColSize[0], 0, 0, 0);
}
*/

/*
Better Approach

int dfs(int** grid, int m, int n, int* memo, int i, int j, int d) {
    if (i >= m || j >= n) return 0;
    if (i == m - 1 && j == n - 1) return 1;
    int key = (i * n + j) * 2 + d;
    if (memo[key] != -1) return memo[key];
    if (grid[i][j] == 1)
        return memo[key] = d == 0 ? dfs(grid, m, n, memo, i + 1, j, 1) : dfs(grid, m, n, memo, i, j + 1, 0);
    return memo[key] = (dfs(grid, m, n, memo, i, j + 1, 0) + dfs(grid, m, n, memo, i + 1, j, 1)) % 1000000007;
}

int uniquePaths(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int* memo = (int*)malloc(sizeof(int) * m * n * 2);
    for (int i = 0; i < m * n * 2; i++) memo[i] = -1;
    int ans = dfs(grid, m, n, memo, 0, 0, 0);
    free(memo);
    return ans;
}
*/

int uniquePaths(int** grid, int gridSize, int* gridColSize) {
    const int MOD = 1000000007;
    int m = gridSize, n = gridColSize[0];
    int* r = (int*)calloc(n, sizeof(int));
    int* d = (int*)calloc(n, sizeof(int));
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
    int ans = (r[n - 1] + d[n - 1]) % MOD;
    free(r);
    free(d);
    return ans;
}