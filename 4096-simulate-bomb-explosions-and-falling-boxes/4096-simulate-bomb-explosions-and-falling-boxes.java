class Solution {
    public char[][] finalGrid(char[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[] cand = new int[m * n];
        int cc = 0;
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (grid[r][c] == '*') cand[cc++] = r * n + c;
        boolean[] act = new boolean[n];
        java.util.Arrays.fill(act, true);
        int[] mark = new int[m * n];
        int[] exp = new int[m * n];
        boolean[] fall = new boolean[m];
        int[] dr = {-1, 1, 0, 0};
        int[] dc = {0, 0, -1, 1};
        int round = 0;
        while (true) {
            round++;
            int ec = 0;
            for (int i = 0; i < cc; i++) {
                int r = cand[i] / n, c = cand[i] % n;
                for (int d = 0; d < 4; d++) {
                    int nr = r + dr[d], nc = c + dc[d];
                    if (nr >= 0 && nr < m && nc >= 0 && nc < n && grid[nr][nc] == '#') {
                        exp[ec++] = cand[i];
                        break;
                    }
                }
            }
            for (int i = 0; i < ec; i++) {
                int r = exp[i] / n, c = exp[i] % n;
                for (int a = r - 1; a <= r + 1; a++)
                    for (int b = c - 1; b <= c + 1; b++)
                        if (a >= 0 && a < m && b >= 0 && b < n && grid[a][b] == '#') {
                            grid[a][b] = '-';
                            act[b] = true;
                        }
            }
            int[] ncand = new int[m * n];
            int ncc = 0;
            boolean[] nact = new boolean[n];
            boolean any = false;
            for (int c = 0; c < n; c++) {
                if (!act[c]) continue;
                boolean sup = true;
                for (int r = m - 1; r >= 0; r--) {
                    char ch = grid[r][c];
                    if (ch == '*') {
                        fall[r] = false;
                        sup = true;
                    } else if (ch == '-') {
                        fall[r] = false;
                        sup = false;
                    } else {
                        fall[r] = !sup;
                    }
                }
                boolean moved = false;
                for (int r = m - 2; r >= 0; r--) {
                    if (!fall[r]) continue;
                    grid[r][c] = '-';
                    grid[r + 1][c] = '#';
                    moved = true;
                    int rr = r + 1;
                    for (int d = 0; d < 4; d++) {
                        int nr = rr + dr[d], nc = c + dc[d];
                        if (nr >= 0 && nr < m && nc >= 0 && nc < n && grid[nr][nc] == '*') {
                            int id = nr * n + nc;
                            if (mark[id] != round) {
                                mark[id] = round;
                                ncand[ncc++] = id;
                            }
                        }
                    }
                }
                if (moved) {
                    nact[c] = true;
                    any = true;
                }
            }
            cand = ncand;
            cc = ncc;
            act = nact;
            if (cc == 0 && !any) break;
        }
        return grid;
    }
}