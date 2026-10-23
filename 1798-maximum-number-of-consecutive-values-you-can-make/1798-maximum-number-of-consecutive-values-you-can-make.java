class Solution {
    public int getMaximumConsecutive(int[] coins) {
        Arrays.sort(coins);
        int r = 1;
        for (int c : coins) {
            if (c > r) break;
            r += c;
        }
        return r;
    }
}