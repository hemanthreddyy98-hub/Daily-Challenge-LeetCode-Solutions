class Solution {
    public long maxTaxiEarnings(int n, int[][] rides) {
        Arrays.sort(rides, (a, b) -> Integer.compare(a[1], b[1]));
        long[] dp = new long[n + 1];
        int k = 0;
        for (int i = 1; i <= n; i++) {
            dp[i] = dp[i - 1];
            while (k < rides.length && rides[k][1] == i) {
                dp[i] = Math.max(dp[i], dp[rides[k][0]] + rides[k][1] - rides[k][0] + rides[k][2]);
                k++;
            }
        }
        return dp[n];
    }
}