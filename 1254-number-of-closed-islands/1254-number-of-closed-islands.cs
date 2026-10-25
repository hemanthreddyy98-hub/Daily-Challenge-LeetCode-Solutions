/*
Brute Force

public class Solution {
    public int ClosedIsland(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] != 0) continue;
                bool[,] seen = new bool[m, n];
                var stack = new Stack<(int r, int c)>();
                stack.Push((i, j));
                seen[i, j] = true;
                bool closed = true, first = true;
                while (stack.Count > 0) {
                    var (r, c) = stack.Pop();
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                    if (r * n + c < i * n + j) first = false;
                    for (int k = 0; k < 4; k++) {
                        int nr = r + dr[k], nc = c + dc[k];
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0 && !seen[nr, nc]) {
                            seen[nr, nc] = true;
                            stack.Push((nr, nc));
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

public class Solution {
    public int ClosedIsland(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        for (int i = 0; i < m; i++) {
            Sink(grid, i, 0);
            Sink(grid, i, n - 1);
        }
        for (int j = 0; j < n; j++) {
            Sink(grid, 0, j);
            Sink(grid, m - 1, j);
        }
        int count = 0;
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                if (grid[i][j] == 0) {
                    Sink(grid, i, j);
                    count++;
                }
        return count;
    }

    void Sink(int[][] grid, int r, int c) {
        if (r < 0 || c < 0 || r >= grid.Length || c >= grid[0].Length || grid[r][c] != 0) return;
        grid[r][c] = 1;
        Sink(grid, r + 1, c);
        Sink(grid, r - 1, c);
        Sink(grid, r, c + 1);
        Sink(grid, r, c - 1);
    }
}
*/

public class Solution {
    public int ClosedIsland(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        int[] q = new int[m * n];
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] != 0) continue;
                int head = 0, tail = 0;
                bool closed = true;
                grid[i][j] = 1;
                q[tail++] = i * n + j;
                while (head < tail) {
                    int id = q[head++];
                    int r = id / n, c = id % n;
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                    for (int k = 0; k < 4; k++) {
                        int nr = r + dr[k], nc = c + dc[k];
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