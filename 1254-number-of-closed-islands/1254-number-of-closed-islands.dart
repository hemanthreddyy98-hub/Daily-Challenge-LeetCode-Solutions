/*
Brute Force

class Solution {
  int closedIsland(List<List<int>> grid) {
    final int m = grid.length, n = grid[0].length;
    const List<int> dr = [1, -1, 0, 0];
    const List<int> dc = [0, 0, 1, -1];
    int count = 0;
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] != 0) continue;
        final List<bool> seen = List<bool>.filled(m * n, false);
        final List<int> stack = [i * n + j];
        seen[i * n + j] = true;
        bool closed = true, first = true;
        while (stack.isNotEmpty) {
          final int id = stack.removeLast();
          final int r = id ~/ n, c = id % n;
          if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
          if (id < i * n + j) first = false;
          for (int k = 0; k < 4; k++) {
            final int nr = r + dr[k], nc = c + dc[k];
            if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
            if (grid[nr][nc] == 0 && !seen[nr * n + nc]) {
              seen[nr * n + nc] = true;
              stack.add(nr * n + nc);
            }
          }
        }
        if (closed && first) count++;
      }
    }
    return count;
  }
}
*/

/*
Better Approach

class Solution {
  int closedIsland(List<List<int>> grid) {
    final int m = grid.length, n = grid[0].length;
    for (int i = 0; i < m; i++) {
      sink(grid, i, 0);
      sink(grid, i, n - 1);
    }
    for (int j = 0; j < n; j++) {
      sink(grid, 0, j);
      sink(grid, m - 1, j);
    }
    int count = 0;
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] == 0) {
          sink(grid, i, j);
          count++;
        }
      }
    }
    return count;
  }

  void sink(List<List<int>> grid, int r, int c) {
    if (r < 0 || c < 0 || r >= grid.length || c >= grid[0].length || grid[r][c] != 0) return;
    grid[r][c] = 1;
    sink(grid, r + 1, c);
    sink(grid, r - 1, c);
    sink(grid, r, c + 1);
    sink(grid, r, c - 1);
  }
}
*/

class Solution {
  int closedIsland(List<List<int>> grid) {
    final int m = grid.length, n = grid[0].length;
    final List<int> q = List<int>.filled(m * n, 0);
    const List<int> dr = [1, -1, 0, 0];
    const List<int> dc = [0, 0, 1, -1];
    int count = 0;
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] != 0) continue;
        int head = 0, tail = 0;
        bool closed = true;
        grid[i][j] = 1;
        q[tail++] = i * n + j;
        while (head < tail) {
          final int id = q[head++];
          final int r = id ~/ n, c = id % n;
          if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
          for (int k = 0; k < 4; k++) {
            final int nr = r + dr[k], nc = c + dc[k];
            if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0) {
              grid[nr][nc] = 1;
              q[tail++] = nr * n + nc;
            }
          }
        }
        if (closed) count++;
      }
    }
    return count;
  }
}