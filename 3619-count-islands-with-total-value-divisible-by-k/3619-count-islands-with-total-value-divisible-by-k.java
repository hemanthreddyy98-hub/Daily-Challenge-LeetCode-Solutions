/*
Brute Force

class Solution {
    public int countIslands(int[][] grid, int k) {
        int m = grid.length, n = grid[0].length;
        int[] dr = {1, -1, 0, 0}, dc = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) continue;
                boolean[][] seen = new boolean[m][n];
                Deque<int[]> stack = new ArrayDeque<>();
                stack.push(new int[]{i, j});
                seen[i][j] = true;
                long sum = 0;
                boolean first = true;
                while (!stack.isEmpty()) {
                    int[] cur = stack.pop();
                    int r = cur[0], c = cur[1];
                    sum += grid[r][c];
                    if (r * n + c < i * n + j) first = false;
                    for (int d = 0; d < 4; d++) {
                        int nr = r + dr[d], nc = c + dc[d];
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 && !seen[nr][nc]) {
                            seen[nr][nc] = true;
                            stack.push(new int[]{nr, nc});
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

class Solution {
    public int countIslands(int[][] grid, int k) {
        int m = grid.length, n = grid[0].length;
        boolean[][] visited = new boolean[m][n];
        int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 || visited[i][j]) continue;
                Deque<int[]> queue = new ArrayDeque<>();
                queue.add(new int[]{i, j});
                visited[i][j] = true;
                long sum = 0;
                while (!queue.isEmpty()) {
                    int[] cur = queue.poll();
                    sum += grid[cur[0]][cur[1]];
                    for (int[] d : dirs) {
                        int r = cur[0] + d[0], c = cur[1] + d[1];
                        if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r][c]) {
                            visited[r][c] = true;
                            queue.add(new int[]{r, c});
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
    public int countIslands(int[][] grid, int k) {
        int m = grid.length, n = grid[0].length;
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