/*
Brute Force

int countIslands(int** grid, int gridSize, int* gridColSize, int k) {
    int m = gridSize, n = gridColSize[0];
    int dr[4] = {1, -1, 0, 0}, dc[4] = {0, 0, 1, -1};
    int* stack = (int*)malloc(sizeof(int) * m * n);
    bool* seen = (bool*)malloc(sizeof(bool) * m * n);
    int count = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0) continue;
            memset(seen, 0, sizeof(bool) * m * n);
            int top = 0;
            stack[top++] = i * n + j;
            seen[i * n + j] = true;
            long long sum = 0;
            bool first = true;
            while (top > 0) {
                int id = stack[--top];
                int r = id / n, c = id % n;
                sum += grid[r][c];
                if (id < i * n + j) first = false;
                for (int d = 0; d < 4; d++) {
                    int nr = r + dr[d], nc = c + dc[d];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 && !seen[nr * n + nc]) {
                        seen[nr * n + nc] = true;
                        stack[top++] = nr * n + nc;
                    }
                }
            }
            if (first && sum % k == 0) count++;
        }
    }
    free(stack);
    free(seen);
    return count;
}
*/

/*
Better Approach

int countIslands(int** grid, int gridSize, int* gridColSize, int k) {
    int m = gridSize, n = gridColSize[0];
    bool* visited = (bool*)calloc(m * n, sizeof(bool));
    int* qr = (int*)malloc(sizeof(int) * m * n);
    int* qc = (int*)malloc(sizeof(int) * m * n);
    int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    int count = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0 || visited[i * n + j]) continue;
            int head = 0, tail = 0;
            qr[tail] = i;
            qc[tail++] = j;
            visited[i * n + j] = true;
            long long sum = 0;
            while (head < tail) {
                int r0 = qr[head], c0 = qc[head++];
                sum += grid[r0][c0];
                for (int d = 0; d < 4; d++) {
                    int r = r0 + dirs[d][0], c = c0 + dirs[d][1];
                    if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r * n + c]) {
                        visited[r * n + c] = true;
                        qr[tail] = r;
                        qc[tail++] = c;
                    }
                }
            }
            if (sum % k == 0) count++;
        }
    }
    free(visited);
    free(qr);
    free(qc);
    return count;
}
*/

int countIslands(int** grid, int gridSize, int* gridColSize, int k) {
    int m = gridSize, n = gridColSize[0];
    int* q = (int*)malloc(sizeof(int) * m * n);
    int dr[4] = {1, -1, 0, 0}, dc[4] = {0, 0, 1, -1};
    int count = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0) continue;
            int head = 0, tail = 0;
            int sum = grid[i][j] % k;
            grid[i][j] = 0;
            q[tail++] = i * n + j;
            while (head < tail) {
                int id = q[head++];
                int r = id / n, c = id % n;
                for (int d = 0; d < 4; d++) {
                    int nr = r + dr[d], nc = c + dc[d];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0) {
                        sum = (sum + grid[nr][nc]) % k;
                        grid[nr][nc] = 0;
                        q[tail++] = nr * n + nc;
                    }
                }
            }
            if (sum == 0) count++;
        }
    }
    free(q);
    return count;
}