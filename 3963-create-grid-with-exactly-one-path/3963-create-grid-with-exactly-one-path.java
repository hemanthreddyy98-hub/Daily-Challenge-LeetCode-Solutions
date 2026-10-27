/*
Brute Force

class Solution {
    public String[] createGrid(int m, int n) {
        char[][] g = new char[m][n];
        for (char[] row : g) Arrays.fill(row, '.');
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
                g[i][j] = '#';
                if (!reach(g, 0, 0)) g[i][j] = '.';
            }
        String[] ans = new String[m];
        for (int i = 0; i < m; i++) ans[i] = new String(g[i]);
        return ans;
    }

    boolean reach(char[][] g, int r, int c) {
        if (r >= g.length || c >= g[0].length || g[r][c] == '#') return false;
        if (r == g.length - 1 && c == g[0].length - 1) return true;
        return reach(g, r + 1, c) || reach(g, r, c + 1);
    }
}
*/

/*
Better Approach

class Solution {
    public String[] createGrid(int m, int n) {
        char[][] g = new char[m][n];
        for (char[] row : g) Arrays.fill(row, '.');
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if ((i == 0 && j == 0) || (i == m - 1 && j == n - 1)) continue;
                g[i][j] = '#';
                if (!reach(g)) g[i][j] = '.';
            }
        String[] ans = new String[m];
        for (int i = 0; i < m; i++) ans[i] = new String(g[i]);
        return ans;
    }

    boolean reach(char[][] g) {
        int m = g.length, n = g[0].length;
        boolean[][] ok = new boolean[m][n];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                if (g[i][j] == '#') continue;
                ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1]);
            }
        return ok[m - 1][n - 1];
    }
}
*/

class Solution {
    public String[] createGrid(int m, int n) {
        String[] g = new String[m];
        g[0] = ".".repeat(n);
        String rest = "#".repeat(n - 1) + ".";
        for (int i = 1; i < m; i++) g[i] = rest;
        return g;
    }
}