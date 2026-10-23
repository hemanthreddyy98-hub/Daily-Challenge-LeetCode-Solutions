class Solution {
    public int minMoves(int target, int maxDoubles) {
        int res = 0;
        while (target > 1 && maxDoubles > 0) {
            if (target % 2 == 1) {
                target--;
                res++;
            } else {
                target /= 2;
                maxDoubles--;
                res++;
            }
        }
        return res + target - 1;
    }
}