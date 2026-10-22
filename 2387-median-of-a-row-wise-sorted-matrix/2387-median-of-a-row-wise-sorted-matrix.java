class Solution {
    public int matrixMedian(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int target = (m * n) / 2 + 1;
        int lo = 1, hi = 1_000_000;
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            int cnt = 0;
            for (int[] row : grid) cnt += upper(row, mid);
            if (cnt >= target) hi = mid;
            else lo = mid + 1;
        }
        return lo;
    }

    int upper(int[] row, int x) {
        int l = 0, r = row.length;
        while (l < r) {
            int mid = (l + r) / 2;
            if (row[mid] <= x) l = mid + 1;
            else r = mid;
        }
        return l;
    }
}