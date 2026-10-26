/*
Brute Force

class Solution {
public:
    int countIslands(vector<vector<int>>& grid, int k) {
        int m = grid.size(), n = grid[0].size();
        int dr[4] = {1, -1, 0, 0}, dc[4] = {0, 0, 1, -1};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) continue;
                vector<vector<bool>> seen(m, vector<bool>(n, false));
                vector<pair<int, int>> st = {{i, j}};
                seen[i][j] = true;
                long long sum = 0;
                bool first = true;
                while (!st.empty()) {
                    auto [r, c] = st.back();
                    st.pop_back();
                    sum += grid[r][c];
                    if (r * n + c < i * n + j) first = false;
                    for (int d = 0; d < 4; d++) {
                        int nr = r + dr[d], nc = c + dc[d];
                        if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 && !seen[nr][nc]) {
                            seen[nr][nc] = true;
                            st.push_back({nr, nc});
                        }
                    }
                }
                if (first && sum % k == 0) count++;
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
    int countIslands(vector<vector<int>>& grid, int k) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<bool>> visited(m, vector<bool>(n, false));
        int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 || visited[i][j]) continue;
                queue<pair<int, int>> q;
                q.push({i, j});
                visited[i][j] = true;
                long long sum = 0;
                while (!q.empty()) {
                    auto [r0, c0] = q.front();
                    q.pop();
                    sum += grid[r0][c0];
                    for (auto& d : dirs) {
                        int r = r0 + d[0], c = c0 + d[1];
                        if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r][c]) {
                            visited[r][c] = true;
                            q.push({r, c});
                        }
                    }
                }
                if (sum % k == 0) count++;
            }
        }
        return count;
    }
};
*/

class Solution {
public:
    int countIslands(vector<vector<int>>& grid, int k) {
        int m = grid.size(), n = grid[0].size();
        vector<int> q(m * n);
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
        return count;
    }
};