/*
Brute Force

class Solution {
  List<String> createGrid(int m, int n) {
    final List<List<String>> g = List.generate(m, (_) => List<String>.filled(n, '.'));
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
        g[i][j] = '#';
        if (!reach(g, 0, 0)) g[i][j] = '.';
      }
    }
    return g.map((row) => row.join()).toList();
  }

  bool reach(List<List<String>> g, int r, int c) {
    if (r >= g.length || c >= g[0].length || g[r][c] == '#') return false;
    if (r == g.length - 1 && c == g[0].length - 1) return true;
    return reach(g, r + 1, c) || reach(g, r, c + 1);
  }
}
*/

/*
Better Approach

class Solution {
  List<String> createGrid(int m, int n) {
    final List<List<String>> g = List.generate(m, (_) => List<String>.filled(n, '.'));
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
        g[i][j] = '#';
        if (!reach(g)) g[i][j] = '.';
      }
    }
    return g.map((row) => row.join()).toList();
  }

  bool reach(List<List<String>> g) {
    final int m = g.length, n = g[0].length;
    final List<List<bool>> ok = List.generate(m, (_) => List<bool>.filled(n, false));
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (g[i][j] == '#') continue;
        ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1]);
      }
    }
    return ok[m - 1][n - 1];
  }
}
*/

class Solution {
  List<String> createGrid(int m, int n) {
    final String rest = '#' * (n - 1) + '.';
    return ['.' * n, ...List<String>.filled(m - 1, rest)];
  }
}