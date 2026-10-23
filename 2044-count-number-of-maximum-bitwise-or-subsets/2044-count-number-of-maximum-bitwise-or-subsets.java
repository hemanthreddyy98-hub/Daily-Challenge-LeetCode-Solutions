class Solution {
    public int countMaxOrSubsets(int[] nums) {
        int n = nums.length, mx = 0, cnt = 0;
        for (int x : nums) mx |= x;
        for (int mask = 1; mask < (1 << n); mask++) {
            int o = 0;
            for (int i = 0; i < n; i++) if ((mask >> i & 1) == 1) o |= nums[i];
            if (o == mx) cnt++;
        }
        return cnt;
    }
}