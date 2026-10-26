/*
Brute Force

public class Solution {
    public int CountIslands(int[][] grid, int k) {
        int m = grid.Length, n = grid[0].Length;
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) continue;
                bool[,] seen = new bool[m, n];
                var stack = new Stack<(int r, int c)>();
                stack.Push((i, j));
                seen[i, j] = true;
                long sum = 0;
                bool first = true;
                while (stack.Count > 0) {
                    var (r, c) = stack.Pop();
                    sum += grid[r][c];
                    if (r * n + c < i * n + j) first = false;
                    for (int d = 0; d < 4; d++) {
                        int nr = r + dr[d], nc = c + dc[d];
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 && !seen[nr, nc]) {
                            seen[nr, nc] = true;
                            stack.Push((nr, nc));
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

public class Solution {
    public int CountIslands(int[][] grid, int k) {
        int m = grid.Length, n = grid[0].Length;
        bool[,] visited = new bool[m, n];
        int[][] dirs = { new[] {1, 0}, new[] {-1, 0}, new[] {0, 1}, new[] {0, -1} };
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 || visited[i, j]) continue;
                var queue = new Queue<(int r, int c)>();
                queue.Enqueue((i, j));
                visited[i, j] = true;
                long sum = 0;
                while (queue.Count > 0) {
                    var (r0, c0) = queue.Dequeue();
                    sum += grid[r0][c0];
                    foreach (var d in dirs) {
                        int r = r0 + d[0], c = c0 + d[1];
                        if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r, c]) {
                            visited[r, c] = true;
                            queue.Enqueue((r, c));
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

public class Solution {
    public int CountIslands(int[][] grid, int k) {
        int m = grid.Length, n = grid[0].Length;
        int[] q = new int[m * n];
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) continue;
                int head = 0, tail = 0;
                int sum = grid[i][j] % k;
                grid[i][j] = 0;
                q[tail++] = i * n + j;
                while (head < tail) {
                    int id = q[head++];
                    int r = id / n, c = id % n;
                    for (int d = 0; d < 4; d++) {
                        int nr = r + dr[d], nc = c + dc[d];
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