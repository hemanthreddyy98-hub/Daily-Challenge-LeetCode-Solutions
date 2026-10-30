/*
Brute Force

class Solution {
public:
    int shortestPath(int n, vector<vector<int>>& edges, string labels, int k) {
        const long long INF = LLONG_MAX;
        vector<vector<long long>> dist(n, vector<long long>(k + 1, INF));
        dist[0][1] = 0;
        bool changed = true;
        while (changed) {
            changed = false;
            for (auto& e : edges) {
                int u = e[0], v = e[1], w = e[2];
                for (int run = 1; run <= k; run++) {
                    if (dist[u][run] == INF) continue;
                    int next = labels[v] == labels[u] ? run + 1 : 1;
                    if (next <= k && dist[u][run] + w < dist[v][next]) {
                        dist[v][next] = dist[u][run] + w;
                        changed = true;
                    }
                }
            }
        }
        long long ans = INF;
        for (int run = 1; run <= k; run++) ans = min(ans, dist[n - 1][run]);
        return ans == INF ? -1 : (int)ans;
    }
};
*/

/*
Better Approach

class Solution {
public:
    int shortestPath(int n, vector<vector<int>>& edges, string labels, int k) {
        vector<vector<pair<int, int>>> g(n);
        for (auto& e : edges) g[e[0]].push_back({e[1], e[2]});
        vector<vector<long long>> dist(n, vector<long long>(k + 1, LLONG_MAX));
        priority_queue<tuple<long long, int, int>, vector<tuple<long long, int, int>>, greater<>> pq;
        dist[0][1] = 0;
        pq.push({0, 0, 1});
        while (!pq.empty()) {
            auto [d, u, run] = pq.top();
            pq.pop();
            if (u == n - 1) return (int)d;
            if (d > dist[u][run]) continue;
            for (auto& [v, w] : g[u]) {
                int next = labels[v] == labels[u] ? run + 1 : 1;
                if (next <= k && d + w < dist[v][next]) {
                    dist[v][next] = d + w;
                    pq.push({d + w, v, next});
                }
            }
        }
        return -1;
    }
};
*/

class Solution {
public:
    int shortestPath(int n, vector<vector<int>>& edges, string labels, int k) {
        vector<vector<pair<int, int>>> g(n);
        for (auto& e : edges) g[e[0]].push_back({e[1], e[2]});
        vector<int> best(n, k + 1);
        priority_queue<tuple<long long, int, int>, vector<tuple<long long, int, int>>, greater<>> pq;
        pq.push({0, 0, 1});
        while (!pq.empty()) {
            auto [d, u, run] = pq.top();
            pq.pop();
            if (run >= best[u]) continue;
            if (u == n - 1) return (int)d;
            best[u] = run;
            for (auto& [v, w] : g[u]) {
                int next = labels[v] == labels[u] ? run + 1 : 1;
                if (next <= k && next < best[v]) pq.push({d + w, v, next});
            }
        }
        return -1;
    }
};