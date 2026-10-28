/*
Brute Force

class Solution {
  int minCost(List<List<int>> grid) {
    return dfs(grid, 0, 0, grid[0][0]);
  }

  int dfs(List<List<int>> grid, int i, int j, int x) {
    int m = grid.length, n = grid[0].length;
    if (i == m - 1 && j == n - 1) return x;
    int best = 1 << 30;
    if (i + 1 < m) {
      int r = dfs(grid, i + 1, j, x ^ grid[i + 1][j]);
      if (r < best) best = r;
    }
    if (j + 1 < n) {
      int r = dfs(grid, i, j + 1, x ^ grid[i][j + 1]);
      if (r < best) best = r;
    }
    return best;
  }
}
*/

/*
Better Approach

class Solution {
  int minCost(List<List<int>> grid) {
    List<int> memo = List<int>.filled(grid.length * grid[0].length * 1024, -1);
    return dfs(grid, memo, 0, 0, grid[0][0]);
  }

  int dfs(List<List<int>> grid, List<int> memo, int i, int j, int x) {
    int m = grid.length, n = grid[0].length;
    if (i == m - 1 && j == n - 1) return x;
    int key = (i * n + j) * 1024 + x;
    if (memo[key] != -1) return memo[key];
    int best = 1 << 30;
    if (i + 1 < m) {
      int r = dfs(grid, memo, i + 1, j, x ^ grid[i + 1][j]);
      if (r < best) best = r;
    }
    if (j + 1 < n) {
      int r = dfs(grid, memo, i, j + 1, x ^ grid[i][j + 1]);
      if (r < best) best = r;
    }
    memo[key] = best;
    return best;
  }
}
*/

class Solution {
  int minCost(List<List<int>> grid) {
    int m = grid.length, n = grid[0].length;
    List<List<bool>> dp = List.generate(n, (_) => List<bool>.filled(1024, false));
    List<bool> tmp = List<bool>.filled(1024, false);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        for (int x = 0; x < 1024; x++) {
          tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j - 1][x]);
        }
        for (int x = 0; x < 1024; x++) {
          dp[j][x ^ grid[i][j]] = tmp[x];
        }
      }
    }
    int x = 0;
    while (!dp[n - 1][x]) x++;
    return x;
  }
}