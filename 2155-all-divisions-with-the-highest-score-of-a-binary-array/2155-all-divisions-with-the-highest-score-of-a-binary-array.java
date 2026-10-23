class Solution {
    public List<Integer> maxScoreIndices(int[] nums) {
        int ones = 0;
        for (int x : nums) ones += x;
        int zeros = 0, best = ones;
        List<Integer> res = new ArrayList<>();
        res.add(0);
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] == 0) zeros++;
            else ones--;
            int s = zeros + ones;
            if (s > best) {
                best = s;
                res.clear();
                res.add(i + 1);
            } else if (s == best) res.add(i + 1);
        }
        return res;
    }
}