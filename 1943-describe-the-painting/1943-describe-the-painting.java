class Solution {
    public List<List<Long>> splitPainting(int[][] segments) {
        long[] d = new long[100002];
        boolean[] has = new boolean[100002];
        for (int[] s : segments) {
            d[s[0]] += s[2];
            d[s[1]] -= s[2];
            has[s[0]] = true;
            has[s[1]] = true;
        }
        List<List<Long>> res = new ArrayList<>();
        long cur = 0;
        int prev = -1;
        for (int i = 1; i <= 100001; i++) {
            if (has[i]) {
                if (prev != -1 && cur > 0) res.add(Arrays.asList((long) prev, (long) i, cur));
                cur += d[i];
                prev = i;
            }
        }
        return res;
    }
}