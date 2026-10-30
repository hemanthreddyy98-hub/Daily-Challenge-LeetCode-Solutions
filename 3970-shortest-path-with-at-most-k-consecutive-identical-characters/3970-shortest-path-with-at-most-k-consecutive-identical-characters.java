/*
Brute Force

class Solution {
    public int shortestPath(int n, int[][] edges, String labels, int k) {
        final long INF = Long.MAX_VALUE;
        long[][] dist = new long[n][k + 1];
        for (long[] row : dist) Arrays.fill(row, INF);
        dist[0][1] = 0;
        boolean changed = true;
        while (changed) {
            changed = false;
            for (int[] e : edges) {
                int u = e[0], v = e[1], w = e[2];
                for (int run = 1; run <= k; run++) {
                    if (dist[u][run] == INF) continue;
                    int next = labels.charAt(v) == labels.charAt(u) ? run + 1 : 1;
                    if (next <= k && dist[u][run] + w < dist[v][next]) {
                        dist[v][next] = dist[u][run] + w;
                        changed = true;
                    }
                }
            }
        }
        long ans = INF;
        for (int run = 1; run <= k; run++) ans = Math.min(ans, dist[n - 1][run]);
        return ans == INF ? -1 : (int) ans;
    }
}
*/

/*
Better Approach

class Solution {
    public int shortestPath(int n, int[][] edges, String labels, int k) {
        List<List<int[]>> g = new ArrayList<>();
        for (int i = 0; i < n; i++) g.add(new ArrayList<>());
        for (int[] e : edges) g.get(e[0]).add(new int[] {e[1], e[2]});
        long[][] dist = new long[n][k + 1];
        for (long[] row : dist) Arrays.fill(row, Long.MAX_VALUE);
        PriorityQueue<long[]> pq = new PriorityQueue<>((a, b) -> Long.compare(a[0], b[0]));
        dist[0][1] = 0;
        pq.add(new long[] {0, 0, 1});
        while (!pq.isEmpty()) {
            long[] top = pq.poll();
            long d = top[0];
            int u = (int) top[1], run = (int) top[2];
            if (u == n - 1) return (int) d;
            if (d > dist[u][run]) continue;
            for (int[] e : g.get(u)) {
                int v = e[0], next = labels.charAt(v) == labels.charAt(u) ? run + 1 : 1;
                if (next <= k && d + e[1] < dist[v][next]) {
                    dist[v][next] = d + e[1];
                    pq.add(new long[] {d + e[1], v, next});
                }
            }
        }
        return -1;
    }
}
*/

class Solution {
    public int shortestPath(int n, int[][] edges, String labels, int k) {
        List<List<int[]>> g = new ArrayList<>();
        for (int i = 0; i < n; i++) g.add(new ArrayList<>());
        for (int[] e : edges) g.get(e[0]).add(new int[] {e[1], e[2]});
        int[] best = new int[n];
        Arrays.fill(best, k + 1);
        PriorityQueue<long[]> pq = new PriorityQueue<>((a, b) -> Long.compare(a[0], b[0]));
        pq.add(new long[] {0, 0, 1});
        while (!pq.isEmpty()) {
            long[] top = pq.poll();
            long d = top[0];
            int u = (int) top[1], run = (int) top[2];
            if (run >= best[u]) continue;
            if (u == n - 1) return (int) d;
            best[u] = run;
            for (int[] e : g.get(u)) {
                int v = e[0], next = labels.charAt(v) == labels.charAt(u) ? run + 1 : 1;
                if (next <= k && next < best[v]) pq.add(new long[] {d + e[1], v, next});
            }
        }
        return -1;
    }
}