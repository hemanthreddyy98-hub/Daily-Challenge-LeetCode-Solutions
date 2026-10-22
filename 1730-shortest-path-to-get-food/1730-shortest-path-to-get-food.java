/*
Brute Force

class Solution {
    private int best;

    public int getFood(char[][] grid) {
        best = Integer.MAX_VALUE;
        for (int i = 0; i < grid.length; i++)
            for (int j = 0; j < grid[0].length; j++)
                if (grid[i][j] == '*') dfs(grid, i, j, 0);
        return best == Integer.MAX_VALUE ? -1 : best;
    }

    private void dfs(char[][] grid, int r, int c, int steps) {
        if (r < 0 || c < 0 || r >= grid.length || c >= grid[0].length) return;
        char ch = grid[r][c];
        if (ch == 'X' || ch == 'V') return;
        if (ch == '#') {
            best = Math.min(best, steps);
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

class Solution {
    public int getFood(char[][] grid) {
        int m = grid.length, n = grid[0].length;
        Deque<int[]> queue = new ArrayDeque<>();
        boolean[][] visited = new boolean[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == '*') {
                    queue.add(new int[]{i, j});
                    visited[i][j] = true;
                }
            }
        }
        int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        int steps = 0;
        while (!queue.isEmpty()) {
            int size = queue.size();
            for (int k = 0; k < size; k++) {
                int[] cur = queue.poll();
                if (grid[cur[0]][cur[1]] == '#') return steps;
                for (int[] d : dirs) {
                    int r = cur[0] + d[0], c = cur[1] + d[1];
                    if (r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != 'X') {
                        visited[r][c] = true;
                        queue.add(new int[]{r, c});
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
    public int getFood(char[][] grid) {
        int m = grid.length, n = grid[0].length;

        int start = -1;
        for (int i = 0; i < m && start < 0; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == '*') {
                    start = i * n + j;
                    break;
                }
            }
        }
        if (start < 0) return -1;

        int[] queue = new int[m * n];
        int head = 0, tail = 0;
        queue[tail++] = start;
        int[] dr = {1, -1, 0, 0};
        int[] dc = {0, 0, 1, -1};
        int steps = 0;

        while (head < tail) {
            steps++;
            int levelEnd = tail;
            while (head < levelEnd) {
                int id = queue[head++];
                int r = id / n, c = id % n;
                for (int k = 0; k < 4; k++) {
                    int nr = r + dr[k], nc = c + dc[k];
                    if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
                    char ch = grid[nr][nc];
                    if (ch == '#') return steps;
                    if (ch == 'O') {
                        grid[nr][nc] = 'X';
                        queue[tail++] = nr * n + nc;
                    }
                }
            }
        }
        return -1;
    }
}