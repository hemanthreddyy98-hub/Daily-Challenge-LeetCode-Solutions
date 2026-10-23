class Solution {
    public int[] findPeakGrid(int[][] mat) {
        int m = mat.length, n = mat[0].length, lo = 0, hi = m - 1;
        while (lo <= hi) {
            int mid = (lo + hi) / 2, j = 0;
            for (int c = 1; c < n; c++) if (mat[mid][c] > mat[mid][j]) j = c;
            boolean up = mid > 0 && mat[mid - 1][j] > mat[mid][j];
            boolean down = mid < m - 1 && mat[mid + 1][j] > mat[mid][j];
            if (!up && !down) return new int[]{mid, j};
            if (up) hi = mid - 1;
            else lo = mid + 1;
        }
        return new int[]{-1, -1};
    }
}