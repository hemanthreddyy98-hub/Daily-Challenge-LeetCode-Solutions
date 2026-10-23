class Solution {
    public int minimizeTheDifference(int[][] mat, int target) {
        boolean[] dp = new boolean[4901];
        dp[0] = true;
        for (int[] row : mat) {
            boolean[] nd = new boolean[4901];
            for (int s = 0; s <= 4900; s++) {
                if (!dp[s]) continue;
                for (int x : row) if (s + x <= 4900) nd[s + x] = true;
            }
            dp = nd;
        }
        int res = Integer.MAX_VALUE;
        for (int s = 0; s <= 4900; s++) if (dp[s]) res = Math.min(res, Math.abs(s - target));
        return res;
    }
}