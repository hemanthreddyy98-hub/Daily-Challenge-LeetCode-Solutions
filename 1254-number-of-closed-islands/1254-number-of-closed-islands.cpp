/*
Brute Force

class Solution {
public:
    int closedIsland(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        int dr[4] = {1, -1, 0, 0}, dc[4] = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] != 0) continue;
                vector<vector<bool>> seen(m, vector<bool>(n, false));
                vector<pair<int, int>> st = {{i, j}};
                seen[i][j] = true;
                bool closed = true, first = true;
                while (!st.empty()) {
                    auto [r, c] = st.back();
                    st.pop_back();
                    if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false;
                    if (r * n + c < i * n + j) first = false;
                    for (int k = 0; k < 4; k++) {
                        int nr = r + dr[k], nc = c + dc[k];
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0 && !seen[nr][nc]) {
                            seen[nr][nc] = true;
                            st.push_back({nr, nc});
                        }
                    }
                }
                if (closed && first) count++;
            }
        }
        return count;
    }
};
*/

/*
Better Approach

class Solution {
public:
    int closedIsland(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        for (int i = 0; i < m; i++) {
            sink(grid, i, 0);
            sink(grid, i, n - 1);
        }
        for (int j = 0; j < n; j++) {
            sink(grid, 0, j);
            sink(grid, m - 1, j);
        }
        int count = 0;
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                if (grid[i][j] == 0) {
                    sink(grid, i, j);
                    count++;
                }
        return count;
    }

    void sink(vector<vector<int>>& grid, int r, int c) {
        if (r < 0 || c < 0 || r >= (int)grid.size() || c >= (int)grid[0].size() || grid[r][c] != 0) return;
        grid[r][c] = 1;
        sink(grid, r + 1, c);
        sink(grid, r - 1, c);
        sink(grid, r, c + 1);
        sink(grid, r, c - 1);
    }
};
*/

class Solution {
public:
    int closedIsland(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<int> q(m * n);
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
        return count;
    }
};