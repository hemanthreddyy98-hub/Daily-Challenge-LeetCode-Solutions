/*
Brute Force

class Solution {
    public List<Boolean> palindromePath(int n, int[][] edges, String s, String[] queries) {
        List<List<Integer>> g = new ArrayList<>();
        for (int i = 0; i < n; i++) g.add(new ArrayList<>());
        for (int[] e : edges) {
            g.get(e[0]).add(e[1]);
            g.get(e[1]).add(e[0]);
        }
        char[] ch = s.toCharArray();
        List<Boolean> ans = new ArrayList<>();
        for (String q : queries) {
            String[] p = q.split(" ");
            int u = Integer.parseInt(p[1]);
            if (p[0].equals("update")) {
                ch[u] = p[2].charAt(0);
                continue;
            }
            int v = Integer.parseInt(p[2]);
            int[] par = new int[n];
            Arrays.fill(par, -1);
            par[u] = u;
            ArrayDeque<Integer> bfs = new ArrayDeque<>();
            bfs.add(u);
            while (!bfs.isEmpty()) {
                int x = bfs.poll();
                for (int y : g.get(x))
                    if (par[y] == -1) {
                        par[y] = x;
                        bfs.add(y);
                    }
            }
            int mask = 1 << (ch[u] - 'a');
            for (int cur = v; cur != u; cur = par[cur]) mask ^= 1 << (ch[cur] - 'a');
            ans.add((mask & (mask - 1)) == 0);
        }
        return ans;
    }
}
*/

/*
Better Approach

class Solution {
    public List<Boolean> palindromePath(int n, int[][] edges, String s, String[] queries) {
        List<List<Integer>> g = new ArrayList<>();
        for (int i = 0; i < n; i++) g.add(new ArrayList<>());
        for (int[] e : edges) {
            g.get(e[0]).add(e[1]);
            g.get(e[1]).add(e[0]);
        }
        int[] par = new int[n], depth = new int[n];
        Arrays.fill(par, -1);
        par[0] = 0;
        ArrayDeque<Integer> bfs = new ArrayDeque<>();
        bfs.add(0);
        while (!bfs.isEmpty()) {
            int x = bfs.poll();
            for (int y : g.get(x))
                if (par[y] == -1) {
                    par[y] = x;
                    depth[y] = depth[x] + 1;
                    bfs.add(y);
                }
        }
        char[] ch = s.toCharArray();
        List<Boolean> ans = new ArrayList<>();
        for (String q : queries) {
            String[] p = q.split(" ");
            int u = Integer.parseInt(p[1]);
            if (p[0].equals("update")) {
                ch[u] = p[2].charAt(0);
                continue;
            }
            int v = Integer.parseInt(p[2]);
            int mask = 0;
            while (u != v) {
                if (depth[u] < depth[v]) {
                    int t = u;
                    u = v;
                    v = t;
                }
                mask ^= 1 << (ch[u] - 'a');
                u = par[u];
            }
            mask ^= 1 << (ch[u] - 'a');
            ans.add((mask & (mask - 1)) == 0);
        }
        return ans;
    }
}
*/

class Solution {
    int n;
    int[] bit, tin, sz, depth;
    int[][] up;

    public List<Boolean> palindromePath(int n, int[][] edges, String s, String[] queries) {
        this.n = n;
        List<List<Integer>> g = new ArrayList<>();
        for (int i = 0; i < n; i++) g.add(new ArrayList<>());
        for (int[] e : edges) {
            g.get(e[0]).add(e[1]);
            g.get(e[1]).add(e[0]);
        }
        up = new int[17][n];
        depth = new int[n];
        tin = new int[n];
        sz = new int[n];
        bit = new int[n + 1];
        int[] order = new int[n], st = new int[n];
        boolean[] seen = new boolean[n];
        int top = 0, timer = 0;
        st[top++] = 0;
        seen[0] = true;
        while (top > 0) {
            int x = st[--top];
            tin[x] = timer;
            order[timer++] = x;
            for (int y : g.get(x))
                if (!seen[y]) {
                    seen[y] = true;
                    up[0][y] = x;
                    depth[y] = depth[x] + 1;
                    st[top++] = y;
                }
        }
        Arrays.fill(sz, 1);
        for (int i = n - 1; i > 0; i--) sz[up[0][order[i]]] += sz[order[i]];
        for (int k = 1; k < 17; k++)
            for (int x = 0; x < n; x++) up[k][x] = up[k - 1][up[k - 1][x]];
        char[] ch = s.toCharArray();
        for (int x = 0; x < n; x++) rangeXor(x, 1 << (ch[x] - 'a'));
        List<Boolean> ans = new ArrayList<>();
        for (String q : queries) {
            String[] p = q.split(" ");
            int u = Integer.parseInt(p[1]);
            if (p[0].equals("update")) {
                char c = p[2].charAt(0);
                rangeXor(u, (1 << (ch[u] - 'a')) ^ (1 << (c - 'a')));
                ch[u] = c;
            } else {
                int v = Integer.parseInt(p[2]);
                int mask = prefix(u) ^ prefix(v) ^ (1 << (ch[lca(u, v)] - 'a'));
                ans.add((mask & (mask - 1)) == 0);
            }
        }
        return ans;
    }

    void add(int i, int d) {
        for (; i <= n; i += i & -i) bit[i] ^= d;
    }

    void rangeXor(int x, int d) {
        add(tin[x] + 1, d);
        add(tin[x] + sz[x] + 1, d);
    }

    int prefix(int x) {
        int r = 0;
        for (int i = tin[x] + 1; i > 0; i -= i & -i) r ^= bit[i];
        return r;
    }

    int lca(int a, int b) {
        if (depth[a] < depth[b]) {
            int t = a;
            a = b;
            b = t;
        }
        for (int k = 16; k >= 0; k--)
            if (depth[a] - (1 << k) >= depth[b]) a = up[k][a];
        if (a == b) return a;
        for (int k = 16; k >= 0; k--)
            if (up[k][a] != up[k][b]) {
                a = up[k][a];
                b = up[k][b];
            }
        return up[0][a];
    }
}