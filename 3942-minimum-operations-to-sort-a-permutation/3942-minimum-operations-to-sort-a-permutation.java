class Solution {
    public int minOperations(int[] nums) {
        int n = nums.length, k = nums[0];
        boolean fw = true, rv = true;
        for (int i = 0; i < n; i++) {
            if (nums[i] != (k + i) % n) fw = false;
            if (nums[i] != ((k - i) % n + n) % n) rv = false;
        }
        int ans = Integer.MAX_VALUE;
        if (fw) ans = Math.min((n - k) % n, k + 2);
        if (rv) ans = Math.min(ans, Math.min(1 + (k + 1) % n, 1 + (n - k - 1) % n));
        return ans == Integer.MAX_VALUE ? -1 : ans;
    }
}