class Solution {
    public long maxMatrixSum(int[][] matrix) {
        long sum = 0;
        int neg = 0, mn = Integer.MAX_VALUE;
        for (int[] r : matrix) {
            for (int x : r) {
                if (x < 0) neg++;
                int a = Math.abs(x);
                sum += a;
                mn = Math.min(mn, a);
            }
        }
        return neg % 2 == 0 ? sum : sum - 2L * mn;
    }
}