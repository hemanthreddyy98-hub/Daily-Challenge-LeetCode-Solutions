class Solution {
    public int minCostSetTime(int startAt, int moveCost, int pushCost, int targetSeconds) {
        int m = targetSeconds / 60, s = targetSeconds % 60;
        return Math.min(cost(startAt, moveCost, pushCost, m, s), cost(startAt, moveCost, pushCost, m - 1, s + 60));
    }
    int cost(int startAt, int moveCost, int pushCost, int m, int s) {
        if (m < 0 || m > 99 || s < 0 || s > 99) return Integer.MAX_VALUE;
        String d = String.valueOf(m * 100 + s);
        int c = 0;
        char cur = (char) ('0' + startAt);
        for (char ch : d.toCharArray()) {
            if (ch != cur) {
                c += moveCost;
                cur = ch;
            }
            c += pushCost;
        }
        return c;
    }
}