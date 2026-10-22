/*
Brute Force

static int best;

static void dfs(char** grid, int m, int n, int r, int c, int steps) {
    if (r < 0 || c < 0 || r >= m || c >= n) return;
    char ch = grid[r][c];
    if (ch == 'X' || ch == 'V') return;
    if (ch == '#') {
        if (steps < best) best = steps;
        return;
    }
    grid[r][c] = 'V';
    dfs(grid, m, n, r + 1, c, steps + 1);
    dfs(grid, m, n, r - 1, c, steps + 1);
    dfs(grid, m, n, r, c + 1, steps + 1);
    dfs(grid, m, n, r, c - 1, steps + 1);
    grid[r][c] = ch;
}

int getFood(char** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    best = INT_MAX;
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (grid[i][j] == '*') dfs(grid, m, n, i, j, 0);
    return best == INT_MAX ? -1 : best;
}
*/

/*
Basic Approach

int getFood(char** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int* qr = (int*)malloc(sizeof(int) * m * n);
    int* qc = (int*)malloc(sizeof(int) * m * n);
    bool* visited = (bool*)calloc(m * n, sizeof(bool));
    int head = 0, tail = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == '*') {
                qr[tail] = i;
                qc[tail++] = j;
                visited[i * n + j] = true;
            }
        }
    }
    int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    int steps = 0, ans = -1;
    while (head < tail && ans == -1) {
        int size = tail - head;
        for (int k = 0; k < size; k++) {
            int r0 = qr[head], c0 = qc[head++];
            if (grid[r0][c0] == '#') {
                ans = steps;
                break;
            }
            for (int d = 0; d < 4; d++) {
                int r = r0 + dirs[d][0], c = c0 + dirs[d][1];
                if (r >= 0 && c >= 0 && r < m && c < n && !visited[r * n + c] && grid[r][c] != 'X') {
                    visited[r * n + c] = true;
                    qr[tail] = r;
                    qc[tail++] = c;
                }
            }
        }
        steps++;
    }
    free(qr);
    free(qc);
    free(visited);
    return ans;
}
*/

int getFood(char** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];

    int start = -1;
    for (int i = 0; i < m && start < 0; i++)
        for (int j = 0; j < n; j++)
            if (grid[i][j] == '*') { start = i * n + j; break; }
    if (start < 0) return -1;

    int* q = (int*)malloc(sizeof(int) * m * n);
    int head = 0, tail = 0;
    q[tail++] = start;
    const int dr[4] = {1, -1, 0, 0};
    const int dc[4] = {0, 0, 1, -1};
    int steps = 0;

    while (head < tail) {
        steps++;
        int levelEnd = tail;
        while (head < levelEnd) {
            int id = q[head++];
            int r = id / n, c = id % n;
            for (int k = 0; k < 4; k++) {
                int nr = r + dr[k], nc = c + dc[k];
                if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
                char ch = grid[nr][nc];
                if (ch == '#') { free(q); return steps; }
                if (ch == 'O') {
                    grid[nr][nc] = 'X';
                    q[tail++] = nr * n + nc;
                }
            }
        }
    }
    free(q);
    return -1;
}