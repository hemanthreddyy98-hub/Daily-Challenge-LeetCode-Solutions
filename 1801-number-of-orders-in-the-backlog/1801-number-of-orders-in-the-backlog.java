class Solution {
    public int getNumberOfBacklogOrders(int[][] orders) {
        PriorityQueue<int[]> buy = new PriorityQueue<>((a, b) -> Integer.compare(b[0], a[0]));
        PriorityQueue<int[]> sell = new PriorityQueue<>((a, b) -> Integer.compare(a[0], b[0]));
        for (int[] o : orders) {
            int p = o[0], a = o[1];
            if (o[2] == 0) {
                while (a > 0 && !sell.isEmpty() && sell.peek()[0] <= p) {
                    int[] s = sell.peek();
                    int m = Math.min(a, s[1]);
                    a -= m;
                    s[1] -= m;
                    if (s[1] == 0) sell.poll();
                }
                if (a > 0) buy.add(new int[]{p, a});
            } else {
                while (a > 0 && !buy.isEmpty() && buy.peek()[0] >= p) {
                    int[] b = buy.peek();
                    int m = Math.min(a, b[1]);
                    a -= m;
                    b[1] -= m;
                    if (b[1] == 0) buy.poll();
                }
                if (a > 0) sell.add(new int[]{p, a});
            }
        }
        long r = 0;
        for (int[] x : buy) r += x[1];
        for (int[] x : sell) r += x[1];
        return (int) (r % 1000000007);
    }
}