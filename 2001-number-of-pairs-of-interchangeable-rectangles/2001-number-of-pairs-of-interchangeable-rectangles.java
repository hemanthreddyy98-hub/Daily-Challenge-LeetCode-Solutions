class Solution {
    public long interchangeableRectangles(int[][] rectangles) {
        Map<Long, Integer> m = new HashMap<>();
        long res = 0;
        for (int[] r : rectangles) {
            int g = gcd(r[0], r[1]);
            long key = (long) (r[0] / g) * 100001 + r[1] / g;
            int c = m.getOrDefault(key, 0);
            res += c;
            m.put(key, c + 1);
        }
        return res;
    }
    int gcd(int a, int b) {
        return b == 0 ? a : gcd(b, a % b);
    }
}