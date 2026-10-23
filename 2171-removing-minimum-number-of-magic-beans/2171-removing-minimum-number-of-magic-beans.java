class Solution {
    public long minimumRemoval(int[] beans) {
        Arrays.sort(beans);
        int n = beans.length;
        long total = 0;
        for (int x : beans) total += x;
        long res = Long.MAX_VALUE;
        for (int i = 0; i < n; i++) res = Math.min(res, total - (long) beans[i] * (n - i));
        return res;
    }
}