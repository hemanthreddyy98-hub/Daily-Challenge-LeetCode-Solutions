class Solution {
    public int minCost(int[] startPos, int[] homePos, int[] rowCosts, int[] colCosts) {
        int r = startPos[0], c = startPos[1], res = 0;
        while (r != homePos[0]) {
            r += r < homePos[0] ? 1 : -1;
            res += rowCosts[r];
        }
        while (c != homePos[1]) {
            c += c < homePos[1] ? 1 : -1;
            res += colCosts[c];
        }
        return res;
    }
}