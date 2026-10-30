"""
Brute Force

class Solution(object):
    def shortestPath(self, n, edges, labels, k):
        INF = float('inf')
        dist = [[INF] * (k + 1) for _ in range(n)]
        dist[0][1] = 0
        changed = True
        while changed:
            changed = False
            for u, v, w in edges:
                for run in range(1, k + 1):
                    if dist[u][run] == INF:
                        continue
                    nxt = run + 1 if labels[v] == labels[u] else 1
                    if nxt <= k and dist[u][run] + w < dist[v][nxt]:
                        dist[v][nxt] = dist[u][run] + w
                        changed = True
        ans = min(dist[n - 1][1:])
        return -1 if ans == INF else ans
"""

"""
Better Approach

class Solution(object):
    def shortestPath(self, n, edges, labels, k):
        g = [[] for _ in range(n)]
        for u, v, w in edges:
            g[u].append((v, w))
        INF = float('inf')
        dist = [[INF] * (k + 1) for _ in range(n)]
        dist[0][1] = 0
        pq = [(0, 0, 1)]
        while pq:
            d, u, run = heappop(pq)
            if u == n - 1:
                return d
            if d > dist[u][run]:
                continue
            for v, w in g[u]:
                nxt = run + 1 if labels[v] == labels[u] else 1
                if nxt <= k and d + w < dist[v][nxt]:
                    dist[v][nxt] = d + w
                    heappush(pq, (d + w, v, nxt))
        return -1
"""

class Solution(object):
    def shortestPath(self, n, edges, labels, k):
        g = [[] for _ in range(n)]
        for u, v, w in edges:
            g[u].append((v, w))
        best = [k + 1] * n
        pq = [(0, 0, 1)]
        while pq:
            d, u, run = heappop(pq)
            if run >= best[u]:
                continue
            if u == n - 1:
                return d
            best[u] = run
            for v, w in g[u]:
                nxt = run + 1 if labels[v] == labels[u] else 1
                if nxt <= k and nxt < best[v]:
                    heappush(pq, (d + w, v, nxt))
        return -1