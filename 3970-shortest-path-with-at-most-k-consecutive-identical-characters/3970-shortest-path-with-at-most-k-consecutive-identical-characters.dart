/*
Brute Force

class Solution {
  int shortestPath(int n, List<List<int>> edges, String labels, int k) {
    const int inf = 1 << 62;
    List<List<int>> dist = List.generate(n, (_) => List<int>.filled(k + 1, inf));
    dist[0][1] = 0;
    bool changed = true;
    while (changed) {
      changed = false;
      for (List<int> e in edges) {
        int u = e[0], v = e[1], w = e[2];
        for (int run = 1; run <= k; run++) {
          if (dist[u][run] == inf) continue;
          int next = labels[v] == labels[u] ? run + 1 : 1;
          if (next <= k && dist[u][run] + w < dist[v][next]) {
            dist[v][next] = dist[u][run] + w;
            changed = true;
          }
        }
      }
    }
    int ans = inf;
    for (int run = 1; run <= k; run++) {
      if (dist[n - 1][run] < ans) ans = dist[n - 1][run];
    }
    return ans == inf ? -1 : ans;
  }
}
*/

/*
Better Approach

class Solution {
  int shortestPath(int n, List<List<int>> edges, String labels, int k) {
    List<List<List<int>>> g = List.generate(n, (_) => <List<int>>[]);
    for (List<int> e in edges) g[e[0]].add([e[1], e[2]]);
    List<List<int>> dist = List.generate(n, (_) => List<int>.filled(k + 1, 1 << 62));
    List<List<int>> heap = [];
    void push(List<int> item) {
      heap.add(item);
      int i = heap.length - 1;
      while (i > 0) {
        int p = (i - 1) ~/ 2;
        if (heap[p][0] <= item[0]) break;
        heap[i] = heap[p];
        i = p;
      }
      heap[i] = item;
    }
    List<int> pop() {
      List<int> top = heap[0];
      List<int> last = heap.removeLast();
      if (heap.isNotEmpty) {
        int i = 0;
        while (2 * i + 1 < heap.length) {
          int c = 2 * i + 1;
          if (c + 1 < heap.length && heap[c + 1][0] < heap[c][0]) c++;
          if (heap[c][0] >= last[0]) break;
          heap[i] = heap[c];
          i = c;
        }
        heap[i] = last;
      }
      return top;
    }
    dist[0][1] = 0;
    push([0, 0, 1]);
    while (heap.isNotEmpty) {
      List<int> t = pop();
      int d = t[0], u = t[1], run = t[2];
      if (u == n - 1) return d;
      if (d > dist[u][run]) continue;
      for (List<int> e in g[u]) {
        int v = e[0], next = labels[v] == labels[u] ? run + 1 : 1;
        if (next <= k && d + e[1] < dist[v][next]) {
          dist[v][next] = d + e[1];
          push([d + e[1], v, next]);
        }
      }
    }
    return -1;
  }
}
*/

class Solution {
  int shortestPath(int n, List<List<int>> edges, String labels, int k) {
    List<List<List<int>>> g = List.generate(n, (_) => <List<int>>[]);
    for (List<int> e in edges) g[e[0]].add([e[1], e[2]]);
    List<int> best = List<int>.filled(n, k + 1);
    List<List<int>> heap = [];
    void push(List<int> item) {
      heap.add(item);
      int i = heap.length - 1;
      while (i > 0) {
        int p = (i - 1) ~/ 2;
        if (heap[p][0] <= item[0]) break;
        heap[i] = heap[p];
        i = p;
      }
      heap[i] = item;
    }
    List<int> pop() {
      List<int> top = heap[0];
      List<int> last = heap.removeLast();
      if (heap.isNotEmpty) {
        int i = 0;
        while (2 * i + 1 < heap.length) {
          int c = 2 * i + 1;
          if (c + 1 < heap.length && heap[c + 1][0] < heap[c][0]) c++;
          if (heap[c][0] >= last[0]) break;
          heap[i] = heap[c];
          i = c;
        }
        heap[i] = last;
      }
      return top;
    }
    push([0, 0, 1]);
    while (heap.isNotEmpty) {
      List<int> t = pop();
      int d = t[0], u = t[1], run = t[2];
      if (run >= best[u]) continue;
      if (u == n - 1) return d;
      best[u] = run;
      for (List<int> e in g[u]) {
        int v = e[0], next = labels[v] == labels[u] ? run + 1 : 1;
        if (next <= k && next < best[v]) push([d + e[1], v, next]);
      }
    }
    return -1;
  }
}