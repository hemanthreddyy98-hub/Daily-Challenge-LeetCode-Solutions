/*
Brute Force

int closedIsland(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int dr[4] = {1, -1, 0, 0}, dc[4] = {0, 0, 1, -1};
    int* stack = (int*)malloc(sizeof(int) * m * n);
    bool* seen = (bool*)malloc(sizeof(bool) * m * n);
    int count = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] != 0) continue;
            memset(seen, 0, sizeof(bool) * m * n);
            int top = 0;
            stack[top++] = i * n + j;
            seen[i * n + j] = true;
            bool closed = true, first = true;
            while (top > 0) {
                int id = stack[--top];
                int r = id / n, c = id % n;
                if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                if (id < i * n + j) first = false;
                for (int k = 0; k < 4; k++) {
                    int nr = r + dr[k], nc = c + dc[k];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0 && !seen[nr * n + nc]) {
                        seen[nr * n + nc] = true;
                        stack[top++] = nr * n + nc;
                    }
                }
            }
            if (closed && first) count++;
        }
    }
    free(stack);
    free(seen);
    return count;
}
*/

/*
Better Approach

void sink(int** grid, int m, int n, int r, int c) {
    if (r < 0 || c < 0 || r >= m || c >= n || grid[r][c] != 0) return;
    grid[r][c] = 1;
    sink(grid, m, n, r + 1, c);
    sink(grid, m, n, r - 1, c);
    sink(grid, m, n, r, c + 1);
    sink(grid, m, n, r, c - 1);
}

int closedIsland(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    for (int i = 0; i < m; i++) {
        sink(grid, m, n, i, 0);
        sink(grid, m, n, i, n - 1);
    }
    for (int j = 0; j < n; j++) {
        sink(grid, m, n, 0, j);
        sink(grid, m, n, m - 1, j);
    }
    int count = 0;
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (grid[i][j] == 0) {
                sink(grid, m, n, i, j);
                count++;
            }
    return count;
}
*/

int closedIsland(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int* q = (int*)malloc(sizeof(int) * m * n);
    int dr[4] = {1, -1, 0, 0}, dc[4] = {0, 0, 1, -1};
    int count = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] != 0) continue;
            int head = 0, tail = 0;
            bool closed = true;
            grid[i][j] = 1;
            q[tail++] = i * n + j;
            while (head < tail) {
                int id = q[head++];
                int r = id / n, c = id % n;
                if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                for (int k = 0; k < 4; k++) {
                    int nr = r + dr[k], nc = c + dc[k];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0) {
                        grid[nr][nc] = 1;
                        q[tail++] = nr * n + nc;
                    }
                }
            }
            if (closed) count++;
        }
    }
    free(q);
    return count;
}