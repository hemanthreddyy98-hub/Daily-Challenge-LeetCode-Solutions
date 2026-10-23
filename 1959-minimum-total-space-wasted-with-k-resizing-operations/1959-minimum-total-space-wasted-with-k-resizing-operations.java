class Solution {
    int INF = Integer.MAX_VALUE / 2;
    public int minSpaceWastedKResizing(int[] nums, int k) {
        int[][] memo = new int[nums.length][k + 1];
        for (int[] r : memo) Arrays.fill(r, -1);
        return f(nums, 0, k, memo);
    }
    int f(int[] nums, int i, int r, int[][] memo) {
        if (i == nums.length) return 0;
        if (r < 0) return INF;
        if (memo[i][r] != -1) return memo[i][r];
        int mx = 0, sum = 0, best = INF;
        for (int j = i; j < nums.length; j++) {
            mx = Math.max(mx, nums[j]);
            sum += nums[j];
            int rest = f(nums, j + 1, r - 1, memo);
            if (rest < INF) best = Math.min(best, mx * (j - i + 1) - sum + rest);
        }
        return memo[i][r] = best;
    }
}