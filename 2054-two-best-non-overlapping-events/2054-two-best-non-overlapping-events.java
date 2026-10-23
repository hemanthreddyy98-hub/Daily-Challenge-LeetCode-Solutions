class Solution {
    public int maxTwoEvents(int[][] events) {
        int n = events.length;
        Arrays.sort(events, (a, b) -> Integer.compare(a[0], b[0]));
        int[] suf = new int[n + 1];
        for (int i = n - 1; i >= 0; i--) suf[i] = Math.max(suf[i + 1], events[i][2]);
        int res = 0;
        for (int[] e : events) {
            int lo = 0, hi = n;
            while (lo < hi) {
                int mid = (lo + hi) / 2;
                if (events[mid][0] > e[1]) hi = mid;
                else lo = mid + 1;
            }
            res = Math.max(res, e[2] + suf[lo]);
        }
        return res;
    }
}