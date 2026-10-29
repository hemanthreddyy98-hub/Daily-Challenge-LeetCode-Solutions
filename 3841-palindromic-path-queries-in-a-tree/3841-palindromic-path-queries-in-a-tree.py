"""
Brute Force

class Solution:
    def palindromePath(self, n: int, edges: List[List[int]], s: str, queries: List[str]) -> List[bool]:
        g = [[] for _ in range(n)]
        for a, b in edges:
            g[a].append(b)
            g[b].append(a)
        ch = [ord(c) - 97 for c in s]
        ans = []
        for q in queries:
            t, a, b = q.split()
            u = int(a)
            if t == "update":
                ch[u] = ord(b) - 97
                continue
            v = int(b)
            par = [-1] * n
            par[u] = u
            bfs = deque([u])
            while bfs:
                x = bfs.popleft()
                for y in g[x]:
                    if par[y] == -1:
                        par[y] = x
                        bfs.append(y)
            mask = 1 << ch[u]
            cur = v
            while cur != u:
                mask ^= 1 << ch[cur]
                cur = par[cur]
            ans.append((mask & (mask - 1)) == 0)
        return ans
"""

"""
Better Approach

class Solution:
    def palindromePath(self, n: int, edges: List[List[int]], s: str, queries: List[str]) -> List[bool]:
        g = [[] for _ in range(n)]
        for a, b in edges:
            g[a].append(b)
            g[b].append(a)
        ch = [ord(c) - 97 for c in s]
        par = [-1] * n
        depth = [0] * n
        par[0] = 0
        bfs = deque([0])
        while bfs:
            x = bfs.popleft()
            for y in g[x]:
                if par[y] == -1:
                    par[y] = x
                    depth[y] = depth[x] + 1
                    bfs.append(y)
        ans = []
        for q in queries:
            t, a, b = q.split()
            u = int(a)
            if t == "update":
                ch[u] = ord(b) - 97
                continue
            v = int(b)
            mask = 0
            while u != v:
                if depth[u] < depth[v]:
                    u, v = v, u
                mask ^= 1 << ch[u]
                u = par[u]
            mask ^= 1 << ch[u]
            ans.append((mask & (mask - 1)) == 0)
        return ans
"""

class Solution:
    def palindromePath(self, n: int, edges: List[List[int]], s: str, queries: List[str]) -> List[bool]:
        g = [[] for _ in range(n)]
        for a, b in edges:
            g[a].append(b)
            g[b].append(a)
        ch = [ord(c) - 97 for c in s]
        log = 17
        up = [[0] * n for _ in range(log)]
        depth = [0] * n
        tin = [0] * n
        size = [1] * n
        seen = [False] * n
        order = []
        st = [0]
        seen[0] = True
        while st:
            x = st.pop()
            tin[x] = len(order)
            order.append(x)
            for y in g[x]:
                if not seen[y]:
                    seen[y] = True
                    up[0][y] = x
                    depth[y] = depth[x] + 1
                    st.append(y)
        for x in reversed(order[1:]):
            size[up[0][x]] += size[x]
        for k in range(1, log):
            prev, cur = up[k - 1], up[k]
            for x in range(n):
                cur[x] = prev[prev[x]]
        bit = [0] * (n + 1)

        def add(i, d):
            while i <= n:
                bit[i] ^= d
                i += i & -i

        def range_xor(x, d):
            add(tin[x] + 1, d)
            add(tin[x] + size[x] + 1, d)

        def prefix(x):
            i, r = tin[x] + 1, 0
            while i:
                r ^= bit[i]
                i -= i & -i
            return r

        def lca(a, b):
            if depth[a] < depth[b]:
                a, b = b, a
            for k in range(log - 1, -1, -1):
                if depth[a] - (1 << k) >= depth[b]:
                    a = up[k][a]
            if a == b:
                return a
            for k in range(log - 1, -1, -1):
                if up[k][a] != up[k][b]:
                    a, b = up[k][a], up[k][b]
            return up[0][a]

        for x in range(n):
            range_xor(x, 1 << ch[x])
        ans = []
        for q in queries:
            t, a, b = q.split()
            u = int(a)
            if t == "update":
                c = ord(b) - 97
                range_xor(u, (1 << ch[u]) ^ (1 << c))
                ch[u] = c
            else:
                v = int(b)
                mask = prefix(u) ^ prefix(v) ^ (1 << ch[lca(u, v)])
                ans.append((mask & (mask - 1)) == 0)
        return ans