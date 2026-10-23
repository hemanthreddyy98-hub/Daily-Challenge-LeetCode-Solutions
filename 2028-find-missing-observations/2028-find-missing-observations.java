class Solution {
    public int[] missingRolls(int[] rolls, int mean, int n) {
        int m = rolls.length, sum = 0;
        for (int x : rolls) sum += x;
        int total = mean * (n + m) - sum;
        if (total < n || total > 6 * n) return new int[0];
        int[] res = new int[n];
        int q = total / n, r = total % n;
        for (int i = 0; i < n; i++) res[i] = q + (i < r ? 1 : 0);
        return res;
    }
}