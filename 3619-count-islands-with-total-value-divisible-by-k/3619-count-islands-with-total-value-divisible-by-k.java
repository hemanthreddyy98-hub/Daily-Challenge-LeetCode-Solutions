class Solution {
    public int countIslands(int[][] grid, int k) {
        int m = grid.length, n = grid[0].length, ans = 0;
        boolean[][] seen = new boolean[m][n];
        int[] dx = {1, -1, 0, 0}, dy = {0, 0, 1, -1};
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 || seen[i][j]) continue;
                long sum = 0;
                Deque<int[]> dq = new ArrayDeque<>();
                dq.add(new int[]{i, j});
                seen[i][j] = true;
                while (!dq.isEmpty()) {
                    int[] c = dq.poll();
                    sum += grid[c[0]][c[1]];
                    for (int d = 0; d < 4; d++) {
                        int x = c[0] + dx[d], y = c[1] + dy[d];
                        if (x >= 0 && y >= 0 && x < m && y < n && grid[x][y] > 0 && !seen[x][y]) {
                            seen[x][y] = true;
                            dq.add(new int[]{x, y});
                        }
                    }
                }
                if (sum % k == 0) ans++;
            }
        }
        return ans;
    }
}