class Solution {
    public int[] getMaximumXor(int[] nums, int maximumBit) {
        int n = nums.length, x = 0;
        for (int v : nums) x ^= v;
        int mask = (1 << maximumBit) - 1;
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            ans[i] = x ^ mask;
            x ^= nums[n - 1 - i];
        }
        return ans;
    }
}