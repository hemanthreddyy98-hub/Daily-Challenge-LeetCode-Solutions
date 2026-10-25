/*
Brute Force

class Solution {
    public int closedIsland(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] != 0) continue;
                boolean[][] seen = new boolean[m][n];
                Deque<int[]> stack = new ArrayDeque<>();
                stack.push(new int[]{i, j});
                seen[i][j] = true;
                boolean closed = true, first = true;
                while (!stack.isEmpty()) {
                    int[] cur = stack.pop();
                    int r = cur[0], c = cur[1];
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                    if (r * n + c < i * n + j) first = false;
                    for (int k = 0; k < 4; k++) {
                        int nr = r + dr[k], nc = c + dc[k];
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0 && !seen[nr][nc]) {
                            seen[nr][nc] = true;
                            stack.push(new int[]{nr, nc});
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
    public int closedIsland(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        for (int i = 0; i < m; i++) {
            sink(grid, i, 0);
            sink(grid, i, n - 1);
        }
        for (int j = 0; j < n; j++) {
            sink(grid, 0, j);
            sink(grid, m - 1, j);
        }
        int count = 0;
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                if (grid[i][j] == 0) {
                    sink(grid, i, j);
                    count++;
                }
        return count;
    }

    void sink(int[][] grid, int r, int c) {
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
    public int closedIsland(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[] q = new int[m * n];
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] != 0) continue;
                int head = 0, tail = 0;
                boolean closed = true;
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