/*
Brute Force

int shortestPath(int n, int** edges, int edgesSize, int* edgesColSize, char* labels, int k) {
    const long long INF = LLONG_MAX;
    long long* dist = (long long*)malloc(sizeof(long long) * n * (k + 1));
    for (int i = 0; i < n * (k + 1); i++) dist[i] = INF;
    dist[1] = 0;
    bool changed = true;
    while (changed) {
        changed = false;
        for (int i = 0; i < edgesSize; i++) {
            int u = edges[i][0], v = edges[i][1], w = edges[i][2];
            for (int run = 1; run <= k; run++) {
                long long d = dist[u * (k + 1) + run];
                if (d == INF) continue;
                int next = labels[v] == labels[u] ? run + 1 : 1;
                if (next <= k && d + w < dist[v * (k + 1) + next]) {
                    dist[v * (k + 1) + next] = d + w;
                    changed = true;
                }
            }
        }
    }
    long long ans = INF;
    for (int run = 1; run <= k; run++)
        if (dist[(n - 1) * (k + 1) + run] < ans) ans = dist[(n - 1) * (k + 1) + run];
    free(dist);
    return ans == INF ? -1 : (int)ans;
}
*/

/*
Better Approach

typedef struct {
    long long d;
    int u, run;
} Item;

void push(Item** h, int* size, int* cap, Item x) {
    if (*size == *cap) {
        *cap *= 2;
        *h = (Item*)realloc(*h, sizeof(Item) * *cap);
    }
    int i = (*size)++;
    while (i > 0 && (*h)[(i - 1) / 2].d > x.d) {
        (*h)[i] = (*h)[(i - 1) / 2];
        i = (i - 1) / 2;
    }
    (*h)[i] = x;
}

Item pop(Item* h, int* size) {
    Item top = h[0], last = h[--(*size)];
    int i = 0;
    while (2 * i + 1 < *size) {
        int c = 2 * i + 1;
        if (c + 1 < *size && h[c + 1].d < h[c].d) c++;
        if (h[c].d >= last.d) break;
        h[i] = h[c];
        i = c;
    }
    h[i] = last;
    return top;
}

int shortestPath(int n, int** edges, int edgesSize, int* edgesColSize, char* labels, int k) {
    int* head = (int*)malloc(sizeof(int) * n);
    int* nxt = (int*)malloc(sizeof(int) * (edgesSize + 1));
    for (int i = 0; i < n; i++) head[i] = -1;
    for (int i = 0; i < edgesSize; i++) {
        nxt[i] = head[edges[i][0]];
        head[edges[i][0]] = i;
    }
    int size = 0, cap = 16;
    Item* h = (Item*)malloc(sizeof(Item) * cap);
    long long* dist = (long long*)malloc(sizeof(long long) * n * (k + 1));
    for (int i = 0; i < n * (k + 1); i++) dist[i] = LLONG_MAX;
    dist[1] = 0;
    push(&h, &size, &cap, (Item){0, 0, 1});
    long long ans = -1;
    while (size > 0) {
        Item t = pop(h, &size);
        if (t.u == n - 1) {
            ans = t.d;
            break;
        }
        if (t.d > dist[t.u * (k + 1) + t.run]) continue;
        for (int e = head[t.u]; e != -1; e = nxt[e]) {
            int v = edges[e][1], next = labels[v] == labels[t.u] ? t.run + 1 : 1;
            long long nd = t.d + edges[e][2];
            if (next <= k && nd < dist[v * (k + 1) + next]) {
                dist[v * (k + 1) + next] = nd;
                push(&h, &size, &cap, (Item){nd, v, next});
            }
        }
    }
    free(head);
    free(nxt);
    free(h);
    free(dist);
    return (int)ans;
}
*/

typedef struct {
    long long d;
    int u, run;
} Item;

void push(Item** h, int* size, int* cap, Item x) {
    if (*size == *cap) {
        *cap *= 2;
        *h = (Item*)realloc(*h, sizeof(Item) * *cap);
    }
    int i = (*size)++;
    while (i > 0 && (*h)[(i - 1) / 2].d > x.d) {
        (*h)[i] = (*h)[(i - 1) / 2];
        i = (i - 1) / 2;
    }
    (*h)[i] = x;
}

Item pop(Item* h, int* size) {
    Item top = h[0], last = h[--(*size)];
    int i = 0;
    while (2 * i + 1 < *size) {
        int c = 2 * i + 1;
        if (c + 1 < *size && h[c + 1].d < h[c].d) c++;
        if (h[c].d >= last.d) break;
        h[i] = h[c];
        i = c;
    }
    h[i] = last;
    return top;
}

int shortestPath(int n, int** edges, int edgesSize, int* edgesColSize, char* labels, int k) {
    int* head = (int*)malloc(sizeof(int) * n);
    int* nxt = (int*)malloc(sizeof(int) * (edgesSize + 1));
    for (int i = 0; i < n; i++) head[i] = -1;
    for (int i = 0; i < edgesSize; i++) {
        nxt[i] = head[edges[i][0]];
        head[edges[i][0]] = i;
    }
    int size = 0, cap = 16;
    Item* h = (Item*)malloc(sizeof(Item) * cap);
    int* best = (int*)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) best[i] = k + 1;
    push(&h, &size, &cap, (Item){0, 0, 1});
    long long ans = -1;
    while (size > 0) {
        Item t = pop(h, &size);
        if (t.run >= best[t.u]) continue;
        if (t.u == n - 1) {
            ans = t.d;
            break;
        }
        best[t.u] = t.run;
        for (int e = head[t.u]; e != -1; e = nxt[e]) {
            int v = edges[e][1], next = labels[v] == labels[t.u] ? t.run + 1 : 1;
            if (next <= k && next < best[v]) push(&h, &size, &cap, (Item){t.d + edges[e][2], v, next});
        }
    }
    free(head);
    free(nxt);
    free(h);
    free(best);
    return (int)ans;
}