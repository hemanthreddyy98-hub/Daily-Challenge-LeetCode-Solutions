class Solution {
    public int countHighestScoreNodes(int[] parents) {
        int n = parents.length;
        int[] l = new int[n], r = new int[n];
        Arrays.fill(l, -1);
        Arrays.fill(r, -1);
        for (int i = 1; i < n; i++) {
            int p = parents[i];
            if (l[p] == -1) l[p] = i;
            else r[p] = i;
        }
        int[] order = new int[n];
        int head = 0, tail = 0;
        order[tail++] = 0;
        while (head < tail) {
            int u = order[head++];
            if (l[u] != -1) order[tail++] = l[u];
            if (r[u] != -1) order[tail++] = r[u];
        }
        int[] size = new int[n];
        for (int i = n - 1; i >= 0; i--) {
            int u = order[i];
            size[u] = 1 + (l[u] != -1 ? size[l[u]] : 0) + (r[u] != -1 ? size[r[u]] : 0);
        }
        long best = -1;
        int cnt = 0;
        for (int u = 0; u < n; u++) {
            long s = 1;
            if (l[u] != -1) s *= size[l[u]];
            if (r[u] != -1) s *= size[r[u]];
            if (n - size[u] > 0) s *= n - size[u];
            if (s > best) {
                best = s;
                cnt = 1;
            } else if (s == best) cnt++;
        }
        return cnt;
    }
}