class Solution {
    public long numberOfWeeks(int[] milestones) {
        long sum = 0, mx = 0;
        for (int x : milestones) {
            sum += x;
            mx = Math.max(mx, x);
        }
        long rest = sum - mx;
        return mx > rest ? 2 * rest + 1 : sum;
    }
}