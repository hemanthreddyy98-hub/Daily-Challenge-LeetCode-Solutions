/*
Brute Force

public class Solution {
    public string[] CreateGrid(int m, int n) {
        char[][] g = new char[m][];
        for (int i = 0; i < m; i++) g[i] = new string('.', n).ToCharArray();
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
                g[i][j] = '#';
                if (!Reach(g, 0, 0)) g[i][j] = '.';
            }
        string[] ans = new string[m];
        for (int i = 0; i < m; i++) ans[i] = new string(g[i]);
        return ans;
    }

    bool Reach(char[][] g, int r, int c) {
        if (r >= g.Length || c >= g[0].Length || g[r][c] == '#') return false;
        if (r == g.Length - 1 && c == g[0].Length - 1) return true;
        return Reach(g, r + 1, c) || Reach(g, r, c + 1);
    }
}
*/

/*
Better Approach

public class Solution {
    public string[] CreateGrid(int m, int n) {
        char[][] g = new char[m][];
        for (int i = 0; i < m; i++) g[i] = new string('.', n).ToCharArray();
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
                g[i][j] = '#';
                if (!Reach(g)) g[i][j] = '.';
            }
        string[] ans = new string[m];
        for (int i = 0; i < m; i++) ans[i] = new string(g[i]);
        return ans;
    }

    bool Reach(char[][] g) {
        int m = g.Length, n = g[0].Length;
        bool[,] ok = new bool[m, n];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if (g[i][j] == '#') continue;
                ok[i, j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1, j]) || (j > 0 && ok[i, j - 1]);
            }
        return ok[m - 1, n - 1];
    }
}
*/

public class Solution {
    public string[] CreateGrid(int m, int n) {
        string[] g = new string[m];
        g[0] = new string('.', n);
        string rest = new string('#', n - 1) + ".";
        for (int i = 1; i < m; i++) g[i] = rest;
        return g;
    }
}