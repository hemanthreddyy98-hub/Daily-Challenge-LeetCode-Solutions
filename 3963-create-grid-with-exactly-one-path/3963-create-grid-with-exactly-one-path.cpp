/*
Brute Force

class Solution {
public:
    vector<string> createGrid(int m, int n) {
        vector<string> g(m, string(n, '.'));
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
                g[i][j] = '#';
                if (!reach(g, 0, 0)) g[i][j] = '.';
            }
        return g;
    }

    bool reach(vector<string>& g, int r, int c) {
        if (r >= (int)g.size() || c >= (int)g[0].size() || g[r][c] == '#') return false;
        if (r == (int)g.size() - 1 && c == (int)g[0].size() - 1) return true;
        return reach(g, r + 1, c) || reach(g, r, c + 1);
    }
};
*/

/*
Better Approach

class Solution {
public:
    vector<string> createGrid(int m, int n) {
        vector<string> g(m, string(n, '.'));
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
                g[i][j] = '#';
                if (!reach(g)) g[i][j] = '.';
            }
        return g;
    }

    bool reach(vector<string>& g) {
        int m = g.size(), n = g[0].size();
        vector<vector<bool>> ok(m, vector<bool>(n, false));
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if (g[i][j] == '#') continue;
                ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1]);
            }
        return ok[m - 1][n - 1];
    }
};
*/

class Solution {
public:
    vector<string> createGrid(int m, int n) {
        vector<string> g(m, string(n, '#'));
        g[0] = string(n, '.');
        for (int i = 0; i < m; i++) g[i][n - 1] = '.';
        return g;
    }
};