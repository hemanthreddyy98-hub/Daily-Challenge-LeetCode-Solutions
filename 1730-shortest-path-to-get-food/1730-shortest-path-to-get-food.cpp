/*
Brute Force

class Solution {
public:
    int getFood(vector<vector<char>>& grid) {
        best = INT_MAX;
        for (int i = 0; i < (int)grid.size(); i++)
            for (int j = 0; j < (int)grid[0].size(); j++)
                if (grid[i][j] == '*') dfs(grid, i, j, 0);
        return best == INT_MAX ? -1 : best;
    }

private:
    int best;

    void dfs(vector<vector<char>>& grid, int r, int c, int steps) {
        if (r < 0 || c < 0 || r >= (int)grid.size() || c >= (int)grid[0].size()) return;
        char ch = grid[r][c];
        if (ch == 'X' || ch == 'V') return;
        if (ch == '#') {
            best = min(best, steps);
            return;
        }
        grid[r][c] = 'V';
        dfs(grid, r + 1, c, steps + 1);
        dfs(grid, r - 1, c, steps + 1);
        dfs(grid, r, c + 1, steps + 1);
        dfs(grid, r, c - 1, steps + 1);
        grid[r][c] = ch;
    }
};
*/

/*
Basic Approach

class Solution {
public:
    int getFood(vector<vector<char>>& grid) {
        int m = grid.size(), n = grid[0].size();
        queue<pair<int, int>> q;
        vector<vector<bool>> visited(m, vector<bool>(n, false));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == '*') {
                    q.push({i, j});
                    visited[i][j] = true;
                }
            }
        }
        int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        int steps = 0;
        while (!q.empty()) {
            int size = q.size();
            for (int k = 0; k < size; k++) {
                auto [r0, c0] = q.front();
                q.pop();
                if (grid[r0][c0] == '#') return steps;
                for (auto& d : dirs) {
                    int r = r0 + d[0], c = c0 + d[1];
                    if (r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != 'X') {
                        visited[r][c] = true;
                        q.push({r, c});
                    }
                }
            }
            steps++;
        }
        return -1;
    }
};
*/

class Solution {
public:
    int getFood(vector<vector<char>>& grid) {
        int m = grid.size(), n = grid[0].size();

        int start = -1;
        for (int i = 0; i < m && start < 0; i++)
            for (int j = 0; j < n; j++)
                if (grid[i][j] == '*') { start = i * n + j; break; }
        if (start < 0) return -1;

        vector<int> q(m * n);
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
                    if (ch == '#') return steps;
                    if (ch == 'O') {
                        grid[nr][nc] = 'X';
                        q[tail++] = nr * n + nc;
                    }
                }
            }
        }
        return -1;
    }
};