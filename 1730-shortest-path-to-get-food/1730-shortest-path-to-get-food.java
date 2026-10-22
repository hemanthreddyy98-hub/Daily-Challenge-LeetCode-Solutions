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