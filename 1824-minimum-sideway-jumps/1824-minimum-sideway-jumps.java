class Solution {
    public int minSideJumps(int[] obstacles) {
        int INF = 1000000;
        int[] dp = {1, 0, 1};
        for (int i = 1; i < obstacles.length; i++) {
            int o = obstacles[i];
            if (o > 0) dp[o - 1] = INF;
            int mn = Math.min(dp[0], Math.min(dp[1], dp[2]));
            for (int j = 0; j < 3; j++) {
                if (o != j + 1) dp[j] = Math.min(dp[j], mn + 1);
            }
        }
        return Math.min(dp[0], Math.min(dp[1], dp[2]));
    }
}