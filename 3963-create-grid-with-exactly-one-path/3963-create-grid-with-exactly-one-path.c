/*
Brute Force

bool reach(char** g, int m, int n, int r, int c) {
    if (r >= m || c >= n || g[r][c] == '#') return false;
    if (r == m - 1 && c == n - 1) return true;
    return reach(g, m, n, r + 1, c) || reach(g, m, n, r, c + 1);
}

char** createGrid(int m, int n, int* returnSize) {
    char** g = (char**)malloc(sizeof(char*) * m);
    for (int i = 0; i < m; i++) {
        g[i] = (char*)malloc(n + 1);
        memset(g[i], '.', n);
        g[i][n] = '\0';
    }
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) {
            if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
            g[i][j] = '#';
            if (!reach(g, m, n, 0, 0)) g[i][j] = '.';
        }
    *returnSize = m;
    return g;
}
*/

/*
Better Approach

bool reach(char** g, int m, int n) {
    bool* ok = (bool*)calloc(m * n, sizeof(bool));
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) {
            if (g[i][j] == '#') continue;
            ok[i * n + j] = (i == 0 && j == 0) || (i > 0 && ok[(i - 1) * n + j]) || (j > 0 && ok[i * n + j - 1]);
        }
    bool res = ok[m * n - 1];
    free(ok);
    return res;
}

char** createGrid(int m, int n, int* returnSize) {
    char** g = (char**)malloc(sizeof(char*) * m);
    for (int i = 0; i < m; i++) {
        g[i] = (char*)malloc(n + 1);
        memset(g[i], '.', n);
        g[i][n] = '\0';
    }
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) {
            if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
            g[i][j] = '#';
            if (!reach(g, m, n)) g[i][j] = '.';
        }
    *returnSize = m;
    return g;
}
*/

char** createGrid(int m, int n, int* returnSize) {
    char** g = (char**)malloc(sizeof(char*) * m);
    for (int i = 0; i < m; i++) {
        g[i] = (char*)malloc(n + 1);
        memset(g[i], i == 0 ? '.' : '#', n);
        g[i][n - 1] = '.';
        g[i][n] = '\0';
    }
    *returnSize = m;
    return g;
}