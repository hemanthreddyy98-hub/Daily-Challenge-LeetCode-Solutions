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
                    int cur = q[head++];
                    int r = cur / n, c = cur % n;
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                    for (int d = 0; d < 4; d++) {
                        int nr = r + dr[d], nc = c + dc[d];
                        if (nr >= 0 && nr < m && nc >= 0 && nc < n && grid[nr][nc] == 0) {
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