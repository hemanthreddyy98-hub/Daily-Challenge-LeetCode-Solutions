/*
Brute Force

class Solution {
  int countIslands(List<List<int>> grid, int k) {
    final int m = grid.length, n = grid[0].length;
    const List<int> dr = [1, -1, 0, 0];
    const List<int> dc = [0, 0, 1, -1];
    int count = 0;
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] == 0) continue;
        final List<bool> seen = List<bool>.filled(m * n, false);
        final List<int> stack = [i * n + j];
        seen[i * n + j] = true;
        int sum = 0;
        bool first = true;
        while (stack.isNotEmpty) {
          final int id = stack.removeLast();
          final int r = id ~/ n, c = id % n;
          sum += grid[r][c];
          if (id < i * n + j) first = false;
          for (int d = 0; d < 4; d++) {
            final int nr = r + dr[d], nc = c + dc[d];
            if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
            if (grid[nr][nc] > 0 && !seen[nr * n + nc]) {
              seen[nr * n + nc] = true;
              stack.add(nr * n + nc);
            }
          }
        }
        if (first && sum % k == 0) count++;
      }
    }
    return count;
  }
}
*/

/*
Better Approach

import 'dart:collection';

class Solution {
  int countIslands(List<List<int>> grid, int k) {
    final int m = grid.length, n = grid[0].length;
    final List<List<bool>> visited = List.generate(m, (_) => List<bool>.filled(n, false));
    const List<List<int>> dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    int count = 0;
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] == 0 || visited[i][j]) continue;
        final Queue<List<int>> queue = Queue<List<int>>();
        queue.add([i, j]);
        visited[i][j] = true;
        int sum = 0;
        while (queue.isNotEmpty) {
          final List<int> cur = queue.removeFirst();
          sum += grid[cur[0]][cur[1]];
          for (final List<int> d in dirs) {
            final int r = cur[0] + d[0], c = cur[1] + d[1];
            if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r][c]) {
              visited[r][c] = true;
              queue.add([r, c]);
            }
          }
        }
        if (sum % k == 0) count++;
      }
    }
    return count;
  }
}
*/

class Solution {
  int countIslands(List<List<int>> grid, int k) {
    final int m = grid.length, n = grid[0].length;
    final List<int> q = List<int>.filled(m * n, 0);
    const List<int> dr = [1, -1, 0, 0];
    const List<int> dc = [0, 0, 1, -1];
    int count = 0;
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] == 0) continue;
        int head = 0, tail = 0;
        int sum = grid[i][j] % k;
        grid[i][j] = 0;
        q[tail++] = i * n + j;
        while (head < tail) {
          final int id = q[head++];
          final int r = id ~/ n, c = id % n;
          for (int d = 0; d < 4; d++) {
            final int nr = r + dr[d], nc = c + dc[d];
            if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0) {
              sum = (sum + grid[nr][nc]) % k;
              grid[nr][nc] = 0;
              q[tail++] = nr * n + nc;
            }
          }
        }
        if (sum == 0) count++;
      }
    }
    return count;
  }
}