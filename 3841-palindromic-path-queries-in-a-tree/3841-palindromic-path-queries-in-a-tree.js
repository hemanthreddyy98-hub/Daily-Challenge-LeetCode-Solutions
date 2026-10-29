/*
Brute Force

var palindromePath = function(n, edges, s, queries) {
    const g = Array.from({ length: n }, () => []);
    for (const [a, b] of edges) {
        g[a].push(b);
        g[b].push(a);
    }
    const ch = Array.from(s, (c) => c.charCodeAt(0) - 97);
    const ans = [];
    for (const q of queries) {
        const [type, a, b] = q.split(" ");
        const u = Number(a);
        if (type === "update") {
            ch[u] = b.charCodeAt(0) - 97;
            continue;
        }
        const v = Number(b);
        const par = new Int32Array(n).fill(-1);
        par[u] = u;
        const bfs = [u];
        for (let i = 0; i < bfs.length; i++)
            for (const y of g[bfs[i]])
                if (par[y] === -1) {
                    par[y] = bfs[i];
                    bfs.push(y);
                }
        let mask = 1 << ch[u];
        for (let cur = v; cur !== u; cur = par[cur]) mask ^= 1 << ch[cur];
        ans.push((mask & (mask - 1)) === 0);
    }
    return ans;
};
*/

/*
Better Approach

var palindromePath = function(n, edges, s, queries) {
    const g = Array.from({ length: n }, () => []);
    for (const [a, b] of edges) {
        g[a].push(b);
        g[b].push(a);
    }
    const ch = Array.from(s, (c) => c.charCodeAt(0) - 97);
    const par = new Int32Array(n).fill(-1), depth = new Int32Array(n);
    par[0] = 0;
    const bfs = [0];
    for (let i = 0; i < bfs.length; i++)
        for (const y of g[bfs[i]])
            if (par[y] === -1) {
                par[y] = bfs[i];
                depth[y] = depth[bfs[i]] + 1;
                bfs.push(y);
            }
    const ans = [];
    for (const q of queries) {
        const [type, a, b] = q.split(" ");
        let u = Number(a);
        if (type === "update") {
            ch[u] = b.charCodeAt(0) - 97;
            continue;
        }
        let v = Number(b), mask = 0;
        while (u !== v) {
            if (depth[u] < depth[v]) [u, v] = [v, u];
            mask ^= 1 << ch[u];
            u = par[u];
        }
        mask ^= 1 << ch[u];
        ans.push((mask & (mask - 1)) === 0);
    }
    return ans;
};
*/

var palindromePath = function(n, edges, s, queries) {
    const g = Array.from({ length: n }, () => []);
    for (const [a, b] of edges) {
        g[a].push(b);
        g[b].push(a);
    }
    const ch = Array.from(s, (c) => c.charCodeAt(0) - 97);
    const LOG = 17;
    const up = Array.from({ length: LOG }, () => new Int32Array(n));
    const depth = new Int32Array(n), tin = new Int32Array(n), sz = new Int32Array(n).fill(1);
    const seen = new Uint8Array(n), order = [], st = [0];
    seen[0] = 1;
    while (st.length) {
        const x = st.pop();
        tin[x] = order.length;
        order.push(x);
        for (const y of g[x])
            if (!seen[y]) {
                seen[y] = 1;
                up[0][y] = x;
                depth[y] = depth[x] + 1;
                st.push(y);
            }
    }
    for (let i = n - 1; i > 0; i--) sz[up[0][order[i]]] += sz[order[i]];
    for (let k = 1; k < LOG; k++)
        for (let x = 0; x < n; x++) up[k][x] = up[k - 1][up[k - 1][x]];
    const bit = new Int32Array(n + 1);
    const add = (i, d) => {
        for (; i <= n; i += i & -i) bit[i] ^= d;
    };
    const rangeXor = (x, d) => {
        add(tin[x] + 1, d);
        add(tin[x] + sz[x] + 1, d);
    };
    const prefix = (x) => {
        let r = 0;
        for (let i = tin[x] + 1; i > 0; i -= i & -i) r ^= bit[i];
        return r;
    };
    const lca = (a, b) => {
        if (depth[a] < depth[b]) [a, b] = [b, a];
        for (let k = LOG - 1; k >= 0; k--)
            if (depth[a] - (1 << k) >= depth[b]) a = up[k][a];
        if (a === b) return a;
        for (let k = LOG - 1; k >= 0; k--)
            if (up[k][a] !== up[k][b]) {
                a = up[k][a];
                b = up[k][b];
            }
        return up[0][a];
    };
    for (let x = 0; x < n; x++) rangeXor(x, 1 << ch[x]);
    const ans = [];
    for (const q of queries) {
        const [type, a, b] = q.split(" ");
        const u = Number(a);
        if (type === "update") {
            const c = b.charCodeAt(0) - 97;
            rangeXor(u, (1 << ch[u]) ^ (1 << c));
            ch[u] = c;
        } else {
            const v = Number(b);
            const mask = prefix(u) ^ prefix(v) ^ (1 << ch[lca(u, v)]);
            ans.push((mask & (mask - 1)) === 0);
        }
    }
    return ans;
};