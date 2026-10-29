/*
Brute Force

bool* palindromePath(int n, int** edges, int edgesSize, int* edgesColSize, char* s, char** queries, int queriesSize, int* returnSize) {
    int* head = (int*)malloc(sizeof(int) * n);
    int* nxt = (int*)malloc(sizeof(int) * 2 * n);
    int* to = (int*)malloc(sizeof(int) * 2 * n);
    int* ch = (int*)malloc(sizeof(int) * n);
    bool* ans = (bool*)malloc(sizeof(bool) * queriesSize);
    int m = 0, k = 0;
    for (int i = 0; i < n; i++) {
        head[i] = -1;
        ch[i] = s[i] - 'a';
    }
    for (int i = 0; i < edgesSize; i++) {
        int a = edges[i][0], b = edges[i][1];
        to[m] = b;
        nxt[m] = head[a];
        head[a] = m++;
        to[m] = a;
        nxt[m] = head[b];
        head[b] = m++;
    }
    int* par = (int*)malloc(sizeof(int) * n);
    int* que = (int*)malloc(sizeof(int) * n);
    for (int i = 0; i < queriesSize; i++) {
        char type[8], arg[16];
        int u;
        sscanf(queries[i], "%7s %d %15s", type, &u, arg);
        if (type[0] == 'u') {
            ch[u] = arg[0] - 'a';
            continue;
        }
        int v = atoi(arg);
        for (int x = 0; x < n; x++) par[x] = -1;
        par[u] = u;
        int qh = 0, qt = 0;
        que[qt++] = u;
        while (qh < qt) {
            int x = que[qh++];
            for (int e = head[x]; e != -1; e = nxt[e])
                if (par[to[e]] == -1) {
                    par[to[e]] = x;
                    que[qt++] = to[e];
                }
        }
        int mask = 1 << ch[u];
        for (int cur = v; cur != u; cur = par[cur]) mask ^= 1 << ch[cur];
        ans[k++] = (mask & (mask - 1)) == 0;
    }
    free(head);
    free(nxt);
    free(to);
    free(ch);
    free(par);
    free(que);
    *returnSize = k;
    return ans;
}
*/

/*
Better Approach

bool* palindromePath(int n, int** edges, int edgesSize, int* edgesColSize, char* s, char** queries, int queriesSize, int* returnSize) {
    int* head = (int*)malloc(sizeof(int) * n);
    int* nxt = (int*)malloc(sizeof(int) * 2 * n);
    int* to = (int*)malloc(sizeof(int) * 2 * n);
    int* ch = (int*)malloc(sizeof(int) * n);
    bool* ans = (bool*)malloc(sizeof(bool) * queriesSize);
    int m = 0, k = 0;
    for (int i = 0; i < n; i++) {
        head[i] = -1;
        ch[i] = s[i] - 'a';
    }
    for (int i = 0; i < edgesSize; i++) {
        int a = edges[i][0], b = edges[i][1];
        to[m] = b;
        nxt[m] = head[a];
        head[a] = m++;
        to[m] = a;
        nxt[m] = head[b];
        head[b] = m++;
    }
    int* par = (int*)malloc(sizeof(int) * n);
    int* depth = (int*)calloc(n, sizeof(int));
    int* que = (int*)malloc(sizeof(int) * n);
    for (int x = 0; x < n; x++) par[x] = -1;
    par[0] = 0;
    int qh = 0, qt = 0;
    que[qt++] = 0;
    while (qh < qt) {
        int x = que[qh++];
        for (int e = head[x]; e != -1; e = nxt[e])
            if (par[to[e]] == -1) {
                par[to[e]] = x;
                depth[to[e]] = depth[x] + 1;
                que[qt++] = to[e];
            }
    }
    for (int i = 0; i < queriesSize; i++) {
        char type[8], arg[16];
        int u;
        sscanf(queries[i], "%7s %d %15s", type, &u, arg);
        if (type[0] == 'u') {
            ch[u] = arg[0] - 'a';
            continue;
        }
        int v = atoi(arg);
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
        ans[k++] = (mask & (mask - 1)) == 0;
    }
    free(head);
    free(nxt);
    free(to);
    free(ch);
    free(par);
    free(depth);
    free(que);
    *returnSize = k;
    return ans;
}
*/

