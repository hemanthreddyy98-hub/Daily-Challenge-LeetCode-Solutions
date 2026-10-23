class Solution {
    public long maxAlternatingSum(int[] nums) {
        long even = 0, odd = 0;
        for (int x : nums) {
            long ne = Math.max(even, odd + x);
            long no = Math.max(odd, even - x);
            even = ne;
            odd = no;
        }
        return even;
    }
}