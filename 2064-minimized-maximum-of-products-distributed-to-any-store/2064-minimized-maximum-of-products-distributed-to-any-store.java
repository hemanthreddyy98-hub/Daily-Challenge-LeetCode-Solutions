class Solution {
    public int minimizedMaximum(int n, int[] quantities) {
        int lo = 1, hi = 0;
        for (int q : quantities) hi = Math.max(hi, q);
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            long cnt = 0;
            for (int q : quantities) cnt += (q + mid - 1) / mid;
            if (cnt <= n) hi = mid;
            else lo = mid + 1;
        }
        return lo;
    }
}