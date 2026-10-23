class Solution {
    public int minStoneSum(int[] piles, int k) {
        PriorityQueue<Integer> pq = new PriorityQueue<>(Collections.reverseOrder());
        int sum = 0;
        for (int x : piles) {
            pq.add(x);
            sum += x;
        }
        while (k-- > 0) {
            int x = pq.poll();
            int rem = x / 2;
            sum -= rem;
            pq.add(x - rem);
        }
        return sum;
    }
}