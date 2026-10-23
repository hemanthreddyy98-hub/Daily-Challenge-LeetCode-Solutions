class Solution {
    public int largestMagicSquare(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[][] row = new int[m][n + 1];
        int[][] col = new int[m + 1][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                row[i][j + 1] = row[i][j] + grid[i][j];
                col[i + 1][j] = col[i][j] + grid[i][j];
            }
        }
        for (int k = Math.min(m, n); k > 1; k--) {
            for (int i = 0; i + k <= m; i++) {
                for (int j = 0; j + k <= n; j++) {
                    if (ok(grid, row, col, i, j, k)) return k;
                }
            }
        }
        return 1;
    }
    boolean ok(int[][] g, int[][] row, int[][] col, int i, int j, int k) {
        int t = row[i][j + k] - row[i][j];
        for (int r = i; r < i + k; r++) if (row[r][j + k] - row[r][j] != t) return false;
        for (int c = j; c < j + k; c++) if (col[i + k][c] - col[i][c] != t) return false;
        int d1 = 0, d2 = 0;
        for (int x = 0; x < k; x++) {
            d1 += g[i + x][j + x];
            d2 += g[i + x][j + k - 1 - x];
        }
        return d1 == t && d2 == t;
    }
}