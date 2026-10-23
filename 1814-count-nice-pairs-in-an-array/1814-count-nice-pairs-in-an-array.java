class Solution {
    public int countNicePairs(int[] nums) {
        Map<Integer, Integer> m = new HashMap<>();
        long res = 0;
        for (int x : nums) {
            int r = 0, y = x;
            while (y > 0) {
                r = r * 10 + y % 10;
                y /= 10;
            }
            int k = x - r;
            int c = m.getOrDefault(k, 0);
            res = (res + c) % 1000000007;
            m.put(k, c + 1);
        }
        return (int) res;
    }
}