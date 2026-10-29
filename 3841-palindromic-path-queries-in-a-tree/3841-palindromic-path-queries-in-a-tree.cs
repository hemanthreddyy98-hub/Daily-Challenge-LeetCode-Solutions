/*
Brute Force

public class Solution {
    public IList<bool> PalindromePath(int n, int[][] edges, string s, string[] queries) {
        List<int>[] g = new List<int>[n];
        for (int i = 0; i < n; i++) g[i] = new List<int>();
        foreach (int[] e in edges) {
            g[e[0]].Add(e[1]);
            g[e[1]].Add(e[0]);
        }
        int[] ch = new int[n];
        for (int i = 0; i < n; i++) ch[i] = s[i] - 'a';
        List<bool> ans = new List<bool>();
        foreach (string q in queries) {
            string[] p = q.Split(' ');
            int u = int.Parse(p[1]);
            if (p[0] == "update") {
                ch[u] = p[2][0] - 'a';
                continue;
            }
            int v = int.Parse(p[2]);
            int[] par = new int[n];
            Array.Fill(par, -1);
            par[u] = u;
            Queue<int> bfs = new Queue<int>();
            bfs.Enqueue(u);
            while (bfs.Count > 0) {
                int x = bfs.Dequeue();
                foreach (int y in g[x])
                    if (par[y] == -1) {
                        par[y] = x;
                        bfs.Enqueue(y);
                    }
            }
            int mask = 1 << ch[u];
            for (int cur = v; cur != u; cur = par[cur]) mask ^= 1 << ch[cur];
            ans.Add((mask & (mask - 1)) == 0);
        }
        return ans;
    }
}
*/

/*
Better Approach

public class Solution {
    public IList<bool> PalindromePath(int n, int[][] edges, string s, string[] queries) {
        List<int>[] g = new List<int>[n];
        for (int i = 0; i < n; i++) g[i] = new List<int>();
        foreach (int[] e in edges) {
            g[e[0]].Add(e[1]);
            g[e[1]].Add(e[0]);
        }
        int[] ch = new int[n];
        for (int i = 0; i < n; i++) ch[i] = s[i] - 'a';
        int[] par = new int[n], depth = new int[n];
        Array.Fill(par, -1);
        par[0] = 0;
        Queue<int> bfs = new Queue<int>();
        bfs.Enqueue(0);
        while (bfs.Count > 0) {
            int x = bfs.Dequeue();
            foreach (int y in g[x])
                if (par[y] == -1) {
                    par[y] = x;
                    depth[y] = depth[x] + 1;
                    bfs.Enqueue(y);
                }
        }
        List<bool> ans = new List<bool>();
        foreach (string q in queries) {
            string[] p = q.Split(' ');
            int u = int.Parse(p[1]);
            if (p[0] == "update") {
                ch[u] = p[2][0] - 'a';
                continue;
            }
            int v = int.Parse(p[2]);
            int mask = 0;
            while (u != v) {
                if (depth[u] < depth[v]) {
                    int t = u;
                    u = v;
                    v = t;
                }
                mask ^= 1 << ch[u];
                u = par[u];
            }
            mask ^= 1 << ch[u];
            ans.Add((mask & (mask - 1)) == 0);
        }
        return ans;
    }
}
*/

public class Solution {
    int n;
    int[] bit, tin, sz, depth;
    int[][] up;

    public IList<bool> PalindromePath(int n, int[][] edges, string s, string[] queries) {
        this.n = n;
        List<int>[] g = new List<int>[n];
        for (int i = 0; i < n; i++) g[i] = new List<int>();
        foreach (int[] e in edges) {
            g[e[0]].Add(e[1]);
            g[e[1]].Add(e[0]);
        }
        int[] ch = new int[n];
        for (int i = 0; i < n; i++) ch[i] = s[i] - 'a';
        up = new int[17][];
        for (int k = 0; k < 17; k++) up[k] = new int[n];
        depth = new int[n];
        tin = new int[n];
        sz = new int[n];
        bit = new int[n + 1];
        int[] order = new int[n], st = new int[n];
        bool[] seen = new bool[n];
        int top = 0, timer = 0;
        st[top++] = 0;
        seen[0] = true;
        while (top > 0) {
            int x = st[--top];
            tin[x] = timer;
            order[timer++] = x;
            foreach (int y in g[x])
                if (!seen[y]) {
                    seen[y] = true;
                    up[0][y] = x;
                    depth[y] = depth[x] + 1;
                    st[top++] = y;
                }
        }
        Array.Fill(sz, 1);
        for (int i = n - 1; i > 0; i--) sz[up[0][order[i]]] += sz[order[i]];
        for (int k = 1; k < 17; k++)
            for (int x = 0; x < n; x++) up[k][x] = up[k - 1][up[k - 1][x]];
        for (int x = 0; x < n; x++) RangeXor(x, 1 << ch[x]);
        List<bool> ans = new List<bool>();
        foreach (string q in queries) {
            string[] p = q.Split(' ');
            int u = int.Parse(p[1]);
            if (p[0] == "update") {
                int c = p[2][0] - 'a';
                RangeXor(u, (1 << ch[u]) ^ (1 << c));
                ch[u] = c;
            } else {
                int v = int.Parse(p[2]);
                int mask = Prefix(u) ^ Prefix(v) ^ (1 << ch[Lca(u, v)]);
                ans.Add((mask & (mask - 1)) == 0);
            }
        }
        return ans;
    }

    void Add(int i, int d) {
        for (; i <= n; i += i & -i) bit[i] ^= d;
    }

    void RangeXor(int x, int d) {
        Add(tin[x] + 1, d);
        Add(tin[x] + sz[x] + 1, d);
    }

    int Prefix(int x) {
        int r = 0;
        for (int i = tin[x] + 1; i > 0; i -= i & -i) r ^= bit[i];
        return r;
    }

    int Lca(int a, int b) {
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