void add(int* bit, int n, int i, int d) {
    for (; i <= n; i += i & -i) bit[i] ^= d;
}

int prefix(int* bit, int i) {
    int r = 0;
    for (; i > 0; i -= i & -i) r ^= bit[i];
    return r;
}

bool* palindromePath(int n, int** edges, int edgesSize, int* edgesColSize, char* s, char** queries, int queriesSize, int* returnSize) {
    int* head = (int*)malloc(sizeof(int) * n);
    int* nxt = (int*)malloc(sizeof(int) * 2 * n);
    int* to = (int*)malloc(sizeof(int) * 2 * n);
    int* ch = (int*)malloc(sizeof(int) * n);
    bool* ans = (bool*)malloc(sizeof(bool) * queriesSize);
    int m = 0, k = 0;
    for (int i = 0; i < n; i++) {
        head[i] = -1;
        ch[i] = s[i] - 'a';
    }
    for (int i = 0; i < edgesSize; i++) {
        int a = edges[i][0], b = edges[i][1];
        to[m] = b;
        nxt[m] = head[a];
        head[a] = m++;
        to[m] = a;
        nxt[m] = head[b];
        head[b] = m++;
    }
    const int LOG = 17;
    int* up = (int*)calloc(LOG * n, sizeof(int));
    int* depth = (int*)calloc(n, sizeof(int));
    int* tin = (int*)malloc(sizeof(int) * n);
    int* sz = (int*)malloc(sizeof(int) * n);
    int* order = (int*)malloc(sizeof(int) * n);
    int* st = (int*)malloc(sizeof(int) * n);
    bool* seen = (bool*)calloc(n, sizeof(bool));
    int* bit = (int*)calloc(n + 1, sizeof(int));
    int top = 0, timer = 0;
    st[top++] = 0;
    seen[0] = true;
    while (top > 0) {
        int x = st[--top];
        tin[x] = timer;
        order[timer++] = x;
        for (int e = head[x]; e != -1; e = nxt[e])
            if (!seen[to[e]]) {
                seen[to[e]] = true;
                up[to[e]] = x;
                depth[to[e]] = depth[x] + 1;
                st[top++] = to[e];
            }
    }
    for (int x = 0; x < n; x++) sz[x] = 1;
    for (int i = n - 1; i > 0; i--) sz[up[order[i]]] += sz[order[i]];
    for (int j = 1; j < LOG; j++)
        for (int x = 0; x < n; x++) up[j * n + x] = up[(j - 1) * n + up[(j - 1) * n + x]];
    for (int x = 0; x < n; x++) {
        add(bit, n, tin[x] + 1, 1 << ch[x]);
        add(bit, n, tin[x] + sz[x] + 1, 1 << ch[x]);
    }
    for (int i = 0; i < queriesSize; i++) {
        char type[8], arg[16];
        int u;
        sscanf(queries[i], "%7s %d %15s", type, &u, arg);
        if (type[0] == 'u') {
            int d = (1 << ch[u]) ^ (1 << (arg[0] - 'a'));
            add(bit, n, tin[u] + 1, d);
            add(bit, n, tin[u] + sz[u] + 1, d);
            ch[u] = arg[0] - 'a';
            continue;
        }
        int v = atoi(arg);
        int a = u, b = v;
        if (depth[a] < depth[b]) {
            a = v;
            b = u;
        }
        for (int j = LOG - 1; j >= 0; j--)
            if (depth[a] - (1 << j) >= depth[b]) a = up[j * n + a];
        if (a != b) {
            for (int j = LOG - 1; j >= 0; j--)
                if (up[j * n + a] != up[j * n + b]) {
                    a = up[j * n + a];
                    b = up[j * n + b];
                }
            a = up[a];
        }
        int mask = prefix(bit, tin[u] + 1) ^ prefix(bit, tin[v] + 1) ^ (1 << ch[a]);
        ans[k++] = (mask & (mask - 1)) == 0;
    }
    free(head);
    free(nxt);
    free(to);
    free(ch);
    free(up);
    free(depth);
    free(tin);
    free(sz);
    free(order);
    free(st);
    free(seen);
    free(bit);
    *returnSize = k;
    return ans;
}