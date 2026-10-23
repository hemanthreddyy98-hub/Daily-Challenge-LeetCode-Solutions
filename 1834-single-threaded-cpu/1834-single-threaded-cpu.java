class Solution {
    public int[] getOrder(int[][] tasks) {
        int n = tasks.length;
        Integer[] idx = new Integer[n];
        for (int i = 0; i < n; i++) idx[i] = i;
        Arrays.sort(idx, (a, b) -> Integer.compare(tasks[a][0], tasks[b][0]));
        PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] != b[0] ? Integer.compare(a[0], b[0]) : Integer.compare(a[1], b[1]));
        int[] ans = new int[n];
        long t = 0;
        int i = 0, k = 0;
        while (k < n) {
            if (pq.isEmpty() && t < tasks[idx[i]][0]) t = tasks[idx[i]][0];
            while (i < n && tasks[idx[i]][0] <= t) {
                pq.add(new int[]{tasks[idx[i]][1], idx[i]});
                i++;
            }
            int[] c = pq.poll();
            t += c[0];
            ans[k++] = c[1];
        }
        return ans;
    }
}