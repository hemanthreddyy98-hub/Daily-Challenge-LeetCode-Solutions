class Solution {
    public int minSwaps(int[] nums) {
        int n = nums.length, ones = 0;
        for (int x : nums) ones += x;
        int cur = 0;
        for (int i = 0; i < ones; i++) if (nums[i] == 0) cur++;
        int res = cur;
        for (int i = ones; i < n + ones; i++) {
            if (nums[i % n] == 0) cur++;
            if (nums[(i - ones) % n] == 0) cur--;
            res = Math.min(res, cur);
        }
        return res;
    }
}