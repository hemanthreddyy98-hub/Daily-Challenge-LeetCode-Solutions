class Solution {
    public int[] minDifference(int[] nums, int[][] queries) {
        int n = nums.length;
        int[][] pre = new int[n + 1][101];
        for (int i = 0; i < n; i++) {
            for (int v = 1; v <= 100; v++) pre[i + 1][v] = pre[i][v];
            pre[i + 1][nums[i]]++;
        }
        int[] ans = new int[queries.length];
        for (int q = 0; q < queries.length; q++) {
            int l = queries[q][0], r = queries[q][1], prev = -1, best = Integer.MAX_VALUE;
            for (int v = 1; v <= 100; v++) {
                if (pre[r + 1][v] - pre[l][v] > 0) {
                    if (prev != -1) best = Math.min(best, v - prev);
                    prev = v;
                }
            }
            ans[q] = best == Integer.MAX_VALUE ? -1 : best;
        }
        return ans;
    }
}