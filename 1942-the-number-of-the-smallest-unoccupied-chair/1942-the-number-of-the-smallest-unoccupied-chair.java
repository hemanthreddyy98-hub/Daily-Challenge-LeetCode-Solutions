class Solution {
    public int smallestChair(int[][] times, int targetFriend) {
        int n = times.length;
        Integer[] idx = new Integer[n];
        for (int i = 0; i < n; i++) idx[i] = i;
        Arrays.sort(idx, (a, b) -> Integer.compare(times[a][0], times[b][0]));
        PriorityQueue<Integer> free = new PriorityQueue<>();
        PriorityQueue<int[]> used = new PriorityQueue<>((a, b) -> Integer.compare(a[0], b[0]));
        int next = 0;
        for (int i : idx) {
            int a = times[i][0];
            while (!used.isEmpty() && used.peek()[0] <= a) free.add(used.poll()[1]);
            int c = free.isEmpty() ? next++ : free.poll();
            if (i == targetFriend) return c;
            used.add(new int[]{times[i][1], c});
        }
        return -1;
    }
}