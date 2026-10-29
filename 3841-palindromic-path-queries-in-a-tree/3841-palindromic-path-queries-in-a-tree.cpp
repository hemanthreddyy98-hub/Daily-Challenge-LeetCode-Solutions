/*
Brute Force

class Solution {
public:
    vector<bool> palindromePath(int n, vector<vector<int>>& edges, string s, vector<string>& queries) {
        vector<vector<int>> g(n);
        for (auto& e : edges) {
            g[e[0]].push_back(e[1]);
            g[e[1]].push_back(e[0]);
        }
        vector<bool> ans;
        for (auto& q : queries) {
            stringstream ss(q);
            string type, a, b;
            ss >> type >> a >> b;
            int u = stoi(a);
            if (type == "update") {
                s[u] = b[0];
                continue;
            }
            int v = stoi(b);
            vector<int> par(n, -1);
            par[u] = u;
            queue<int> bfs;
            bfs.push(u);
            while (!bfs.empty()) {
                int x = bfs.front();
                bfs.pop();
                for (int y : g[x])
                    if (par[y] == -1) {
                        par[y] = x;
                        bfs.push(y);
                    }
            }
            int mask = 1 << (s[u] - 'a');
            for (int cur = v; cur != u; cur = par[cur]) mask ^= 1 << (s[cur] - 'a');
            ans.push_back((mask & (mask - 1)) == 0);
        }
        return ans;
    }
};
*/

/*
Better Approach

class Solution {
public:
    vector<bool> palindromePath(int n, vector<vector<int>>& edges, string s, vector<string>& queries) {
        vector<vector<int>> g(n);
        for (auto& e : edges) {
            g[e[0]].push_back(e[1]);
            g[e[1]].push_back(e[0]);
        }
        vector<int> par(n, -1), depth(n, 0);
        par[0] = 0;
        queue<int> bfs;
        bfs.push(0);
        while (!bfs.empty()) {
            int x = bfs.front();
            bfs.pop();
            for (int y : g[x])
                if (par[y] == -1) {
                    par[y] = x;
                    depth[y] = depth[x] + 1;
                    bfs.push(y);
                }
        }
        vector<bool> ans;
        for (auto& q : queries) {
            stringstream ss(q);
            string type, a, b;
            ss >> type >> a >> b;
            int u = stoi(a);
            if (type == "update") {
                s[u] = b[0];
                continue;
            }
            int v = stoi(b);
            int mask = 0;
            while (u != v) {
                if (depth[u] < depth[v]) swap(u, v);
                mask ^= 1 << (s[u] - 'a');
                u = par[u];
            }
            mask ^= 1 << (s[u] - 'a');
            ans.push_back((mask & (mask - 1)) == 0);
        }
        return ans;
    }
};
*/

class Solution {
public:
    vector<bool> palindromePath(int n, vector<vector<int>>& edges, string s, vector<string>& queries) {
        vector<vector<int>> g(n);
        for (auto& e : edges) {
            g[e[0]].push_back(e[1]);
            g[e[1]].push_back(e[0]);
        }
        const int LOG = 17;
        vector<vector<int>> up(LOG, vector<int>(n, 0));
        vector<int> depth(n, 0), tin(n, 0), sz(n, 1), order, st = {0};
        vector<bool> seen(n, false);
        seen[0] = true;
        while (!st.empty()) {
            int x = st.back();
            st.pop_back();
            tin[x] = order.size();
            order.push_back(x);
            for (int y : g[x])
                if (!seen[y]) {
                    seen[y] = true;
                    up[0][y] = x;
                    depth[y] = depth[x] + 1;
                    st.push_back(y);
                }
        }
        for (int i = n - 1; i > 0; i--) sz[up[0][order[i]]] += sz[order[i]];
        for (int k = 1; k < LOG; k++)
            for (int x = 0; x < n; x++) up[k][x] = up[k - 1][up[k - 1][x]];
        vector<int> bit(n + 1, 0);
        auto add = [&](int i, int d) {
            for (; i <= n; i += i & -i) bit[i] ^= d;
        };
        auto rangeXor = [&](int x, int d) {
            add(tin[x] + 1, d);
            add(tin[x] + sz[x] + 1, d);
        };
        auto prefix = [&](int x) {
            int r = 0;
            for (int i = tin[x] + 1; i > 0; i -= i & -i) r ^= bit[i];
            return r;
        };
        auto lca = [&](int a, int b) {
            if (depth[a] < depth[b]) swap(a, b);
            for (int k = LOG - 1; k >= 0; k--)
                if (depth[a] - (1 << k) >= depth[b]) a = up[k][a];
            if (a == b) return a;
            for (int k = LOG - 1; k >= 0; k--)
                if (up[k][a] != up[k][b]) {
                    a = up[k][a];
                    b = up[k][b];
                }
            return up[0][a];
        };
        for (int x = 0; x < n; x++) rangeXor(x, 1 << (s[x] - 'a'));
        vector<bool> ans;
        for (auto& q : queries) {
            stringstream ss(q);
            string type, a, b;
            ss >> type >> a >> b;
            int u = stoi(a);
            if (type == "update") {
                rangeXor(u, (1 << (s[u] - 'a')) ^ (1 << (b[0] - 'a')));
                s[u] = b[0];
            } else {
                int v = stoi(b);
                int mask = prefix(u) ^ prefix(v) ^ (1 << (s[lca(u, v)] - 'a'));
                ans.push_back((mask & (mask - 1)) == 0);
            }
        }
        return ans;
    }
};