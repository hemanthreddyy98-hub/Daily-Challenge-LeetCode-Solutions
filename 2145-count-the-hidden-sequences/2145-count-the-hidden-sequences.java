class Solution {
    public int numberOfArrays(int[] differences, int lower, int upper) {
        long cur = 0, mn = 0, mx = 0;
        for (int d : differences) {
            cur += d;
            mn = Math.min(mn, cur);
            mx = Math.max(mx, cur);
        }
        long res = (long) (upper - lower) - (mx - mn) + 1;
        return (int) Math.max(0, res);
    }
}