/*
Brute Force

public class Solution {
    public int ShortestPath(int n, int[][] edges, string labels, int k) {
        const long INF = long.MaxValue;
        long[,] dist = new long[n, k + 1];
        for (int i = 0; i < n; i++)
            for (int run = 0; run <= k; run++) dist[i, run] = INF;
        dist[0, 1] = 0;
        bool changed = true;
        while (changed) {
            changed = false;
            foreach (int[] e in edges) {
                int u = e[0], v = e[1], w = e[2];
                for (int run = 1; run <= k; run++) {
                    if (dist[u, run] == INF) continue;
                    int next = labels[v] == labels[u] ? run + 1 : 1;
                    if (next <= k && dist[u, run] + w < dist[v, next]) {
                        dist[v, next] = dist[u, run] + w;
                        changed = true;
                    }
                }
            }
        }
        long ans = INF;
        for (int run = 1; run <= k; run++) ans = Math.Min(ans, dist[n - 1, run]);
        return ans == INF ? -1 : (int)ans;
    }
}
*/

/*
Better Approach

public class Solution {
    List<long[]> heap;

    public int ShortestPath(int n, int[][] edges, string labels, int k) {
        List<int[]>[] g = new List<int[]>[n];
        for (int i = 0; i < n; i++) g[i] = new List<int[]>();
        foreach (int[] e in edges) g[e[0]].Add(new int[] {e[1], e[2]});
        heap = new List<long[]>();
        long[,] dist = new long[n, k + 1];
        for (int i = 0; i < n; i++)
            for (int run = 0; run <= k; run++) dist[i, run] = long.MaxValue;
        dist[0, 1] = 0;
        Push(new long[] {0, 0, 1});
        while (heap.Count > 0) {
            long[] top = Pop();
            long d = top[0];
            int u = (int)top[1], run = (int)top[2];
            if (u == n - 1) return (int)d;
            if (d > dist[u, run]) continue;
            foreach (int[] e in g[u]) {
                int v = e[0], next = labels[v] == labels[u] ? run + 1 : 1;
                if (next <= k && d + e[1] < dist[v, next]) {
                    dist[v, next] = d + e[1];
                    Push(new long[] {d + e[1], v, next});
                }
            }
        }
        return -1;
    }

    void Push(long[] item) {
        heap.Add(item);
        int i = heap.Count - 1;
        while (i > 0) {
            int p = (i - 1) / 2;
            if (heap[p][0] <= item[0]) break;
            heap[i] = heap[p];
            i = p;
        }
        heap[i] = item;
    }

    long[] Pop() {
        long[] top = heap[0];
        long[] last = heap[heap.Count - 1];
        heap.RemoveAt(heap.Count - 1);
        if (heap.Count > 0) {
            int i = 0;
            while (2 * i + 1 < heap.Count) {
                int c = 2 * i + 1;
                if (c + 1 < heap.Count && heap[c + 1][0] < heap[c][0]) c++;
                if (heap[c][0] >= last[0]) break;
                heap[i] = heap[c];
                i = c;
            }
            heap[i] = last;
        }
        return top;
    }
}
*/

public class Solution {
    List<long[]> heap;

    public int ShortestPath(int n, int[][] edges, string labels, int k) {
        List<int[]>[] g = new List<int[]>[n];
        for (int i = 0; i < n; i++) g[i] = new List<int[]>();
        foreach (int[] e in edges) g[e[0]].Add(new int[] {e[1], e[2]});
        heap = new List<long[]>();
        int[] best = new int[n];
        Array.Fill(best, k + 1);
        Push(new long[] {0, 0, 1});
        while (heap.Count > 0) {
            long[] top = Pop();
            long d = top[0];
            int u = (int)top[1], run = (int)top[2];
            if (run >= best[u]) continue;
            if (u == n - 1) return (int)d;
            best[u] = run;
            foreach (int[] e in g[u]) {
                int v = e[0], next = labels[v] == labels[u] ? run + 1 : 1;
                if (next <= k && next < best[v]) Push(new long[] {d + e[1], v, next});
            }
        }
        return -1;
    }

    void Push(long[] item) {
        heap.Add(item);
        int i = heap.Count - 1;
        while (i > 0) {
            int p = (i - 1) / 2;
            if (heap[p][0] <= item[0]) break;
            heap[i] = heap[p];
            i = p;
        }
        heap[i] = item;
    }

    long[] Pop() {
        long[] top = heap[0];
        long[] last = heap[heap.Count - 1];
        heap.RemoveAt(heap.Count - 1);
        if (heap.Count > 0) {
            int i = 0;
            while (2 * i + 1 < heap.Count) {
                int c = 2 * i + 1;
                if (c + 1 < heap.Count && heap[c + 1][0] < heap[c][0]) c++;
                if (heap[c][0] >= last[0]) break;
                heap[i] = heap[c];
                i = c;
            }
            heap[i] = last;
        }
        return top;
    }
}