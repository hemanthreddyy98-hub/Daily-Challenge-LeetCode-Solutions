class Solution {
    public int addRungs(int[] rungs, int dist) {
        int prev = 0, res = 0;
        for (int r : rungs) {
            res += (r - prev - 1) / dist;
            prev = r;
        }
        return res;
    }
}