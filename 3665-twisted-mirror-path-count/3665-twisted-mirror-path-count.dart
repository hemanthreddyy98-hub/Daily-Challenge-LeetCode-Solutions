/*
Brute Force

class Solution {
  int uniquePaths(List<List<int>> grid) {
    const int mod = 1000000007;
    int m = grid.length, n = grid[0].length;
    int dfs(int i, int j, int d) {
      if (i >= m || j >= n) return 0;
      if (i == m - 1 && j == n - 1) return 1;
      if (grid[i][j] == 1) return d == 0 ? dfs(i + 1, j, 1) : dfs(i, j + 1, 0);
      return (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod;
    }
    return dfs(0, 0, 0);
  }
}
*/

/*
Better Approach

class Solution {
  int uniquePaths(List<List<int>> grid) {
    const int mod = 1000000007;
    int m = grid.length, n = grid[0].length;
    List<int> memo = List<int>.filled(m * n * 2, -1);
    int dfs(int i, int j, int d) {
      if (i >= m || j >= n) return 0;
      if (i == m - 1 && j == n - 1) return 1;
      int key = (i * n + j) * 2 + d;
      if (memo[key] != -1) return memo[key];
      int res;
      if (grid[i][j] == 0) {
        res = (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % mod;
      } else if (d == 0) {
        res = dfs(i + 1, j, 1);
      } else {
        res = dfs(i, j + 1, 0);
      }
      return memo[key] = res;
    }
    return dfs(0, 0, 0);
  }
}
*/

class Solution {
  int uniquePaths(List<List<int>> grid) {
    const int mod = 1000000007;
    int m = grid.length, n = grid[0].length;
    List<int> r = List<int>.filled(n, 0);
    List<int> d = List<int>.filled(n, 0);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (i == 0 && j == 0) {
          r[0] = 1;
          continue;
        }
        int nd = i == 0 ? 0 : (grid[i - 1][j] == 0 ? (r[j] + d[j]) % mod : r[j]);
        int nr = j == 0 ? 0 : (grid[i][j - 1] == 0 ? (r[j - 1] + d[j - 1]) % mod : d[j - 1]);
        r[j] = nr;
        d[j] = nd;
      }
    }
    return (r[n - 1] + d[n - 1]) % mod;
  }
}