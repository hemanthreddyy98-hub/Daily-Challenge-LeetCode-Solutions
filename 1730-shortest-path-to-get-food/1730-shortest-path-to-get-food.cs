/*
Brute Force

public class Solution {
    private int best;

    public int GetFood(char[][] grid) {
        best = int.MaxValue;
        for (int i = 0; i < grid.Length; i++)
            for (int j = 0; j < grid[0].Length; j++)
                if (grid[i][j] == '*') Dfs(grid, i, j, 0);
        return best == int.MaxValue ? -1 : best;
    }

    private void Dfs(char[][] grid, int r, int c, int steps) {
        if (r < 0 || c < 0 || r >= grid.Length || c >= grid[0].Length) return;
        char ch = grid[r][c];
        if (ch == 'X' || ch == 'V') return;
        if (ch == '#') {
            best = Math.Min(best, steps);
            return;
        }
        grid[r][c] = 'V';
        Dfs(grid, r + 1, c, steps + 1);
        Dfs(grid, r - 1, c, steps + 1);
        Dfs(grid, r, c + 1, steps + 1);
        Dfs(grid, r, c - 1, steps + 1);
        grid[r][c] = ch;
    }
}
*/

/*
Basic Approach

public class Solution {
    public int GetFood(char[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        var queue = new Queue<(int r, int c)>();
        bool[,] visited = new bool[m, n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == '*') {
                    queue.Enqueue((i, j));
                    visited[i, j] = true;
                }
            }
        }
        int[][] dirs = { new[] {1, 0}, new[] {-1, 0}, new[] {0, 1}, new[] {0, -1} };
        int steps = 0;
        while (queue.Count > 0) {
            int size = queue.Count;
            for (int k = 0; k < size; k++) {
                var (r0, c0) = queue.Dequeue();
                if (grid[r0][c0] == '#') return steps;
                foreach (var d in dirs) {
                    int r = r0 + d[0], c = c0 + d[1];
                    if (r >= 0 && c >= 0 && r < m && c < n && !visited[r, c] && grid[r][c] != 'X') {
                        visited[r, c] = true;
                        queue.Enqueue((r, c));
                    }
                }
            }
            steps++;
        }
        return -1;
    }
}
*/

public class Solution {
    public int GetFood(char[][] grid) {
        int m = grid.Length, n = grid[0].Length;

        int start = -1;
        for (int i = 0; i < m; i++) {
            int j = Array.IndexOf(grid[i], '*');
            if (j != -1) { start = i * n + j; break; }
        }
        if (start < 0) return -1;

        int[] q = new int[m * n];
        int head = 0, tail = 0;
        q[tail++] = start;
        int[] dr = {1, -1, 0, 0};
        int[] dc = {0, 0, 1, -1};
        int steps = 0;

        while (head < tail) {
            steps++;
            int levelEnd = tail;
            while (head < levelEnd) {
                int id = q[head++];
                int r = id / n, c = id % n;
                for (int k = 0; k < 4; k++) {
                    int nr = r + dr[k], nc = c + dc[k];
                    if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
                    char ch = grid[nr][nc];
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