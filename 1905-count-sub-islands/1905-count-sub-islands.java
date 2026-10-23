class Solution {
    public int countSubIslands(int[][] grid1, int[][] grid2) {
        int m = grid2.length, n = grid2[0].length, res = 0;
        int[][] d = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid2[i][j] == 1) {
                    boolean sub = true;
                    ArrayDeque<int[]> st = new ArrayDeque<>();
                    st.push(new int[]{i, j});
                    grid2[i][j] = 0;
                    while (!st.isEmpty()) {
                        int[] c = st.pop();
                        if (grid1[c[0]][c[1]] == 0) sub = false;
                        for (int[] x : d) {
                            int r = c[0] + x[0], cc = c[1] + x[1];
                            if (r >= 0 && r < m && cc >= 0 && cc < n && grid2[r][cc] == 1) {
                                grid2[r][cc] = 0;
                                st.push(new int[]{r, cc});
                            }
                        }
                    }
                    if (sub) res++;
                }
            }
        }
        return res;
    }
}