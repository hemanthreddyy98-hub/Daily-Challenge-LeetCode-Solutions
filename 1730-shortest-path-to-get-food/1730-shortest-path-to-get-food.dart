/*
Brute Force

class Solution {
  static const int inf = 1 << 30;
  int best = inf;

  int getFood(List<List<String>> grid) {
    best = inf;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (grid[i][j] == '*') dfs(grid, i, j, 0);
      }
    }
    return best == inf ? -1 : best;
  }

  void dfs(List<List<String>> grid, int r, int c, int steps) {
    if (r < 0 || c < 0 || r >= grid.length || c >= grid[0].length) return;
    final String ch = grid[r][c];
    if (ch == 'X' || ch == 'V') return;
    if (ch == '#') {
      if (steps < best) best = steps;
      return;
    }
    grid[r][c] = 'V';
    dfs(grid, r + 1, c, steps + 1);
    dfs(grid, r - 1, c, steps + 1);
    dfs(grid, r, c + 1, steps + 1);
    dfs(grid, r, c - 1, steps + 1);
    grid[r][c] = ch;
  }
}
*/

/*
Basic Approach

import 'dart:collection';

class Solution {
  int getFood(List<List<String>> grid) {
    final int m = grid.length, n = grid[0].length;
    final Queue<List<int>> queue = Queue<List<int>>();
    final List<List<bool>> visited = List.generate(m, (_) => List<bool>.filled(n, false));
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] == '*') {
          queue.add([i, j]);
          visited[i][j] = true;
        }
      }
    }
    const List<List<int>> dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    int steps = 0;
    while (queue.isNotEmpty) {
      final int size = queue.length;
      for (int k = 0; k < size; k++) {
        final List<int> cur = queue.removeFirst();
        if (grid[cur[0]][cur[1]] == '#') return steps;
        for (final List<int> d in dirs) {
          final int r = cur[0] + d[0], c = cur[1] + d[1];
          if (r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != 'X') {
            visited[r][c] = true;
            queue.add([r, c]);
          }
        }
      }
      steps++;
    }
    return -1;
  }
}
*/

class Solution {
  int getFood(List<List<String>> grid) {
    final int m = grid.length, n = grid[0].length;

    int start = -1;
    for (int i = 0; i < m; i++) {
      final int j = grid[i].indexOf('*');
      if (j != -1) {
        start = i * n + j;
        break;
      }
    }
    if (start < 0) return -1;

    final List<int> q = List<int>.filled(m * n, 0);
    int head = 0, tail = 0;
    q[tail++] = start;
    const List<int> dr = [1, -1, 0, 0];
    const List<int> dc = [0, 0, 1, -1];
    int steps = 0;

    while (head < tail) {
      steps++;
      final int levelEnd = tail;
      while (head < levelEnd) {
        final int id = q[head++];
        final int r = id ~/ n, c = id % n;
        for (int k = 0; k < 4; k++) {
          final int nr = r + dr[k], nc = c + dc[k];
          if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
          final String ch = grid[nr][nc];
          if (ch == '#') return steps;
          if (ch == 'O') {
            grid[nr][nc] = 'X';
            q[tail++] = nr * n + nc;
          }
        }
      }
    }
    return -1;
  }
}