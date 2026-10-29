/*
Brute Force

class Solution {
  List<bool> palindromePath(int n, List<List<int>> edges, String s, List<String> queries) {
    List<List<int>> g = List.generate(n, (_) => <int>[]);
    for (List<int> e in edges) {
      g[e[0]].add(e[1]);
      g[e[1]].add(e[0]);
    }
    List<int> ch = s.codeUnits.map((c) => c - 97).toList();
    List<bool> ans = [];
    for (String q in queries) {
      List<String> p = q.split(' ');
      int u = int.parse(p[1]);
      if (p[0] == 'update') {
        ch[u] = p[2].codeUnitAt(0) - 97;
        continue;
      }
      int v = int.parse(p[2]);
      List<int> par = List<int>.filled(n, -1);
      par[u] = u;
      List<int> bfs = [u];
      for (int i = 0; i < bfs.length; i++) {
        for (int y in g[bfs[i]]) {
          if (par[y] == -1) {
            par[y] = bfs[i];
            bfs.add(y);
          }
        }
      }
      int mask = 1 << ch[u];
      for (int cur = v; cur != u; cur = par[cur]) mask ^= 1 << ch[cur];
      ans.add((mask & (mask - 1)) == 0);
    }
    return ans;
  }
}
*/

/*
Better Approach

class Solution {
  List<bool> palindromePath(int n, List<List<int>> edges, String s, List<String> queries) {
    List<List<int>> g = List.generate(n, (_) => <int>[]);
    for (List<int> e in edges) {
      g[e[0]].add(e[1]);
      g[e[1]].add(e[0]);
    }
    List<int> ch = s.codeUnits.map((c) => c - 97).toList();
    List<int> par = List<int>.filled(n, -1);
    List<int> depth = List<int>.filled(n, 0);
    par[0] = 0;
    List<int> bfs = [0];
    for (int i = 0; i < bfs.length; i++) {
      int x = bfs[i];
      for (int y in g[x]) {
        if (par[y] == -1) {
          par[y] = x;
          depth[y] = depth[x] + 1;
          bfs.add(y);
        }
      }
    }
    List<bool> ans = [];
    for (String q in queries) {
      List<String> p = q.split(' ');
      int u = int.parse(p[1]);
      if (p[0] == 'update') {
        ch[u] = p[2].codeUnitAt(0) - 97;
        continue;
      }
      int v = int.parse(p[2]);
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
      ans.add((mask & (mask - 1)) == 0);
    }
    return ans;
  }
}
*/

class Solution {
  List<bool> palindromePath(int n, List<List<int>> edges, String s, List<String> queries) {
    List<List<int>> g = List.generate(n, (_) => <int>[]);
    for (List<int> e in edges) {
      g[e[0]].add(e[1]);
      g[e[1]].add(e[0]);
    }
    List<int> ch = s.codeUnits.map((c) => c - 97).toList();
    const int lg = 17;
    List<List<int>> up = List.generate(lg, (_) => List<int>.filled(n, 0));
    List<int> depth = List<int>.filled(n, 0);
    List<int> tin = List<int>.filled(n, 0);
    List<int> sz = List<int>.filled(n, 1);
    List<bool> seen = List<bool>.filled(n, false);
    List<int> order = [];
    List<int> st = [0];
    seen[0] = true;
    while (st.isNotEmpty) {
      int x = st.removeLast();
      tin[x] = order.length;
      order.add(x);
      for (int y in g[x]) {
        if (!seen[y]) {
          seen[y] = true;
          up[0][y] = x;
          depth[y] = depth[x] + 1;
          st.add(y);
        }
      }
    }
    for (int i = n - 1; i > 0; i--) sz[up[0][order[i]]] += sz[order[i]];
    for (int k = 1; k < lg; k++) {
      for (int x = 0; x < n; x++) up[k][x] = up[k - 1][up[k - 1][x]];
    }
    List<int> bit = List<int>.filled(n + 1, 0);
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
      for (int k = lg - 1; k >= 0; k--) {
        if (depth[a] - (1 << k) >= depth[b]) a = up[k][a];
      }
      if (a == b) return a;
      for (int k = lg - 1; k >= 0; k--) {
        if (up[k][a] != up[k][b]) {
          a = up[k][a];
          b = up[k][b];
        }
      }
      return up[0][a];
    }
    for (int x = 0; x < n; x++) rangeXor(x, 1 << ch[x]);
    List<bool> ans = [];
    for (String q in queries) {
      List<String> p = q.split(' ');
      int u = int.parse(p[1]);
      if (p[0] == 'update') {
        int c = p[2].codeUnitAt(0) - 97;
        rangeXor(u, (1 << ch[u]) ^ (1 << c));
        ch[u] = c;
      } else {
        int v = int.parse(p[2]);
        int mask = prefix(u) ^ prefix(v) ^ (1 << ch[lca(u, v)]);
        ans.add((mask & (mask - 1)) == 0);
      }
    }
    return ans;
  }
}