class Solution {
    public int minElements(int[] nums, int limit, int goal) {
        long s = 0;
        for (int x : nums) s += x;
        long d = Math.abs(goal - s);
        return (int) ((d + limit - 1) / limit);
    }
}